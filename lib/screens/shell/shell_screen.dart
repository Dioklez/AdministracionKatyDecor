import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../services/auth_service.dart';
import '../../services/sync_service.dart';
import '../dashboard/dashboard_screen.dart';
import '../login/login_screen.dart';
import '../transactions/transactions_screen.dart';
import '../projects/projects_screen.dart';
import '../tasks/tasks_screen.dart';
import '../quotes/quotes_screen.dart';
import '../suppliers/suppliers_screen.dart';
import '../inventory/inventory_screen.dart';
import '../accounts/accounts_screen.dart';
import '../budgets/budgets_screen.dart';
import '../placeholder/placeholder_screen.dart';
import 'sidebar_widget.dart';
import '../../services/update_service.dart';

class ShellScreen extends StatefulWidget {
  const ShellScreen({super.key});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  int _selectedIndex = 0;
  bool _isOnline = true;
  Timer? _connectivityTimer;

  // Referencias guardadas en initState — no usar context.read() en dispose()
  AuthService? _authService;
  ApiService? _apiService;
  SyncService? _syncService;

  @override
  void initState() {
    super.initState();
    _authService = context.read<AuthService>();
    _apiService = context.read<ApiService>();
    _syncService = context.read<SyncService>();
    _authService!.addListener(_onAuthChanged);
    _checkConnectivity();
    _connectivityTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _checkConnectivity(),
    );

    // Verificar actualizaciones sin interferir con la carga inicial
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) UpdateService.checkForUpdates(context);
    });
  }

  @override
  void dispose() {
    _authService?.removeListener(_onAuthChanged);
    _connectivityTimer?.cancel();
    super.dispose();
  }

  void _onAuthChanged() {
    if (!mounted) return;
    if (!(_authService?.isLoggedIn ?? true)) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  Future<void> _checkConnectivity() async {
    if (!mounted) return;
    try {
      await _apiService?.get('/api/auth/verify');
      if (!mounted) return;
      if (!_isOnline) {
        setState(() => _isOnline = true);
        // Reconexión detectada: enviar ops pendientes antes de actualizar datos
        _syncService?.fullSync().then((_) {}, onError: (_) {});
      }
    } catch (_) {
      if (mounted && _isOnline) setState(() => _isOnline = false);
    }
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const TransactionsScreen();
      case 2:
        return const ProjectsScreen();
      case 3:
        return const TasksScreen();
      case 4:
        return const PlaceholderScreen(
            title: 'Reportes', icon: Icons.bar_chart_outlined);
      case 5:
        return const QuotesScreen();
      case 6:
        return const SuppliersScreen();
      case 7:
        return const InventoryScreen();
      case 8:
        return const AccountsScreen();
      case 9:
        return const BudgetsScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SidebarWidget(
            selectedIndex: _selectedIndex,
            isOnline: _isOnline,
            onSelectIndex: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(child: _buildCurrentScreen()),
        ],
      ),
    );
  }
}
