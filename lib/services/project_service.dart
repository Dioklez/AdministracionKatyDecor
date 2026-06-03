import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/project_model.dart';
import 'connectivity_service.dart';

class ProjectService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  ProjectService({LocalRepository? repo}) : _repo = repo;

  Future<List<Project>> getAll() async {
    if (!ConnectivityService.currentlyOnline) {
      if (_repo != null) {
        return (await _repo.getProjects()).map(_projectFromLocal).toList();
      }
      return [];
    }
    try {
      final records = await _pb.collection('projects').getFullList(
            sort: '-created',
          );
      final result = records.map(Project.fromRecord).toList();
      await _repo?.upsertProjects(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getProjects();
        return local.map(_projectFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<Project> getById(String id) async {
    final record = await _pb.collection('projects').getOne(id);
    return Project.fromRecord(record);
  }

  Future<Project> create(Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('projects').create(body: data);
      final project = Project.fromRecord(record);
      await _repo?.upsertProject(project);
      return project;
    } catch (e) {
      print('ProjectService.create error: $e');
      rethrow;
    }
  }

  Future<Project> update(String id, Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('projects').update(id, body: data);
      final project = Project.fromRecord(record);
      await _repo?.upsertProject(project);
      return project;
    } catch (e) {
      print('ProjectService.update error: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _pb.collection('projects').delete(id);
      await _repo?.deleteProject(id);
    } catch (e) {
      print('ProjectService.delete error: $e');
      rethrow;
    }
  }

  Project _projectFromLocal(LocalProject row) => Project(
        id: row.id,
        name: row.name,
        clientName: row.clientName ?? '',
        clientPhone: row.clientPhone,
        description: row.description,
        status: row.status ?? 'activo',
        startDate: _dateStr(row.startDate),
        endDate: _dateStr(row.endDate),
        budget: row.budget,
        totalIncome: row.totalIncome ?? 0.0,
        totalExpense: row.totalExpense ?? 0.0,
        notes: row.notes,
        color: row.color,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
