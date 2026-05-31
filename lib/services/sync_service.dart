import 'dart:convert';
import '../database/local_repository.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../models/quote.dart';
import '../models/task.dart';
import '../models/inventory_item.dart';
import '../models/inventory_movement.dart';
import '../models/budget.dart';
import 'api_service.dart';

class SyncService {
  final ApiService _api;
  final LocalRepository _repo;
  bool _syncing = false;

  SyncService(this._api, this._repo);

  bool get isSyncing => _syncing;

  /// Sync completo: push ops pendientes → pull todos los datos.
  Future<SyncResult> fullSync() async {
    if (_syncing) return SyncResult(pendingPushed: 0, errors: []);
    _syncing = true;
    final errors = <String>[];
    var pushed = 0;

    try {
      // 1. Push primero — así el servidor tiene los últimos datos antes del pull
      final pushResult = await _pushPendingOps();
      pushed = pushResult.pushed;
      errors.addAll(pushResult.errors);

      // 2. Pull todo en paralelo
      await _pullAll(errors);
    } catch (e) {
      errors.add('fullSync: $e');
    } finally {
      _syncing = false;
    }

    return SyncResult(pendingPushed: pushed, errors: errors);
  }

  // ─────────────────────────────────────────────────────────────────────
  // PUSH
  // ─────────────────────────────────────────────────────────────────────

  Future<_PushResult> _pushPendingOps() async {
    final ops = await _repo.getAllPendingOps();
    print('[SYNC] Iniciando push de operaciones pendientes');
    print('[SYNC] Total ops pendientes: ${ops.length}');
    var pushed = 0;
    final errors = <String>[];

    // Mapa tempId → realId para resolver dependencias entre ops de la misma sesión
    final Map<int, int> idMap = {};

    for (final op in ops) {
      // Descartar ops UPDATE/DELETE con IDs negativos en la URL:
      // la entidad nunca llegó al servidor, no hay nada que actualizar/borrar.
      if (op.endpoint.contains('/-')) {
        print('[SYNC] Descartando op con tempId en URL: ${op.endpoint}');
        await _repo.deletePendingOp(op.id);
        continue;
      }

      // Resolver referencias a tempIds en el payload usando el mapa acumulado
      String? resolvedPayload = op.payload;
      if (resolvedPayload != null && idMap.isNotEmpty) {
        final payloadMap =
            jsonDecode(resolvedPayload) as Map<String, dynamic>;
        bool changed = false;
        for (final entry in idMap.entries) {
          payloadMap.forEach((key, value) {
            if (value == entry.key) {
              payloadMap[key] = entry.value;
              changed = true;
              print('[SYNC] Resolviendo $key: ${entry.key} → ${entry.value}');
            }
          });
        }
        if (changed) {
          resolvedPayload = jsonEncode(payloadMap);
          await _repo.updatePendingOpPayload(op.id, resolvedPayload);
        }
      }

      print('[SYNC] Ejecutando: ${op.operation.toUpperCase()} ${op.endpoint}');
      print('[SYNC] Payload: $resolvedPayload');

      try {
        final body = resolvedPayload != null
            ? jsonDecode(resolvedPayload) as Map<String, dynamic>
            : <String, dynamic>{};

        dynamic response;
        switch (op.operation) {
          case 'create':
            response = await _api.post(op.endpoint, body);
          case 'update':
            response = await _api.put(op.endpoint, body);
          case 'delete':
            await _api.delete(op.endpoint);
        }

        // Si fue un CREATE con tempId, registrar el mapeo tempId → realId
        if (op.operation == 'create' && op.tempId != null) {
          final serverMap = response as Map<String, dynamic>?;
          final realId = serverMap?['id'] as int?;
          if (realId != null) {
            idMap[op.tempId!] = realId;
            print('[SYNC] Mapeado tempId ${op.tempId} → realId $realId');
            await _repo.updateLocalId(op.entityType, op.tempId!, realId);
          }
        }

        print('[SYNC] Op completada: ${op.id}');
        await _repo.deletePendingOp(op.id);
        pushed++;
      } on ApiOfflineException {
        print('[SYNC] Sin conexión, deteniendo push');
        break;
      } catch (e) {
        print('[SYNC] Op falló: $e');
        if (e is ApiException) {
          print('[SYNC] Status: ${e.statusCode}, Msg: ${e.message}');
        }
        print('[SYNC] Descartando op fallida: ${op.id}');
        await _repo.deletePendingOp(op.id);
        errors.add('DROPPED ${op.entityType}/${op.operation} (${op.endpoint}): $e');
      }
    }

    return _PushResult(pushed: pushed, errors: errors);
  }

