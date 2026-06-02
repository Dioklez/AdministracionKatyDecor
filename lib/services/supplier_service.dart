import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/supplier_model.dart';

class SupplierService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  SupplierService({LocalRepository? repo}) : _repo = repo;

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
    try {
      final records = await _pb.collection('suppliers').getFullList(
            sort: 'name',
          );
      final result = records.map(Supplier.fromRecord).toList();
      await _repo?.upsertSuppliers(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getSuppliers();
        return local.map(_supplierFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<Supplier> create(Map<String, dynamic> data) async {
    try {
      final record =
          await _pb.collection('suppliers').create(body: _normalize(data));
      final supplier = Supplier.fromRecord(record);
      await _repo?.upsertSupplier(supplier);
      return supplier;
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
      final supplier = Supplier.fromRecord(record);
      await _repo?.upsertSupplier(supplier);
      return supplier;
    } catch (e) {
      print('SupplierService.update error: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    await _pb.collection('suppliers').delete(id);
  }

  Supplier _supplierFromLocal(LocalSupplier row) => Supplier(
        id: row.id,
        name: row.name,
        contactName: row.contactName,
        phone: row.phone,
        email: row.email,
        address: row.address,
        notes: row.notes,
        isActive: row.isActive ?? true,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}
