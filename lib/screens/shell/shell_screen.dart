import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../services/connectivity_service.dart';
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
import '../remisiones/remisiones_screen.dart';
import '../facturas/facturas_screen.dart';
import '../categories/categories_screen.dart';
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

  // Referencias guardadas en initState — no usar context.read() en dispose()
  AuthService? _authService;
  SyncService? _syncService;
  ConnectivityService? _connectivityService;

  @override
  void initState() {
    super.initState();
    _authService = context.read<AuthService>();
    _syncService = context.read<SyncService>();
    _connectivityService = context.read<ConnectivityService>();
    _authService!.addListener(_onAuthChanged);
    _connectivityService!.addListener(_onConnectivityChanged);

    // Verificar actualizaciones sin interferir con la carga inicial
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) UpdateService.checkForUpdates(context);
    });
  }

  @override
  void dispose() {
    _authService?.removeListener(_onAuthChanged);
    _connectivityService?.removeListener(_onConnectivityChanged);
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

  void _onConnectivityChanged() {
    if (_connectivityService?.isOnline == true) {
      _syncService?.fullSync().then((_) {}, onError: (_) {});
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
      case 10:
        return const RemisionesScreen();
      case 11:
        return const FacturasScreen();
      case 12:
        return const CategoriesScreen();
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
            onSelectIndex: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(child: _buildCurrentScreen()),
        ],
      ),
    );
  }
}
