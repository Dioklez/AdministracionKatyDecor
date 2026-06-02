import '../database/local_repository.dart';
import 'connectivity_service.dart';
import 'offline_queue_service.dart';
import 'project_service.dart';
import 'transaction_service.dart';
import 'category_service.dart';
import 'account_service.dart';
import 'supplier_service.dart';
import 'task_service.dart';
import 'quote_service.dart';
import 'budget_service.dart';
import 'supplier_product_service.dart';
import 'inventory_item_service.dart';
import 'inventory_movement_service.dart';
import 'account_payment_service.dart';
import 'remision_service.dart';
import 'project_stage_service.dart';
import 'recalculate_service.dart';

class SyncService {
  final OfflineQueueService _queue;
  final ConnectivityService _connectivity;
  final LocalRepository _repo;

  SyncService(this._queue, this._connectivity, this._repo);

  bool get isSyncing => false;

  /// Llamado cuando se detecta reconexión:
  /// sube operaciones pendientes y refresca el caché local.
  Future<void> syncOnReconnect() async {
    if (!_connectivity.isOnline) return;
    await _queue.processPendingOps();       // 1. sube cambios offline a PocketBase
    await _refreshLocalCache();             // 2. descarga todos los registros reales
    await _repo.cleanupTempRecords();       // 3. borra temp_ ahora que el real ya existe
    await _recalculateAllProjects();        // 4. actualiza totales en PocketBase
  }

  Future<void> _recalculateAllProjects() async {
    try {
      final projects = await ProjectService(repo: _repo).getAll();
      for (final p in projects) {
        await RecalculateService().recalculateProject(p.id);
      }
    } catch (_) {
      // best-effort — no interrumpir el flujo si falla
    }
  }

  /// Alias para backward-compat con código existente.
  Future<SyncResult> fullSync() async {
    await syncOnReconnect();
    return SyncResult(pendingPushed: 0, errors: []);
  }

  Future<void> _refreshLocalCache() async {
    try {
      final repo = _repo;
      await Future.wait([
        ProjectService(repo: repo).getAll(),
        TransactionService(repo: repo).getAll(),
        CategoryService(repo: repo).getAll(),
        AccountService(repo: repo).getAll(),
        SupplierService(repo: repo).getAll(),
        TaskService(repo: repo).getAll(),
        QuoteService(repo: repo).getAll(),
        BudgetService(repo: repo).getAll(),
        SupplierProductService(repo: repo).getAll(),
        InventoryItemService(repo: repo).getAll(),
        InventoryMovementService(repo: repo).getAll(),
        AccountPaymentService(repo: repo).getAll(),
        RemisionService(repo: repo).getAll(),
        ProjectStageService(repo: repo).getAll(),
      ]);
    } catch (_) {
      // Refresh es best-effort — no interrumpir si falla alguna collection
    }
  }
}

class SyncResult {
  final int pendingPushed;
  final List<String> errors;
  bool get hasErrors => errors.isNotEmpty;

  SyncResult({required this.pendingPushed, required this.errors});
}
