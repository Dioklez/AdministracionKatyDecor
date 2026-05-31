import '../core/pocketbase_service.dart';
import '../models/project_stage_model.dart';

class ProjectStageService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<ProjectStage>> getAll() async {
    final records = await _pb.collection('project_stages').getFullList(
          sort: 'order',
        );
    return records.map(ProjectStage.fromRecord).toList();
  }

  Future<List<ProjectStage>> getByProject(String projectId) async {
    final records = await _pb.collection('project_stages').getFullList(
          filter: 'projectId = "$projectId"',
          sort: 'order',
        );
    return records.map(ProjectStage.fromRecord).toList();
  }

  Future<ProjectStage> create(Map<String, dynamic> data) async {
    final record =
        await _pb.collection('project_stages').create(body: data);
    return ProjectStage.fromRecord(record);
  }

  Future<ProjectStage> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('project_stages').update(id, body: data);
    return ProjectStage.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('project_stages').delete(id);
  }
}
