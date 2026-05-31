import '../core/pocketbase_service.dart';
import '../models/supplier_product_model.dart';

class SupplierProductService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<SupplierProduct>> getAll() async {
    final records = await _pb
        .collection('supplier_products')
        .getFullList(sort: '-created');
    return records.map(SupplierProduct.fromRecord).toList();
  }

  Future<List<SupplierProduct>> getBySupplier(String supplierId) async {
    final records = await _pb.collection('supplier_products').getFullList(
          filter: 'supplierId = "$supplierId"',
          sort: 'name',
        );
    return records.map(SupplierProduct.fromRecord).toList();
  }

  Future<SupplierProduct> create(Map<String, dynamic> data) async {
    final record =
        await _pb.collection('supplier_products').create(body: data);
    return SupplierProduct.fromRecord(record);
  }

  Future<SupplierProduct> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('supplier_products').update(id, body: data);
    return SupplierProduct.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('supplier_products').delete(id);
  }
}
