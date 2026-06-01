import '../core/pocketbase_service.dart';
import '../models/supplier_model.dart';

class SupplierService {
  final _pb = PocketBaseService.instance.pb;

  /// Normaliza claves camelCase a snake_case para PocketBase.
  Map<String, dynamic> _normalize(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);
    if (result.containsKey('contactName')) {
      result['contact_name'] = result.remove('contactName');
    }
    if (result.containsKey('isActive')) {
      result['is_active'] = result.remove('isActive');
    }
    return result;
  }

  Future<List<Supplier>> getAll() async {
    final records = await _pb.collection('suppliers').getFullList(
          sort: 'name',
        );
    return records.map(Supplier.fromRecord).toList();
  }

  Future<Supplier> create(Map<String, dynamic> data) async {
    try {
      final record =
          await _pb.collection('suppliers').create(body: _normalize(data));
      return Supplier.fromRecord(record);
    } catch (e) {
      print('SupplierService.create error: $e');
      rethrow;
    }
  }

  Future<Supplier> update(String id, Map<String, dynamic> data) async {
    try {
      final body = _normalize(data);
      print('SupplierService.update body: $body');
      final record =
          await _pb.collection('suppliers').update(id, body: body);
      return Supplier.fromRecord(record);
    } catch (e) {
      print('SupplierService.update error: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    await _pb.collection('suppliers').delete(id);
  }
}
