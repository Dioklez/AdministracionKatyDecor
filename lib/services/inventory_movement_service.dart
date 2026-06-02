import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/inventory_movement_model.dart';

class InventoryMovementService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  InventoryMovementService({LocalRepository? repo}) : _repo = repo;

  Future<List<InventoryMovement>> getAll() async {
    try {
      final records = await _pb
          .collection('inventory_movements')
          .getFullList(sort: '-created');
      final result = records.map(InventoryMovement.fromRecord).toList();
      await _repo?.upsertInventoryMovements(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getInventoryMovements();
        return local.map(_movementFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<List<InventoryMovement>> getByItem(String inventoryItemId) async {
    try {
      final records = await _pb.collection('inventory_movements').getFullList(
            filter: 'inventory_item = "$inventoryItemId"',
            sort: '-date',
          );
      final result = records.map(InventoryMovement.fromRecord).toList();
      await _repo?.upsertInventoryMovements(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local =
            await _repo.getMovementsByItem(inventoryItemId);
        return local.map(_movementFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<InventoryMovement> create(Map<String, dynamic> data) async {
    final record =
        await _pb.collection('inventory_movements').create(body: data);
    return InventoryMovement.fromRecord(record);
  }

  Future<InventoryMovement> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('inventory_movements').update(id, body: data);
    return InventoryMovement.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('inventory_movements').delete(id);
  }

  InventoryMovement _movementFromLocal(LocalInventoryMovement row) =>
      InventoryMovement(
        id: row.id,
        inventoryItemId: row.inventoryItemId ?? '',
        type: row.type ?? 'entrada',
        quantity: row.quantity ?? 0.0,
        date: _dateStr(row.date),
        projectId: row.projectId,
        notes: row.notes,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
