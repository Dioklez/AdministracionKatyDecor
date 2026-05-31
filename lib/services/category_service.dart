import '../core/pocketbase_service.dart';
import '../models/category_model.dart';

class CategoryService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Category>> getAll() async {
    final records = await _pb.collection('categories').getFullList(
          sort: 'name',
        );
    return records.map(Category.fromRecord).toList();
  }

  Future<Category> create(String name, String type, String color) async {
    final record = await _pb.collection('categories').create(body: {
      'name': name,
      'type': type,
      'color': color,
    });
    return Category.fromRecord(record);
  }

  Future<Category> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('categories').update(id, body: data);
    return Category.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('categories').delete(id);
  }
}
