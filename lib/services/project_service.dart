import '../core/pocketbase_service.dart';
import '../models/project_model.dart';

class ProjectService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Project>> getAll() async {
    final records = await _pb.collection('projects').getFullList(
          sort: '-created',
        );
    return records.map(Project.fromRecord).toList();
  }

  Future<Project> getById(String id) async {
    final record = await _pb.collection('projects').getOne(id);
    return Project.fromRecord(record);
  }

  Future<Project> create(Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('projects').create(body: data);
      return Project.fromRecord(record);
    } catch (e) {
      print('ProjectService.create error: $e');
      rethrow;
    }
  }

  Future<Project> update(String id, Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('projects').update(id, body: data);
      return Project.fromRecord(record);
    } catch (e) {
      print('ProjectService.update error: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _pb.collection('projects').delete(id);
    } catch (e) {
      print('ProjectService.delete error: $e');
      rethrow;
    }
  }
}
