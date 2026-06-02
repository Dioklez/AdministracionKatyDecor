import '../database/local_repository.dart';
import 'connectivity_service.dart';

/// Mixin base para servicios con caché offline.
/// Los servicios que implementen caché deben exponer [repo] y [connectivity].
mixin CachedServiceMixin {
  LocalRepository get repo;
  ConnectivityService get connectivity;
}
