import 'package:drift/drift.dart';
import 'app_database.dart';

class LocalRepository {
  final AppDatabase _db;
  LocalRepository(this._db);

  // ═══════════════════════════════════════════════════════════════════════
  // COLA DE OPERACIONES PENDIENTES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<PendingOp>> getAllPendingOps() async {
    return (_db.select(_db.pendingOps)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<int> getPendingOpsCount() async {
    final count =
        _db.pendingOps.id.count();
    final query = _db.selectOnly(_db.pendingOps)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<void> addPendingOp({
    required String entityType,
    required String operation,
    int? entityId,
    int? tempId,
    required String endpoint,
    String? payload,
  }) async {
    await _db.into(_db.pendingOps).insert(PendingOpsCompanion.insert(
          entityType: entityType,
          operation: operation,
          entityId: Value(entityId),
          tempId: Value(tempId),
          endpoint: endpoint,
          payload: Value(payload),
        ));
  }

  Future<void> deletePendingOp(int id) async {
    await (_db.delete(_db.pendingOps)..where((t) => t.id.equals(id))).go();
  }

  Future<void> incrementRetries(int id) async {
    final op = await (_db.select(_db.pendingOps)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (op != null) {
      await (_db.update(_db.pendingOps)..where((t) => t.id.equals(id)))
          .write(PendingOpsCompanion(retries: Value(op.retries + 1)));
    }
  }

  Future<void> updatePendingOpPayload(int opId, String newPayload) async {
    await (_db.update(_db.pendingOps)..where((t) => t.id.equals(opId)))
        .write(PendingOpsCompanion(payload: Value(newPayload)));
  }

  Future<void> updateLocalId(
      String entityType, int tempId, int realId) async {}

  // ═══════════════════════════════════════════════════════════════════════
  // CACHE DE JSON
  // ═══════════════════════════════════════════════════════════════════════

  Future<String?> getCacheEntry(String key) async {
    final row = await (_db.select(_db.cacheEntries)
          ..where((t) => t.cacheKey.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setCacheEntry(String key, String jsonValue) async {
    await _db.into(_db.cacheEntries).insertOnConflictUpdate(
          CacheEntriesCompanion(
            cacheKey: Value(key),
            value: Value(jsonValue),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> deleteCacheEntry(String key) async {
    await (_db.delete(_db.cacheEntries)
          ..where((t) => t.cacheKey.equals(key)))
        .go();
  }
}
