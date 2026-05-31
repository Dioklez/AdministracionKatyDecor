import 'package:drift/drift.dart';
import '../models/inventory_item.dart';
import '../models/inventory_movement.dart';
import 'app_database.dart';

class LocalRepository {
  final AppDatabase _db;
  LocalRepository(this._db);

  // ═══════════════════════════════════════════════════════════════════════
  // INVENTARIO
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<InventoryItem>> getAllInventoryItems() async {
    final rows = await _db.select(_db.inventoryItems).get();
    return rows.map(_invItemFromRow).toList();
  }

  Future<List<InventoryItem>> getInventoryFiltered(
      {String? tipo, String? query}) async {
    final q = _db.select(_db.inventoryItems);
    if (tipo != null) q.where((t) => t.tipo.equals(tipo));
    if (query != null && query.isNotEmpty) {
      q.where((t) => t.nombre.like('%$query%'));
    }
    final rows = await q.get();
    return rows.map(_invItemFromRow).toList();
  }

  Future<InventoryItem?> getInventoryItemById(int id) async {
    final row = await (_db.select(_db.inventoryItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _invItemFromRow(row) : null;
  }

  Future<void> upsertInventoryItem(InventoryItem item) async {
    await _db
        .into(_db.inventoryItems)
        .insertOnConflictUpdate(_invItemToCompanion(item));
  }

  Future<void> upsertInventoryItems(List<InventoryItem> items) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.inventoryItems, items.map(_invItemToCompanion).toList());
    });
  }

  Future<void> deleteInventoryItem(int id) async {
    await (_db.delete(_db.inventoryItems)..where((t) => t.id.equals(id))).go();
    await (_db.delete(_db.inventoryMovements)
          ..where((t) => t.itemId.equals(id)))
        .go();
  }

  InventoryItem _invItemFromRow(InventoryItemRow row) => InventoryItem.fromJson({
        'id': row.id,
        'codigo': row.codigo,
        'nombre': row.nombre,
        'descripcion': row.descripcion,
        'tipo': row.tipo,
        'categoria': row.categoria,
        'unidad': row.unidad,
        'stock_actual': row.stockActual,
        'stock_minimo': row.stockMinimo,
        'precio_unitario': row.precioUnitario,
        'proveedor_id': row.proveedorId,
        'activo': row.activo,
        'notas': row.notas,
        'valor_total': row.valorTotal,
      });

  InventoryItemsCompanion _invItemToCompanion(InventoryItem item) =>
      InventoryItemsCompanion(
        id: Value(item.id),
        codigo: Value(item.codigo),
        nombre: Value(item.nombre),
        descripcion: Value(item.descripcion),
        tipo: Value(item.tipo),
        categoria: Value(item.categoria),
        unidad: Value(item.unidad),
        stockActual: Value(item.stockActual),
        stockMinimo: Value(item.stockMinimo),
        precioUnitario: Value(item.precioUnitario),
        proveedorId: Value(item.proveedorId),
        activo: Value(item.activo),
        notas: Value(item.notas),
        valorTotal: Value(item.valorTotal),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // MOVIMIENTOS DE INVENTARIO
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<InventoryMovement>> getMovementsByItemId(int itemId) async {
    final rows = await (_db.select(_db.inventoryMovements)
          ..where((t) => t.itemId.equals(itemId)))
        .get();
    return rows.map(_movementFromRow).toList();
  }

  Future<void> upsertMovements(List<InventoryMovement> movements) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.inventoryMovements,
          movements.map(_movementToCompanion).toList());
    });
  }

  InventoryMovement _movementFromRow(InventoryMovementRow row) =>
      InventoryMovement.fromJson({
        'id': row.id,
        'item_id': row.itemId,
        'tipo': row.tipo,
        'cantidad': row.cantidad,
        'precio_unitario': row.precioUnitario,
        'referencia': row.referencia,
        'fecha': row.fecha,
        'created_at': row.createdAt,
      });

  InventoryMovementsCompanion _movementToCompanion(InventoryMovement m) =>
      InventoryMovementsCompanion(
        id: Value(m.id),
        itemId: Value(m.itemId),
        tipo: Value(m.tipo),
        cantidad: Value(m.cantidad),
        precioUnitario: Value(m.precioUnitario),
        referencia: Value(m.referencia),
        fecha: Value(m.fecha),
        createdAt: Value(m.createdAt),
      );

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

  /// Actualiza el ID local de una entidad cuando el servidor asigna el ID real,
  /// y cascadea el cambio a todas las tablas que referencian ese tempId como FK.
  Future<void> updateLocalId(
      String entityType, int tempId, int realId) async {
    switch (entityType) {
      case 'task':
        await _db.customStatement(
            'UPDATE tasks SET id = ? WHERE id = ?', [realId, tempId]);
    }
  }

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
