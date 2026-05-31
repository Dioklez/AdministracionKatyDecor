import '../core/pocketbase_service.dart';
import '../models/task_model.dart';

class TaskService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Task>> getAll() async {
    final records = await _pb.collection('tasks').getFullList(
          sort: '-created',
        );
    return records.map(Task.fromRecord).toList();
  }

  Future<List<Task>> getByProject(String projectId) async {
    final records = await _pb.collection('tasks').getFullList(
          filter: 'projectId = "$projectId"',
          sort: '-created',
        );
    return records.map(Task.fromRecord).toList();
  }

  Future<Task> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('tasks').create(body: data);
    return Task.fromRecord(record);
  }

  Future<Task> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('tasks').update(id, body: data);
    return Task.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('tasks').delete(id);
  }
}
