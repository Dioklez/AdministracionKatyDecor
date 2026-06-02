import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/inventory_item_model.dart';

class InventoryItemService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  InventoryItemService({LocalRepository? repo}) : _repo = repo;

  Future<List<InventoryItem>> getAll() async {
    try {
      final records = await _pb
          .collection('inventory_items')
          .getFullList(sort: 'name');
      final result = records.map(InventoryItem.fromRecord).toList();
      await _repo?.upsertInventoryItems(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getInventoryItems();
        return local.map(_itemFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<InventoryItem> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('inventory_items').create(body: data);
    final item = InventoryItem.fromRecord(record);
    await _repo?.upsertInventoryItem(item);
    return item;
  }

  Future<InventoryItem> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('inventory_items').update(id, body: data);
    final item = InventoryItem.fromRecord(record);
    await _repo?.upsertInventoryItem(item);
    return item;
  }

  Future<void> delete(String id) async {
    await _pb.collection('inventory_items').delete(id);
  }

  InventoryItem _itemFromLocal(LocalInventoryItem row) => InventoryItem(
        id: row.id,
        name: row.name,
        description: row.description,
        unit: row.unit,
        currentStock: row.currentStock ?? 0.0,
        minStock: row.minStock,
        supplierProductId: row.supplierProductId,
        location: row.location,
        notes: row.notes,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}
