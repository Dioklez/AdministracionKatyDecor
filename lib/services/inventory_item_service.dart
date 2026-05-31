import '../core/pocketbase_service.dart';
import '../models/inventory_item_model.dart';

class InventoryItemService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<InventoryItem>> getAll() async {
    final records = await _pb
        .collection('inventory_items')
        .getFullList(sort: 'name');
    return records.map(InventoryItem.fromRecord).toList();
  }

  Future<InventoryItem> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('inventory_items').create(body: data);
    return InventoryItem.fromRecord(record);
  }

  Future<InventoryItem> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('inventory_items').update(id, body: data);
    return InventoryItem.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('inventory_items').delete(id);
  }
}
