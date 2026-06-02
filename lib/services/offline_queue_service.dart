import 'dart:convert';
import 'package:drift/drift.dart';
import '../core/pocketbase_service.dart';
import '../database/app_database.dart';
import '../database/local_repository.dart';

class OfflineQueueService {
  final AppDatabase _db;
  final LocalRepository _repo;

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
  Future<void> processPendingOps() async {
    final ops = await (_db.select(_db.pendingOps)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();

    for (final op in ops) {
      try {
        await _processOp(op);
        await (_db.delete(_db.pendingOps)
              ..where((t) => t.id.equals(op.id)))
            .go();
      } catch (_) {
        await (_db.update(_db.pendingOps)..where((t) => t.id.equals(op.id)))
            .write(PendingOpsCompanion(retries: Value(op.retries + 1)));
      }
    }
  }

  Future<void> _processOp(PendingOp op) async {
    final pb = PocketBaseService.instance.pb;
    final collection = op.entityType;

    final rawPayload = op.payload != null
        ? jsonDecode(op.payload!) as Map<String, dynamic>
        : <String, dynamic>{};

    // Extraer entityId que fue guardado dentro del payload
    final payload = Map<String, dynamic>.from(rawPayload);
    final entityId = payload.remove('_id') as String?;

    switch (op.operation) {
      case 'create':
        await pb.collection(collection).create(body: payload);
        break;
      case 'update':
        if (entityId != null) {
          await pb.collection(collection).update(entityId, body: payload);
        }
        break;
      case 'delete':
        if (entityId != null) {
          await pb.collection(collection).delete(entityId);
        }
        break;
    }
  }

  Future<int> getPendingCount() => _repo.getPendingOpsCount();
}
