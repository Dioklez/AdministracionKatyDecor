import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/supplier_product_model.dart';

class SupplierProductService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  SupplierProductService({LocalRepository? repo}) : _repo = repo;

  Future<List<SupplierProduct>> getAll() async {
    try {
      final records = await _pb
          .collection('supplier_products')
          .getFullList(sort: '-created');
      final result = records.map(SupplierProduct.fromRecord).toList();
      await _repo?.upsertSupplierProducts(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getSupplierProducts();
        return local.map(_productFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<List<SupplierProduct>> getBySupplier(String supplierId) async {
    try {
      final records = await _pb.collection('supplier_products').getFullList(
            filter: 'supplier = "$supplierId"',
            sort: 'name',
          );
      final result = records.map(SupplierProduct.fromRecord).toList();
      await _repo?.upsertSupplierProducts(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local =
            await _repo.getSupplierProductsBySupplier(supplierId);
        return local.map(_productFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<SupplierProduct> create(Map<String, dynamic> data) async {
    try {
      final record =
          await _pb.collection('supplier_products').create(body: data);
      return SupplierProduct.fromRecord(record);
    } catch (e) {
      print('SupplierProductService.create error: $e');
      rethrow;
    }
  }

  Future<SupplierProduct> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('supplier_products').update(id, body: data);
    return SupplierProduct.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('supplier_products').delete(id);
  }

  SupplierProduct _productFromLocal(LocalSupplierProduct row) =>
      SupplierProduct(
        id: row.id,
        supplierId: row.supplierId ?? '',
        name: row.name,
        description: row.description,
        sku: row.sku,
        unit: row.unit,
        price: row.price ?? 0.0,
        isActive: row.isActive ?? true,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}
