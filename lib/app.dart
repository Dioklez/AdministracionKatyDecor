import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'services/connectivity_service.dart';
import 'services/offline_queue_service.dart';
import 'services/sync_service.dart';
import 'database/app_database.dart';
import 'database/local_repository.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class KatyDecorApp extends StatelessWidget {
  final AuthService authService;
  final ConnectivityService connectivityService;

  const KatyDecorApp({
    super.key,
    required this.authService,
    required this.connectivityService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ConnectivityService>.value(
          value: connectivityService,
        ),
        // ApiService se mantiene por compatibilidad con código existente
        ProxyProvider<AuthService, ApiService>(
          update: (_, auth, prev) => ApiService(auth),
        ),
        // Cola de operaciones offline
        ProxyProvider2<AppDatabase, LocalRepository, OfflineQueueService>(
          update: (_, db, repo, prev) => OfflineQueueService(db, repo),
        ),
        // SyncService: al crearse, registra el callback de reconexión
        ProxyProvider3<OfflineQueueService, ConnectivityService, LocalRepository,
            SyncService>(
          update: (_, queue, connectivity, repo, prev) {
            final svc = SyncService(queue, connectivity, repo);
            connectivity.onReconnect = svc.syncOnReconnect;
            return svc;
          },
        ),
      ],
      child: MaterialApp(
        title: 'KatyDecor Admin',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        home: const SplashScreen(),
      ),
    );
  }
}