  // ─────────────────────────────────────────────────────────────────────
  // PULL
  // ─────────────────────────────────────────────────────────────────────

  Future<void> _pullAll(List<String> errors) async {
    final now = DateTime.now();

    // Si hay ops pendientes sin enviar, omitir los clear() para no borrar
    // registros locales con tempId negativo que aún no llegaron al servidor.
    final pendingCount = await _repo.getPendingOpsCount();
    final skipClear = pendingCount > 0;
    if (skipClear) {
      print('[SYNC] Hay $pendingCount ops pendientes — omitiendo clear para proteger datos locales');
    }

    final futures = [
      _safePull('projects', errors, () => _pullProjects(skipClear: skipClear)),
      _safePull('transactions', errors, () => _pullTransactions(skipClear: skipClear)),
      _safePull('quotes', errors, _pullQuotes),
      _safePull('tasks', errors, _pullTasks),
      _safePull('inventory', errors, _pullInventory),
      _safePull('budgets', errors, () => _pullBudgets(now.month, now.year, skipClear: skipClear)),
      _safePull('chart', errors, _pullChartData),
    ];

    await Future.wait(futures);
  }

  Future<void> _safePull(
      String name, List<String> errors, Future<void> Function() fn) async {
    try {
      await fn();
    } on ApiOfflineException {
      errors.add('pull/$name: offline');
    } catch (e) {
      errors.add('pull/$name: $e');
    }
  }

  Future<void> _pullProjects({bool skipClear = false}) async {
    final data = await _api.get('/api/mobile/projects');
    final list =
        (data as List).map((e) => Project.fromJson(e as Map<String, dynamic>)).toList();
    if (!skipClear) await _repo.clearProjects();
    await _repo.upsertProjects(list);
  }

  Future<void> _pullTransactions({bool skipClear = false}) async {
    final data = await _api.get('/api/mobile/transactions');
    final list = (data as List)
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
    if (!skipClear) await _repo.clearTransactions();
    await _repo.upsertTransactions(list);
  }

  Future<void> _pullQuotes() async {
    final data = await _api.get('/api/mobile/quotes');
    final list = (data as List)
        .map((e) => Quote.fromJson(e as Map<String, dynamic>))
        .toList();
    await _repo.upsertQuotes(list);
  }

  Future<void> _pullTasks() async {
    final data = await _api.get('/api/mobile/tasks');
    final list = (data as List)
        .map((e) => Task.fromJson(e as Map<String, dynamic>))
        .toList();
    await _repo.upsertTasks(list);
  }

  Future<void> _pullInventory() async {
    final data = await _api.get('/api/mobile/inventory');
    final list = (data as List)
        .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
        .toList();
    await _repo.upsertInventoryItems(list);
  }

  Future<void> _pullBudgets(int month, int year, {bool skipClear = false}) async {
    final data =
        await _api.get('/api/mobile/budgets/status?month=$month&year=$year');
    final list = (data as List)
        .map((e) => Budget.fromJson(e as Map<String, dynamic>))
        .toList();
    if (!skipClear) await _repo.clearBudgets();
    await _repo.upsertBudgets(list);
  }

  Future<void> _pullChartData() async {
    final data = await _api.get('/api/graficas/ingreso-egreso');
    await _repo.setCacheEntry('graficas/ingreso-egreso', jsonEncode(data));
  }

  // ─────────────────────────────────────────────────────────────────────
  // HELPERS PÚBLICOS para uso en pantallas
  // ─────────────────────────────────────────────────────────────────────

  /// Guarda movimientos de inventario en local después de cargarlos.
  Future<void> cacheInventoryMovements(
      int itemId, List<InventoryMovement> movements) async {
    await _repo.upsertMovements(movements);
  }
}

class SyncResult {
  final int pendingPushed;
  final List<String> errors;
  bool get hasErrors => errors.isNotEmpty;

  SyncResult({required this.pendingPushed, required this.errors});
}

class _PushResult {
  final int pushed;
  final List<String> errors;
  _PushResult({required this.pushed, required this.errors});
}
