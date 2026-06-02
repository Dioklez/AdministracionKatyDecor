import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/project_stage_model.dart';

class ProjectStageService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  ProjectStageService({LocalRepository? repo}) : _repo = repo;

  Future<List<ProjectStage>> getAll() async {
    try {
      final records = await _pb.collection('project_stages').getFullList(
            sort: 'order',
          );
      final result = records.map(ProjectStage.fromRecord).toList();
      await _repo?.upsertProjectStages(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getProjectStages();
        return local.map(_stageFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<List<ProjectStage>> getByProject(String projectId) async {
    try {
      final records = await _pb.collection('project_stages').getFullList(
            filter: 'project = "$projectId"',
            sort: 'order',
          );
      final result = records.map(ProjectStage.fromRecord).toList();
      await _repo?.upsertProjectStages(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local =
            await _repo.getStagesByProject(projectId);
        return local.map(_stageFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<ProjectStage> create(Map<String, dynamic> data) async {
    final record =
        await _pb.collection('project_stages').create(body: data);
    final stage = ProjectStage.fromRecord(record);
    await _repo?.upsertProjectStage(stage);
    return stage;
  }

  Future<ProjectStage> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('project_stages').update(id, body: data);
    final stage = ProjectStage.fromRecord(record);
    await _repo?.upsertProjectStage(stage);
    return stage;
  }

  Future<void> delete(String id) async {
    await _pb.collection('project_stages').delete(id);
    await _repo?.deleteProjectStage(id);
  }

  ProjectStage _stageFromLocal(LocalProjectStage row) => ProjectStage(
        id: row.id,
        projectId: row.projectId ?? '',
        name: row.name,
        description: row.description,
        status: row.status ?? 'pendiente',
        order: row.order ?? 0,
        startDate: _dateStr(row.startDate),
        endDate: _dateStr(row.endDate),
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
