import '../database/local_repository.dart';
import 'api_service.dart';

/// SyncService — temporalmente desactivado.
/// La sincronización con Flask (ApiService) quedó fuera de uso al migrar
/// el backend a PocketBase. Los métodos conservan su firma para que
/// app.dart y splash_screen.dart compilen sin cambios.
/// La sincronización real con PocketBase se implementará después.
class SyncService {
  // ignore: unused_field
  final ApiService _api;
  // ignore: unused_field
  final LocalRepository _repo;

  SyncService(this._api, this._repo);

  bool get isSyncing => false;

  Future<SyncResult> fullSync() async {
    return SyncResult(pendingPushed: 0, errors: []);
  }
}

class SyncResult {
  final int pendingPushed;
  final List<String> errors;
  bool get hasErrors => errors.isNotEmpty;

  SyncResult({required this.pendingPushed, required this.errors});
}
