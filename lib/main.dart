import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/pocketbase_service.dart';
import 'services/auth_service.dart';
import 'services/connectivity_service.dart';
import 'database/app_database.dart';
import 'database/local_repository.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PocketBaseService.instance.loadAuthFromPrefs();
  final authService = AuthService();
  await authService.loadFromPrefs();
  final database = AppDatabase();
  final localRepo = LocalRepository(database);
  final connectivityService = ConnectivityService();
  connectivityService.startMonitoring();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<AppDatabase>.value(value: database),
        Provider<LocalRepository>.value(value: localRepo),
      ],
      child: KatyDecorApp(
        authService: authService,
        connectivityService: connectivityService,
      ),
    ),
  );
}
