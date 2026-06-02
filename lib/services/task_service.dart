import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/task_model.dart';

class TaskService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  TaskService({LocalRepository? repo}) : _repo = repo;

  Future<List<Task>> getAll() async {
    try {
      final records = await _pb.collection('tasks').getFullList(
            sort: '-created',
          );
      final result = records.map(Task.fromRecord).toList();
      await _repo?.upsertTasks(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getTasks();
        return local.map(_taskFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<List<Task>> getByProject(String projectId) async {
    try {
      final records = await _pb.collection('tasks').getFullList(
            filter: 'project = "$projectId"',
            sort: '-created',
          );
      final result = records.map(Task.fromRecord).toList();
      await _repo?.upsertTasks(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getTasks();
        return local
            .where((t) => t.projectId == projectId)
            .map(_taskFromLocal)
            .toList();
      }
      rethrow;
    }
  }

  Future<Task> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('tasks').create(body: data);
    final task = Task.fromRecord(record);
    await _repo?.upsertTask(task);
    return task;
  }

  Future<Task> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('tasks').update(id, body: data);
    final task = Task.fromRecord(record);
    await _repo?.upsertTask(task);
    return task;
  }

  Future<void> delete(String id) async {
    await _pb.collection('tasks').delete(id);
    await _repo?.deleteTask(id);
  }

  Task _taskFromLocal(LocalTask row) => Task(
        id: row.id,
        title: row.title,
        description: row.description,
        projectId: row.projectId,
        stageId: row.stageId,
        status: row.status ?? 'pendiente',
        priority: row.priority ?? 'media',
        dueDate: _dateStr(row.dueDate),
        completedAt: _dateStr(row.completedAt),
        notes: row.notes,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
