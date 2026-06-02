import 'dart:convert';
import 'package:drift/drift.dart';
import 'app_database.dart';
import '../models/project_model.dart';
import '../models/category_model.dart';
import '../models/account_model.dart';
import '../models/supplier_model.dart';
import '../models/task_model.dart';
import '../models/transaction_model.dart';
import '../models/quote_model.dart';
import '../models/budget_model.dart';
import '../models/supplier_product_model.dart';
import '../models/inventory_item_model.dart';
import '../models/inventory_movement_model.dart';
import '../models/account_payment_model.dart';
import '../models/remision_model.dart';
import '../models/project_stage_model.dart';

class LocalRepository {
  final AppDatabase _db;
  LocalRepository(this._db);

  // ═══════════════════════════════════════════════════════════════════════
  // COLA DE OPERACIONES PENDIENTES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<PendingOp>> getAllPendingOps() async {
    return (_db.select(_db.pendingOps)
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .get();
  }

  Future<int> getPendingOpsCount() async {
    final count =
        _db.pendingOps.id.count();
    final query = _db.selectOnly(_db.pendingOps)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  Future<void> addPendingOp({
    required String entityType,
    required String operation,
    int? entityId,
    int? tempId,
    required String endpoint,
    String? payload,
  }) async {
    await _db.into(_db.pendingOps).insert(PendingOpsCompanion.insert(
          entityType: entityType,
          operation: operation,
          entityId: Value(entityId),
          tempId: Value(tempId),
          endpoint: endpoint,
          payload: Value(payload),
        ));
  }

  Future<void> deletePendingOp(int id) async {
    await (_db.delete(_db.pendingOps)..where((t) => t.id.equals(id))).go();
  }

  Future<void> incrementRetries(int id) async {
    final op = await (_db.select(_db.pendingOps)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (op != null) {
      await (_db.update(_db.pendingOps)..where((t) => t.id.equals(id)))
          .write(PendingOpsCompanion(retries: Value(op.retries + 1)));
    }
  }

  Future<void> updatePendingOpPayload(int opId, String newPayload) async {
    await (_db.update(_db.pendingOps)..where((t) => t.id.equals(opId)))
        .write(PendingOpsCompanion(payload: Value(newPayload)));
  }

  Future<void> updateLocalId(
      String entityType, int tempId, int realId) async {}

  // ═══════════════════════════════════════════════════════════════════════
  // CACHE DE JSON
  // ═══════════════════════════════════════════════════════════════════════

  Future<String?> getCacheEntry(String key) async {
    final row = await (_db.select(_db.cacheEntries)
          ..where((t) => t.cacheKey.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> setCacheEntry(String key, String jsonValue) async {
    await _db.into(_db.cacheEntries).insertOnConflictUpdate(
          CacheEntriesCompanion(
            cacheKey: Value(key),
            value: Value(jsonValue),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> deleteCacheEntry(String key) async {
    await (_db.delete(_db.cacheEntries)
          ..where((t) => t.cacheKey.equals(key)))
        .go();
  }

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 1 — PROJECTS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalProject>> getProjects() =>
      _db.select(_db.localProjects).get();

  Future<void> upsertProjects(List<Project> projects) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localProjects,
        projects.map(_projectCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> upsertProject(Project p) async {
    await _db
        .into(_db.localProjects)
        .insert(_projectCompanion(p), mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteProject(String id) async {
    await (_db.delete(_db.localProjects)..where((t) => t.id.equals(id))).go();
  }

  LocalProjectsCompanion _projectCompanion(Project p) =>
      LocalProjectsCompanion(
        id: Value(p.id),
        name: Value(p.name),
        clientName: Value(p.clientName),
        clientPhone: Value(p.clientPhone),
        description: Value(p.description),
        status: Value(p.status),
        startDate: Value(p.startDate != null ? DateTime.tryParse(p.startDate!) : null),
        endDate: Value(p.endDate != null ? DateTime.tryParse(p.endDate!) : null),
        budget: Value(p.budget),
        totalIncome: Value(p.totalIncome),
        totalExpense: Value(p.totalExpense),
        notes: Value(p.notes),
        color: Value(p.color),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 2 — CATEGORIES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalCategory>> getCategories() =>
      _db.select(_db.localCategories).get();

  Future<void> upsertCategories(List<Category> categories) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localCategories,
        categories.map(_categoryCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  LocalCategoriesCompanion _categoryCompanion(Category c) =>
      LocalCategoriesCompanion(
        id: Value(c.id),
        name: Value(c.name),
        type: Value(c.type),
        color: Value(c.color),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 3 — ACCOUNTS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalAccount>> getAccounts() =>
      _db.select(_db.localAccounts).get();

  Future<void> upsertAccounts(List<Account> accounts) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localAccounts,
        accounts.map(_accountCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> upsertAccount(Account a) async {
    await _db
        .into(_db.localAccounts)
        .insert(_accountCompanion(a), mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteAccount(String id) async {
    await (_db.delete(_db.localAccounts)..where((t) => t.id.equals(id))).go();
  }

  LocalAccountsCompanion _accountCompanion(Account a) =>
      LocalAccountsCompanion(
        id: Value(a.id),
        name: Value(a.name),
        type: Value(a.type),
        balance: Value(a.balance),
        initialBalance: Value(a.initialBalance),
        bankName: Value(a.bankName),
        accountNumber: Value(a.accountNumber),
        isActive: Value(a.isActive),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 4 — SUPPLIERS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalSupplier>> getSuppliers() =>
      _db.select(_db.localSuppliers).get();

  Future<void> upsertSuppliers(List<Supplier> suppliers) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localSuppliers,
        suppliers.map(_supplierCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> upsertSupplier(Supplier s) async {
    await _db
        .into(_db.localSuppliers)
        .insert(_supplierCompanion(s), mode: InsertMode.insertOrReplace);
  }

  LocalSuppliersCompanion _supplierCompanion(Supplier s) =>
      LocalSuppliersCompanion(
        id: Value(s.id),
        name: Value(s.name),
        contactName: Value(s.contactName),
        phone: Value(s.phone),
        email: Value(s.email),
        address: Value(s.address),
        notes: Value(s.notes),
        isActive: Value(s.isActive),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 5 — TRANSACTIONS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalTransaction>> getTransactions() =>
      _db.select(_db.localTransactions).get();

  Future<List<LocalTransaction>> getTransactionsByProject(
      String projectId) async {
    return (_db.select(_db.localTransactions)
          ..where((t) => t.projectId.equals(projectId)))
        .get();
  }

  Future<void> upsertTransactions(List<Transaction> transactions) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localTransactions,
        transactions.map(_transactionCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> upsertTransaction(Transaction t) async {
    await _db
        .into(_db.localTransactions)
        .insert(_transactionCompanion(t), mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteTransaction(String id) async {
    await (_db.delete(_db.localTransactions)..where((t) => t.id.equals(id)))
        .go();
  }

  LocalTransactionsCompanion _transactionCompanion(Transaction t) =>
      LocalTransactionsCompanion(
        id: Value(t.id),
        description: Value(t.description),
        amount: Value(t.amount),
        type: Value(t.type),
        date: Value(DateTime.tryParse(t.date)),
        projectId: Value(t.projectId),
        categoryId: Value(t.categoryId),
        accountId: Value(t.accountId),
        notes: Value(t.notes),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 6 — TASKS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalTask>> getTasks() => _db.select(_db.localTasks).get();

  Future<void> upsertTasks(List<Task> tasks) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localTasks,
        tasks.map(_taskCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> upsertTask(Task t) async {
    await _db
        .into(_db.localTasks)
        .insert(_taskCompanion(t), mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteTask(String id) async {
    await (_db.delete(_db.localTasks)..where((t) => t.id.equals(id))).go();
  }

  LocalTasksCompanion _taskCompanion(Task t) => LocalTasksCompanion(
        id: Value(t.id),
        title: Value(t.title),
        description: Value(t.description),
        projectId: Value(t.projectId),
        stageId: Value(t.stageId),
        status: Value(t.status),
        priority: Value(t.priority),
        dueDate: Value(t.dueDate != null ? DateTime.tryParse(t.dueDate!) : null),
        completedAt:
            Value(t.completedAt != null ? DateTime.tryParse(t.completedAt!) : null),
        notes: Value(t.notes),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 7 — QUOTES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalQuote>> getQuotes() => _db.select(_db.localQuotes).get();

  Future<void> upsertQuotes(List<Quote> quotes) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localQuotes,
        quotes.map(_quoteCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  LocalQuotesCompanion _quoteCompanion(Quote q) => LocalQuotesCompanion(
        id: Value(q.id),
        folio: Value(q.folio),
        projectId: Value(q.projectId),
        clientName: Value(q.clientName),
        clientPhone: Value(q.clientPhone),
        date: Value(q.date != null ? DateTime.tryParse(q.date!) : null),
        validUntil:
            Value(q.validUntil != null ? DateTime.tryParse(q.validUntil!) : null),
        status: Value(q.status),
        subtotal: Value(q.subtotal),
        tax: Value(q.tax),
        total: Value(q.total),
        notes: Value(q.notes),
        items: Value(jsonEncode(q.items)),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 8 — BUDGETS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalBudget>> getBudgets() => _db.select(_db.localBudgets).get();

  Future<void> upsertBudgets(List<Budget> budgets) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localBudgets,
        budgets.map(_budgetCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  LocalBudgetsCompanion _budgetCompanion(Budget b) => LocalBudgetsCompanion(
        id: Value(b.id),
        name: Value(b.name),
        projectId: Value(b.projectId),
        period: Value(b.period),
        startDate:
            Value(b.startDate != null ? DateTime.tryParse(b.startDate!) : null),
        endDate: Value(b.endDate != null ? DateTime.tryParse(b.endDate!) : null),
        plannedAmount: Value(b.plannedAmount),
        actualAmount: Value(b.actualAmount),
        categoryId: Value(b.categoryId),
        notes: Value(b.notes),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 9 — SUPPLIER PRODUCTS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalSupplierProduct>> getSupplierProducts() =>
      _db.select(_db.localSupplierProducts).get();

  Future<List<LocalSupplierProduct>> getSupplierProductsBySupplier(
      String supplierId) async {
    return (_db.select(_db.localSupplierProducts)
          ..where((t) => t.supplierId.equals(supplierId)))
        .get();
  }

  Future<void> upsertSupplierProducts(List<SupplierProduct> products) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localSupplierProducts,
        products.map(_supplierProductCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  LocalSupplierProductsCompanion _supplierProductCompanion(
          SupplierProduct sp) =>
      LocalSupplierProductsCompanion(
        id: Value(sp.id),
        supplierId: Value(sp.supplierId),
        name: Value(sp.name),
        description: Value(sp.description),
        sku: Value(sp.sku),
        unit: Value(sp.unit),
        price: Value(sp.price),
        isActive: Value(sp.isActive),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 10 — INVENTORY ITEMS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalInventoryItem>> getInventoryItems() =>
      _db.select(_db.localInventoryItems).get();

  Future<void> upsertInventoryItems(List<InventoryItem> items) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localInventoryItems,
        items.map(_inventoryItemCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> upsertInventoryItem(InventoryItem item) async {
    await _db
        .into(_db.localInventoryItems)
        .insert(_inventoryItemCompanion(item), mode: InsertMode.insertOrReplace);
  }

  LocalInventoryItemsCompanion _inventoryItemCompanion(InventoryItem item) =>
      LocalInventoryItemsCompanion(
        id: Value(item.id),
        name: Value(item.name),
        description: Value(item.description),
        unit: Value(item.unit),
        currentStock: Value(item.currentStock),
        minStock: Value(item.minStock),
        supplierProductId: Value(item.supplierProductId),
        location: Value(item.location),
        notes: Value(item.notes),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 11 — INVENTORY MOVEMENTS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalInventoryMovement>> getInventoryMovements() =>
      _db.select(_db.localInventoryMovements).get();

  Future<List<LocalInventoryMovement>> getMovementsByItem(
      String itemId) async {
    return (_db.select(_db.localInventoryMovements)
          ..where((t) => t.inventoryItemId.equals(itemId)))
        .get();
  }

  Future<void> upsertInventoryMovements(
      List<InventoryMovement> movements) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localInventoryMovements,
        movements.map(_inventoryMovementCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  LocalInventoryMovementsCompanion _inventoryMovementCompanion(
          InventoryMovement m) =>
      LocalInventoryMovementsCompanion(
        id: Value(m.id),
        inventoryItemId: Value(m.inventoryItemId),
        type: Value(m.type),
        quantity: Value(m.quantity),
        date: Value(m.date != null ? DateTime.tryParse(m.date!) : null),
        projectId: Value(m.projectId),
        notes: Value(m.notes),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 12 — ACCOUNT PAYMENTS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalAccountPayment>> getAccountPayments() =>
      _db.select(_db.localAccountPayments).get();

  Future<List<LocalAccountPayment>> getPaymentsByAccount(
      String accountId) async {
    return (_db.select(_db.localAccountPayments)
          ..where((t) => t.accountId.equals(accountId)))
        .get();
  }

  Future<void> upsertAccountPayments(List<AccountPayment> payments) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localAccountPayments,
        payments.map(_accountPaymentCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  LocalAccountPaymentsCompanion _accountPaymentCompanion(AccountPayment p) =>
      LocalAccountPaymentsCompanion(
        id: Value(p.id),
        accountId: Value(p.accountId),
        description: Value(p.description),
        amount: Value(p.amount),
        type: Value(p.type),
        date: Value(p.date != null ? DateTime.tryParse(p.date!) : null),
        projectId: Value(p.projectId),
        status: Value(p.status),
        dueDate: Value(p.dueDate != null ? DateTime.tryParse(p.dueDate!) : null),
        notes: Value(p.notes),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 13 — REMISIONES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalRemisione>> getRemisiones() =>
      _db.select(_db.localRemisiones).get();

  Future<void> upsertRemisiones(List<Remision> remisiones) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localRemisiones,
        remisiones.map(_remisionCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  LocalRemisionesCompanion _remisionCompanion(Remision r) =>
      LocalRemisionesCompanion(
        id: Value(r.id),
        folio: Value(r.folio),
        projectId: Value(r.projectId),
        supplierId: Value(r.supplierId),
        date: Value(r.date != null ? DateTime.tryParse(r.date!) : null),
        status: Value(r.status),
        subtotal: Value(r.subtotal),
        tax: Value(r.tax),
        total: Value(r.total),
        notes: Value(r.notes),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // GROUP 14 — PROJECT STAGES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<LocalProjectStage>> getProjectStages() =>
      _db.select(_db.localProjectStages).get();

  Future<List<LocalProjectStage>> getStagesByProject(String projectId) async {
    return (_db.select(_db.localProjectStages)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([(t) => OrderingTerm.asc(t.order)]))
        .get();
  }

  Future<void> upsertProjectStages(List<ProjectStage> stages) async {
    await _db.batch((batch) {
      batch.insertAll(
        _db.localProjectStages,
        stages.map(_projectStageCompanion).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }

  Future<void> upsertProjectStage(ProjectStage s) async {
    await _db
        .into(_db.localProjectStages)
        .insert(_projectStageCompanion(s), mode: InsertMode.insertOrReplace);
  }

  Future<void> deleteProjectStage(String id) async {
    await (_db.delete(_db.localProjectStages)..where((t) => t.id.equals(id)))
        .go();
  }

  LocalProjectStagesCompanion _projectStageCompanion(ProjectStage s) =>
      LocalProjectStagesCompanion(
        id: Value(s.id),
        projectId: Value(s.projectId),
        name: Value(s.name),
        description: Value(s.description),
        status: Value(s.status),
        order: Value(s.order),
        startDate:
            Value(s.startDate != null ? DateTime.tryParse(s.startDate!) : null),
        endDate: Value(s.endDate != null ? DateTime.tryParse(s.endDate!) : null),
        syncedAt: Value(DateTime.now()),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // LIMPIEZA DE REGISTROS TEMPORALES
  // ═══════════════════════════════════════════════════════════════════════

  /// Borra de SQLite todos los registros con id que empiece por 'temp_'.
  /// Se llama DESPUÉS de _refreshLocalCache() para que el registro real
  /// ya esté en SQLite antes de eliminar el temporal — sin ventana vacía.
  Future<void> cleanupTempRecords() async {
    await (_db.delete(_db.localProjects)
          ..where((t) => t.id.like('temp_%')))
        .go();
    await (_db.delete(_db.localTransactions)
          ..where((t) => t.id.like('temp_%')))
        .go();
    await (_db.delete(_db.localTasks)
          ..where((t) => t.id.like('temp_%')))
        .go();
    await (_db.delete(_db.localAccounts)
          ..where((t) => t.id.like('temp_%')))
        .go();
  }
}
