import '../core/pocketbase_service.dart';
import '../models/remision_model.dart';

class RemisionService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Remision>> getAll() async {
    final records = await _pb.collection('remisiones').getFullList(
          sort: '-created',
        );
    return records.map(Remision.fromRecord).toList();
  }

  Future<Remision> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('remisiones').create(body: data);
    return Remision.fromRecord(record);
  }

  Future<Remision> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('remisiones').update(id, body: data);
    return Remision.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('remisiones').delete(id);
  }
}
