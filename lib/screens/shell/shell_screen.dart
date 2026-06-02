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
  int _refreshToken = 0;

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
      _syncService?.fullSync().then((_) {
        if (mounted) setState(() => _refreshToken++);
      }, onError: (_) {});
    }
  }

  Widget _buildCurrentScreen() {
    switch (_selectedIndex) {
      case 0:
        return DashboardScreen(key: ValueKey('dash_$_refreshToken'));
      case 1:
        return TransactionsScreen(key: ValueKey('txn_$_refreshToken'));
      case 2:
        return ProjectsScreen(key: ValueKey('prj_$_refreshToken'));
      case 3:
        return TasksScreen(key: ValueKey('tsk_$_refreshToken'));
      case 4:
        return PlaceholderScreen(
            key: ValueKey('rep_$_refreshToken'),
            title: 'Reportes',
            icon: Icons.bar_chart_outlined);
      case 5:
        return QuotesScreen(key: ValueKey('qts_$_refreshToken'));
      case 6:
        return SuppliersScreen(key: ValueKey('sup_$_refreshToken'));
      case 7:
        return InventoryScreen(key: ValueKey('inv_$_refreshToken'));
      case 8:
        return AccountsScreen(key: ValueKey('acc_$_refreshToken'));
      case 9:
        return BudgetsScreen(key: ValueKey('bud_$_refreshToken'));
      case 10:
        return RemisionesScreen(key: ValueKey('rem_$_refreshToken'));
      case 11:
        return FacturasScreen(key: ValueKey('fac_$_refreshToken'));
      case 12:
        return CategoriesScreen(key: ValueKey('cat_$_refreshToken'));
      default:
        return DashboardScreen(key: ValueKey('dash_$_refreshToken'));
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
