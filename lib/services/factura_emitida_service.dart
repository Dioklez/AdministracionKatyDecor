import '../core/pocketbase_service.dart';
import '../models/factura_emitida_model.dart';

class FacturaEmitidaService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<FacturaEmitida>> getAll() async {
    final records = await _pb.collection('facturas_emitidas').getFullList(
          sort: '-created',
        );
    return records.map(FacturaEmitida.fromRecord).toList();
  }

  Future<FacturaEmitida> create(Map<String, dynamic> data) async {
    try {
      final record =
          await _pb.collection('facturas_emitidas').create(body: data);
      return FacturaEmitida.fromRecord(record);
    } catch (e) {
      print('FacturaEmitidaService.create error: $e');
      rethrow;
    }
  }

  Future<FacturaEmitida> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('facturas_emitidas').update(id, body: data);
    return FacturaEmitida.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('facturas_emitidas').delete(id);
  }
}
