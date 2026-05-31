import '../core/pocketbase_service.dart';
import '../models/supplier_model.dart';

class SupplierService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Supplier>> getAll() async {
    final records = await _pb.collection('suppliers').getFullList(
          sort: 'name',
        );
    return records.map(Supplier.fromRecord).toList();
  }

  Future<Supplier> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('suppliers').create(body: data);
    return Supplier.fromRecord(record);
  }

  Future<Supplier> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('suppliers').update(id, body: data);
    return Supplier.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('suppliers').delete(id);
  }
}
