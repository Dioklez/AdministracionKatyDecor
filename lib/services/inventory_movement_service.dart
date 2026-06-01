import '../core/pocketbase_service.dart';
import '../models/inventory_movement_model.dart';

class InventoryMovementService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<InventoryMovement>> getAll() async {
    final records = await _pb
        .collection('inventory_movements')
        .getFullList(sort: '-created');
    return records.map(InventoryMovement.fromRecord).toList();
  }

  Future<List<InventoryMovement>> getByItem(String inventoryItemId) async {
    final records = await _pb.collection('inventory_movements').getFullList(
          filter: 'inventory_item = "$inventoryItemId"',
          sort: '-date',
        );
    return records.map(InventoryMovement.fromRecord).toList();
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
}
