import 'package:drift/drift.dart';
import '../models/project.dart';
import '../models/transaction.dart';
import '../models/supplier.dart';
import '../models/supplier_product.dart';
import '../models/quote.dart';
import '../models/task.dart';
import '../models/account.dart';
import '../models/account_payment.dart';
import '../models/inventory_item.dart';
import '../models/inventory_movement.dart';
import '../models/budget.dart';
import 'app_database.dart';

class LocalRepository {
  final AppDatabase _db;
  LocalRepository(this._db);

  // ═══════════════════════════════════════════════════════════════════════
  // PROYECTOS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<Project>> getAllProjects() async {
    final rows = await _db.select(_db.projects).get();
    return rows.map(_projectFromRow).toList();
  }

  Future<List<Project>> getProjectsByStatus(String status) async {
    final rows = await (_db.select(_db.projects)
          ..where((t) => t.status.equals(status)))
        .get();
    return rows.map(_projectFromRow).toList();
  }

  Future<Project?> getProjectById(int id) async {
    final row = await (_db.select(_db.projects)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _projectFromRow(row) : null;
  }

  Future<void> upsertProject(Project p) async {
    await _db.into(_db.projects).insertOnConflictUpdate(_projectToCompanion(p));
  }

  Future<void> upsertProjects(List<Project> projects) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.projects, projects.map(_projectToCompanion).toList());
    });
  }

  Future<void> deleteProject(int id) async {
    await (_db.delete(_db.projects)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearProjects() async {
    await _db.delete(_db.projects).go();
  }

  Project _projectFromRow(ProjectRow row) => Project.fromJson({
        'id': row.id,
        'name': row.name,
        'client_name': row.clientName,
        'status': row.status,
        'color': row.color,
        'description': row.description,
        'created_at': row.createdAt,
        'quoted': row.quoted,
        'spent': row.spent,
        'pl': row.pl,
      });

  ProjectsCompanion _projectToCompanion(Project p) => ProjectsCompanion(
        id: Value(p.id),
        name: Value(p.name),
        clientName: Value(p.clientName),
        status: Value(p.status),
        color: Value(p.color),
        description: Value(p.description),
        createdAt: Value(p.createdAt),
        quoted: Value(p.quoted),
        spent: Value(p.spent),
        pl: Value(p.pl),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // TRANSACCIONES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<Transaction>> getAllTransactions() async {
    final rows = await _db.select(_db.transactions).get();
    return rows.map(_txFromRow).toList();
  }

  Future<List<Transaction>> getTransactionsByDateRange(
      String? from, String? to) async {
    final query = _db.select(_db.transactions);
    if (from != null) {
      query.where((t) => t.transactionDate.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((t) => t.transactionDate.isSmallerOrEqualValue(to));
    }
    final rows = await query.get();
    return rows.map(_txFromRow).toList();
  }

  Future<List<Transaction>> getTransactionsByProjectId(int projectId) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) => t.scopeId.equals(projectId))
          ..where((t) => t.scopeType.equals('project')))
        .get();
    return rows.map(_txFromRow).toList();
  }

  Future<List<Transaction>> getTransactionsByScope(String scope) async {
    final rows = await (_db.select(_db.transactions)
          ..where((t) => t.scopeType.equals(scope)))
        .get();
    return rows.map(_txFromRow).toList();
  }

  Future<void> upsertTransaction(Transaction t) async {
    await _db.into(_db.transactions).insertOnConflictUpdate(_txToCompanion(t));
  }

  Future<void> upsertTransactions(List<Transaction> txns) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.transactions, txns.map(_txToCompanion).toList());
    });
  }

  Future<void> deleteTransaction(int id) async {
    await (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }

  Future<void> clearTransactions() async {
    await _db.delete(_db.transactions).go();
  }

  Transaction _txFromRow(TransactionRow row) => Transaction.fromJson({
        'id': row.id,
        'type': row.type,
        'scope_type': row.scopeType,
        'scope_id': row.scopeId,
        'category_id': row.categoryId,
        'category_name': row.categoryName,
        'project_name': row.projectName,
        'project_color': row.projectColor,
        'description': row.description,
        'amount': row.amount,
        'currency': row.currency,
        'exchange_rate': row.exchangeRate,
        'amount_mxn': row.amountMxn,
        'transaction_date': row.transactionDate,
        'etapa': row.etapa,
        'notes': row.notes,
        'created_at': row.createdAt,
      });

  TransactionsCompanion _txToCompanion(Transaction t) => TransactionsCompanion(
        id: Value(t.id),
        type: Value(t.type),
        scopeType: Value(t.scopeType),
        scopeId: Value(t.scopeId),
        categoryId: Value(t.categoryId),
        categoryName: Value(t.categoryName),
        projectName: Value(t.projectName),
        projectColor: Value(t.projectColor),
        description: Value(t.description),
        amount: Value(t.amount),
        currency: Value(t.currency),
        exchangeRate: Value(t.exchangeRate),
        amountMxn: Value(t.amountMxn),
        transactionDate: Value(t.transactionDate),
        etapa: Value(t.etapa),
        notes: Value(t.notes),
        createdAt: Value(t.createdAt),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // PROVEEDORES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<Supplier>> getAllSuppliers() async {
    final rows = await _db.select(_db.suppliers).get();
    return rows.map(_supplierFromRow).toList();
  }

  Future<List<Supplier>> searchSuppliers(String query) async {
    final q = '%$query%';
    final rows = await (_db.select(_db.suppliers)
          ..where((t) => t.razonSocial.like(q)))
        .get();
    return rows.map(_supplierFromRow).toList();
  }

  Future<void> upsertSupplier(Supplier s) async {
    await _db
        .into(_db.suppliers)
        .insertOnConflictUpdate(_supplierToCompanion(s));
  }

  Future<void> upsertSuppliers(List<Supplier> suppliers) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.suppliers, suppliers.map(_supplierToCompanion).toList());
    });
  }

  Future<void> deleteSupplier(int id) async {
    await (_db.delete(_db.suppliers)..where((t) => t.id.equals(id))).go();
    await (_db.delete(_db.supplierProducts)
          ..where((t) => t.supplierId.equals(id)))
        .go();
  }

  Supplier _supplierFromRow(SupplierRow row) => Supplier.fromJson({
        'id': row.id,
        'razon_social': row.razonSocial,
        'rfc': row.rfc,
        'actividad': row.actividad,
        'ciudad': row.ciudad,
        'telefono': row.telefono,
        'email': row.email,
        'contacto': row.contacto,
      });

  SuppliersCompanion _supplierToCompanion(Supplier s) => SuppliersCompanion(
        id: Value(s.id),
        razonSocial: Value(s.razonSocial),
        rfc: Value(s.rfc),
        actividad: Value(s.actividad),
        ciudad: Value(s.ciudad),
        telefono: Value(s.telefono),
        email: Value(s.email),
        contacto: Value(s.contacto),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // PRODUCTOS DE PROVEEDOR
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<SupplierProduct>> getProductsBySupplierId(
      int supplierId) async {
    final rows = await (_db.select(_db.supplierProducts)
          ..where((t) => t.supplierId.equals(supplierId)))
        .get();
    return rows.map(_supplierProductFromRow).toList();
  }

  Future<void> upsertSupplierProduct(
      int supplierId, SupplierProduct product) async {
    await _db.into(_db.supplierProducts).insertOnConflictUpdate(
        _supplierProductToCompanion(supplierId, product));
  }

  Future<void> upsertSupplierProducts(
      int supplierId, List<SupplierProduct> products) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
        _db.supplierProducts,
        products
            .map((p) => _supplierProductToCompanion(supplierId, p))
            .toList(),
      );
    });
  }

  Future<void> deleteSupplierProduct(int id) async {
    await (_db.delete(_db.supplierProducts)..where((t) => t.id.equals(id)))
        .go();
  }

  SupplierProduct _supplierProductFromRow(SupplierProductRow row) =>
      SupplierProduct.fromJson({
        'id': row.id,
        'nombre': row.nombre,
        'unidad': row.unidad,
        'precio': row.precio,
        'moneda': row.moneda,
        'notas': row.notas,
      });

  SupplierProductsCompanion _supplierProductToCompanion(
          int supplierId, SupplierProduct p) =>
      SupplierProductsCompanion(
        id: Value(p.id),
        supplierId: Value(supplierId),
        nombre: Value(p.nombre),
        unidad: Value(p.unidad),
        precio: Value(p.precio),
        moneda: Value(p.moneda),
        notas: Value(p.notas),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // COTIZACIONES
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<Quote>> getAllQuotes() async {
    final rows = await _db.select(_db.quotes).get();
    return rows.map(_quoteFromRow).toList();
  }

  Future<List<Quote>> getQuotesByProjectId(int projectId) async {
    final rows = await (_db.select(_db.quotes)
          ..where((t) => t.projectId.equals(projectId)))
        .get();
    return rows.map(_quoteFromRow).toList();
  }

  Future<void> upsertQuote(Quote q) async {
    await _db.into(_db.quotes).insertOnConflictUpdate(_quoteToCompanion(q));
  }

  Future<void> upsertQuotes(List<Quote> quotes) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.quotes, quotes.map(_quoteToCompanion).toList());
    });
  }

  Future<void> deleteQuote(int id) async {
    await (_db.delete(_db.quotes)..where((t) => t.id.equals(id))).go();
  }

  Quote _quoteFromRow(QuoteRow row) => Quote.fromJson({
        'id': row.id,
        'project_id': row.projectId,
        'description': row.description,
        'amount_mxn': row.amountMxn,
        'currency': row.currency,
        'status': row.status,
        'created_at': row.createdAt,
      });

  QuotesCompanion _quoteToCompanion(Quote q) => QuotesCompanion(
        id: Value(q.id),
        projectId: Value(q.projectId),
        description: Value(q.description),
        amountMxn: Value(q.amountMxn),
        currency: Value(q.currency),
        status: Value(q.status),
        createdAt: Value(q.createdAt),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // TAREAS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<Task>> getAllTasks() async {
    final rows = await _db.select(_db.tasks).get();
    return rows.map(_taskFromRow).toList();
  }

  Future<List<Task>> getTasksByProjectId(int projectId) async {
    final rows = await (_db.select(_db.tasks)
          ..where((t) => t.proyectoId.equals(projectId)))
        .get();
    return rows.map(_taskFromRow).toList();
  }

  Future<void> upsertTask(Task t) async {
    await _db.into(_db.tasks).insertOnConflictUpdate(_taskToCompanion(t));
  }

  Future<void> upsertTasks(List<Task> tasks) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.tasks, tasks.map(_taskToCompanion).toList());
    });
  }

  Future<void> deleteTask(int id) async {
    await (_db.delete(_db.tasks)..where((t) => t.id.equals(id))).go();
  }

  Task _taskFromRow(TaskRow row) => Task.fromJson({
        'id': row.id,
        'fecha': row.fecha,
        'descripcion': row.descripcion,
        'completada': row.completada,
        'proyecto_id': row.proyectoId,
        'notas': row.notas,
      });

  TasksCompanion _taskToCompanion(Task t) => TasksCompanion(
        id: Value(t.id),
        fecha: Value(t.fecha),
        descripcion: Value(t.descripcion),
        completada: Value(t.completada),
        proyectoId: Value(t.proyectoId),
        notas: Value(t.notas),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // CUENTAS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<Account>> getAllAccounts() async {
    final rows = await _db.select(_db.accounts).get();
    return rows.map(_accountFromRow).toList();
  }

  Future<List<Account>> getAccountsFiltered(
      {String? tipo, String? estado}) async {
    final query = _db.select(_db.accounts);
    if (tipo != null) query.where((t) => t.tipo.equals(tipo));
    if (estado != null) query.where((t) => t.estado.equals(estado));
    final rows = await query.get();
    return rows.map(_accountFromRow).toList();
  }

  Future<Account?> getAccountById(int id) async {
    final row = await (_db.select(_db.accounts)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _accountFromRow(row) : null;
  }

  Future<void> upsertAccount(Account a) async {
    await _db
        .into(_db.accounts)
        .insertOnConflictUpdate(_accountToCompanion(a));
  }

  Future<void> upsertAccounts(List<Account> accounts) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.accounts, accounts.map(_accountToCompanion).toList());
    });
  }

  Future<void> deleteAccount(int id) async {
    await (_db.delete(_db.accounts)..where((t) => t.id.equals(id))).go();
    await (_db.delete(_db.accountPayments)
          ..where((t) => t.accountId.equals(id)))
        .go();
  }

  Account _accountFromRow(AccountRow row) => Account.fromJson({
        'id': row.id,
        'tipo': row.tipo,
        'contraparte': row.contraparte,
        'descripcion': row.descripcion,
        'monto_original': row.montoOriginal,
        'pagado': row.pagado,
        'saldo': row.saldo,
        'estado': row.estado,
        'fecha': row.fecha,
        'notas': row.notas,
        'created_at': row.createdAt,
      });

  AccountsCompanion _accountToCompanion(Account a) => AccountsCompanion(
        id: Value(a.id),
        tipo: Value(a.tipo),
        contraparte: Value(a.contraparte),
        descripcion: Value(a.descripcion),
        montoOriginal: Value(a.montoOriginal),
        pagado: Value(a.pagado),
        saldo: Value(a.saldo),
        estado: Value(a.estado),
        fecha: Value(a.fecha),
        notas: Value(a.notas),
        createdAt: Value(a.createdAt),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // PAGOS DE CUENTAS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<AccountPayment>> getPaymentsByAccountId(int accountId) async {
    final rows = await (_db.select(_db.accountPayments)
          ..where((t) => t.accountId.equals(accountId)))
        .get();
    return rows.map(_paymentFromRow).toList();
  }

  Future<void> upsertPayments(List<AccountPayment> payments) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.accountPayments, payments.map(_paymentToCompanion).toList());
    });
  }

  Future<void> deletePayment(int id) async {
    await (_db.delete(_db.accountPayments)..where((t) => t.id.equals(id)))
        .go();
  }

  AccountPayment _paymentFromRow(AccountPaymentRow row) =>
      AccountPayment.fromJson({
        'id': row.id,
        'account_id': row.accountId,
        'monto': row.monto,
        'fecha': row.fecha,
        'notas': row.notas,
        'created_at': row.createdAt,
      });

  AccountPaymentsCompanion _paymentToCompanion(AccountPayment p) =>
      AccountPaymentsCompanion(
        id: Value(p.id),
        accountId: Value(p.accountId),
        monto: Value(p.monto),
        fecha: Value(p.fecha),
        notas: Value(p.notas),
        createdAt: Value(p.createdAt),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // INVENTARIO
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<InventoryItem>> getAllInventoryItems() async {
    final rows = await _db.select(_db.inventoryItems).get();
    return rows.map(_invItemFromRow).toList();
  }

  Future<List<InventoryItem>> getInventoryFiltered(
      {String? tipo, String? query}) async {
    final q = _db.select(_db.inventoryItems);
    if (tipo != null) q.where((t) => t.tipo.equals(tipo));
    if (query != null && query.isNotEmpty) {
      q.where((t) => t.nombre.like('%$query%'));
    }
    final rows = await q.get();
    return rows.map(_invItemFromRow).toList();
  }

  Future<InventoryItem?> getInventoryItemById(int id) async {
    final row = await (_db.select(_db.inventoryItems)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row != null ? _invItemFromRow(row) : null;
  }

  Future<void> upsertInventoryItem(InventoryItem item) async {
    await _db
        .into(_db.inventoryItems)
        .insertOnConflictUpdate(_invItemToCompanion(item));
  }

  Future<void> upsertInventoryItems(List<InventoryItem> items) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.inventoryItems, items.map(_invItemToCompanion).toList());
    });
  }

  Future<void> deleteInventoryItem(int id) async {
    await (_db.delete(_db.inventoryItems)..where((t) => t.id.equals(id))).go();
    await (_db.delete(_db.inventoryMovements)
          ..where((t) => t.itemId.equals(id)))
        .go();
  }

  InventoryItem _invItemFromRow(InventoryItemRow row) => InventoryItem.fromJson({
        'id': row.id,
        'codigo': row.codigo,
        'nombre': row.nombre,
        'descripcion': row.descripcion,
        'tipo': row.tipo,
        'categoria': row.categoria,
        'unidad': row.unidad,
        'stock_actual': row.stockActual,
        'stock_minimo': row.stockMinimo,
        'precio_unitario': row.precioUnitario,
        'proveedor_id': row.proveedorId,
        'activo': row.activo,
        'notas': row.notas,
        'valor_total': row.valorTotal,
      });

  InventoryItemsCompanion _invItemToCompanion(InventoryItem item) =>
      InventoryItemsCompanion(
        id: Value(item.id),
        codigo: Value(item.codigo),
        nombre: Value(item.nombre),
        descripcion: Value(item.descripcion),
        tipo: Value(item.tipo),
        categoria: Value(item.categoria),
        unidad: Value(item.unidad),
        stockActual: Value(item.stockActual),
        stockMinimo: Value(item.stockMinimo),
        precioUnitario: Value(item.precioUnitario),
        proveedorId: Value(item.proveedorId),
        activo: Value(item.activo),
        notas: Value(item.notas),
        valorTotal: Value(item.valorTotal),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // MOVIMIENTOS DE INVENTARIO
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<InventoryMovement>> getMovementsByItemId(int itemId) async {
    final rows = await (_db.select(_db.inventoryMovements)
          ..where((t) => t.itemId.equals(itemId)))
        .get();
    return rows.map(_movementFromRow).toList();
  }

  Future<void> upsertMovements(List<InventoryMovement> movements) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(_db.inventoryMovements,
          movements.map(_movementToCompanion).toList());
    });
  }

  InventoryMovement _movementFromRow(InventoryMovementRow row) =>
      InventoryMovement.fromJson({
        'id': row.id,
        'item_id': row.itemId,
        'tipo': row.tipo,
        'cantidad': row.cantidad,
        'precio_unitario': row.precioUnitario,
        'referencia': row.referencia,
        'fecha': row.fecha,
        'created_at': row.createdAt,
      });

  InventoryMovementsCompanion _movementToCompanion(InventoryMovement m) =>
      InventoryMovementsCompanion(
        id: Value(m.id),
        itemId: Value(m.itemId),
        tipo: Value(m.tipo),
        cantidad: Value(m.cantidad),
        precioUnitario: Value(m.precioUnitario),
        referencia: Value(m.referencia),
        fecha: Value(m.fecha),
        createdAt: Value(m.createdAt),
      );

  // ═══════════════════════════════════════════════════════════════════════
  // PRESUPUESTOS
  // ═══════════════════════════════════════════════════════════════════════

  Future<List<Budget>> getBudgets() async {
    final rows = await _db.select(_db.budgets).get();
    return rows.map(_budgetFromRow).toList();
  }

  Future<void> upsertBudgets(List<Budget> budgets) async {
    await _db.batch((b) {
      b.insertAllOnConflictUpdate(
          _db.budgets, budgets.map(_budgetToCompanion).toList());
    });
  }

  Future<void> deleteBudget(int budgetId) async {
    await (_db.delete(_db.budgets)
          ..where((t) => t.budgetId.equals(budgetId)))
        .go();
  }

  Future<void> clearBudgets() async {
    await _db.delete(_db.budgets).go();
  }

  Budget _budgetFromRow(BudgetRow row) => Budget.fromJson({
        'budget_id': row.budgetId,
        'category_id': row.categoryId,
        'category_name': row.categoryName,
        'scope_type': row.scopeType,
        'limit': row.budgetLimit,
        'spent': row.spent,
        'remaining': row.remaining,
        'pct': row.pct,
        'alert_level': row.alertLevel,
        'alert_threshold_pct': row.alertThresholdPct,
      });

  BudgetsCompanion _budgetToCompanion(Budget b) => BudgetsCompanion(
        budgetId: Value(b.budgetId),
        categoryId: Value(b.categoryId),
        categoryName: Value(b.categoryName),
        scopeType: Value(b.scopeType),
        budgetLimit: Value(b.limit),
        spent: Value(b.spent),
        remaining: Value(b.remaining),
        pct: Value(b.pct),
        alertLevel: Value(b.alertLevel),
        alertThresholdPct: Value(b.alertThresholdPct),
      );

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

  /// Actualiza el ID local de una entidad cuando el servidor asigna el ID real,
  /// y cascadea el cambio a todas las tablas que referencian ese tempId como FK.
  Future<void> updateLocalId(
      String entityType, int tempId, int realId) async {
    switch (entityType) {
      case 'project':
        await _db.customStatement(
            'UPDATE projects SET id = ? WHERE id = ?', [realId, tempId]);
        await _db.customStatement(
            'UPDATE quotes SET project_id = ? WHERE project_id = ?',
            [realId, tempId]);
        await _db.customStatement(
            'UPDATE tasks SET proyecto_id = ? WHERE proyecto_id = ?',
            [realId, tempId]);
        await _db.customStatement(
            'UPDATE transactions SET scope_id = ? WHERE scope_id = ? AND scope_type = ?',
            [realId, tempId, 'project']);
      case 'quote':
        await _db.customStatement(
            'UPDATE quotes SET id = ? WHERE id = ?', [realId, tempId]);
      case 'task':
        await _db.customStatement(
            'UPDATE tasks SET id = ? WHERE id = ?', [realId, tempId]);
    }
  }

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
}
