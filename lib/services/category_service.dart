import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/category_model.dart';

class CategoryService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  CategoryService({LocalRepository? repo}) : _repo = repo;

  Future<List<Category>> getAll() async {
    try {
      final records = await _pb.collection('categories').getFullList(
            sort: 'name',
          );
      final result = records.map(Category.fromRecord).toList();
      await _repo?.upsertCategories(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getCategories();
        return local.map(_categoryFromLocal).toList();
      }
      rethrow;
    }
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

  Category _categoryFromLocal(LocalCategory row) => Category(
        id: row.id,
        name: row.name,
        type: row.type ?? 'egreso',
        color: row.color ?? '#4CAF50',
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}
