import 'dart:convert';
import 'package:drift/drift.dart';
import '../core/pocketbase_service.dart';
import '../database/app_database.dart';
import '../database/local_repository.dart';

class OfflineQueueService {
  final AppDatabase _db;
  final LocalRepository _repo;
  bool _isProcessing = false;

  OfflineQueueService(this._db, this._repo);

  /// Encola una operación pendiente.
  /// [entityId] se almacena dentro del payload bajo la clave '_id'
  /// porque la columna entityId de la tabla es IntColumn (era para Flask).
  Future<void> enqueue({
    required String entityType,
    required String operation, // 'create' | 'update' | 'delete'
    required String endpoint,
    String? entityId,
    Map<String, dynamic>? payload,
  }) async {
    final data = Map<String, dynamic>.from(payload ?? {});
    if (entityId != null) data['_id'] = entityId;

    await _db.into(_db.pendingOps).insert(PendingOpsCompanion.insert(
          entityType: entityType,
          operation: operation,
          endpoint: endpoint,
          payload: Value(data.isNotEmpty ? jsonEncode(data) : null),
        ));
  }

  /// Procesa todas las operaciones pendientes en orden FIFO.
  /// Usa un lock para evitar ejecuciones simultáneas.
  Future<void> processPendingOps() async {
    if (_isProcessing) {
      print('OfflineQueue: ya está procesando, ignorando llamada duplicada');
      return;
    }
    _isProcessing = true;
    try {
      final ops = await (_db.select(_db.pendingOps)
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .get();

      for (final op in ops) {
        try {
          await _processOp(op);
        } catch (_) {
          // La op ya fue borrada de PendingOps antes de llamar a PocketBase.
          // No hay nada que reintentar — se registra el error silenciosamente.
        }
      }
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _processOp(PendingOp op) async {
    final pb = PocketBaseService.instance.pb;
    final collection = op.entityType;

    final rawPayload = op.payload != null
        ? jsonDecode(op.payload!) as Map<String, dynamic>
        : <String, dynamic>{};

    final payload = Map<String, dynamic>.from(rawPayload);
    final entityId = payload.remove('_id') as String?;  // para update/delete
    final tempId = payload.remove('_tempId') as String?; // extraer antes de enviar a PocketBase

    switch (op.operation) {
      case 'create':
        print('OfflineQueue: creando en PocketBase colección: $collection');
        print('OfflineQueue: tempId en payload: $tempId');
        // Borrar ANTES de crear — evita duplicados si la app falla a medias
        await (_db.delete(_db.pendingOps)..where((t) => t.id.equals(op.id))).go();
        final record = await pb.collection(collection).create(body: payload);
        print('OfflineQueue: registro creado con ID real: ${record.id}');
        // El registro temp_ se borra en SyncService.cleanupTempRecords()
        // DESPUÉS de _refreshLocalCache(), para evitar ventana de lista vacía.
        break;
      case 'update':
        if (entityId != null) {
          await (_db.delete(_db.pendingOps)..where((t) => t.id.equals(op.id))).go();
          await pb.collection(collection).update(entityId, body: payload);
        }
        break;
      case 'delete':
        if (entityId != null) {
          await (_db.delete(_db.pendingOps)..where((t) => t.id.equals(op.id))).go();
          await pb.collection(collection).delete(entityId);
        }
        break;
    }
  }

  Future<int> getPendingCount() => _repo.getPendingOpsCount();
}
