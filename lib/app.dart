import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/api_service.dart';
import 'services/sync_service.dart';
import 'database/local_repository.dart';
import 'theme/app_theme.dart';
import 'screens/splash/splash_screen.dart';

class KatyDecorApp extends StatelessWidget {
  final AuthService authService;
  const KatyDecorApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ProxyProvider<AuthService, ApiService>(
          update: (_, auth, prev) => ApiService(auth),
        ),
        ProxyProvider2<ApiService, LocalRepository, SyncService>(
          update: (_, api, repo, prev) => SyncService(api, repo),
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
