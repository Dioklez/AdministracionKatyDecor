import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Cola de operaciones pendientes ─────────────────────────────────────────
class PendingOps extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get operation => text()();       // 'create' | 'update' | 'delete'
  IntColumn get entityId => integer().nullable()();
  IntColumn get tempId => integer().nullable()();
  TextColumn get endpoint => text()();
  TextColumn get payload => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  IntColumn get retries => integer().withDefault(const Constant(0))();
}

// ── Cache de JSON pre-computado (gráficas, dashboard) ─────────────────────
class CacheEntries extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {cacheKey};
}

// ── Tablas locales (caché offline de PocketBase) ───────────────────────────

class LocalProjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get clientName => text().nullable()();
  TextColumn get clientPhone => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  RealColumn get budget => real().nullable()();
  RealColumn get totalIncome => real().nullable()();
  RealColumn get totalExpense => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text().nullable()();
  TextColumn get color => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalAccounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get type => text().nullable()();
  RealColumn get balance => real().nullable()();
  RealColumn get initialBalance => real().nullable()();
  TextColumn get bankName => text().nullable()();
  TextColumn get accountNumber => text().nullable()();
  BoolColumn get isActive => boolean().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSuppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get contactName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive => boolean().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalTasks extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get stageId => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get priority => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get description => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get type => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get accountId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalQuotes extends Table {
  TextColumn get id => text()();
  TextColumn get folio => text().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get clientName => text().nullable()();
  TextColumn get clientPhone => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  DateTimeColumn get validUntil => dateTime().nullable()();
  TextColumn get status => text().nullable()();
  RealColumn get subtotal => real().nullable()();
  RealColumn get tax => real().nullable()();
  RealColumn get total => real().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get items => text().nullable()(); // JSON serializado
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalBudgets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get projectId => text().nullable()();
  TextColumn get period => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  RealColumn get plannedAmount => real().nullable()();
  RealColumn get actualAmount => real().nullable()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalSupplierProducts extends Table {
  TextColumn get id => text()();
  TextColumn get supplierId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get sku => text().nullable()();
  TextColumn get unit => text().nullable()();
  RealColumn get price => real().nullable()();
  BoolColumn get isActive => boolean().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalInventoryItems extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get unit => text().nullable()();
  RealColumn get currentStock => real().nullable()();
  RealColumn get minStock => real().nullable()();
  TextColumn get supplierProductId => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalInventoryMovements extends Table {
  TextColumn get id => text()();
  TextColumn get inventoryItemId => text().nullable()();
  TextColumn get type => text().nullable()();
  RealColumn get quantity => real().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalAccountPayments extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get amount => real().nullable()();
  TextColumn get type => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get status => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalRemisiones extends Table {
  TextColumn get id => text()();
  TextColumn get folio => text().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get supplierId => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get status => text().nullable()();
  RealColumn get subtotal => real().nullable()();
  RealColumn get tax => real().nullable()();
  RealColumn get total => real().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalFacturasEmitidas extends Table {
  TextColumn get id => text()();
  TextColumn get folio => text().nullable()();
  TextColumn get projectId => text().nullable()();
  TextColumn get clientName => text().nullable()();
  TextColumn get clientRfc => text().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  TextColumn get status => text().nullable()();
  RealColumn get subtotal => real().nullable()();
  RealColumn get tax => real().nullable()();
  RealColumn get total => real().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class LocalProjectStages extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().nullable()();
  IntColumn get order => integer().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Base de datos ──────────────────────────────────────────────────────────
@DriftDatabase(tables: [
  PendingOps,
  CacheEntries,
  LocalProjects,
  LocalCategories,
  LocalAccounts,
  LocalSuppliers,
  LocalTasks,
  LocalTransactions,
  LocalQuotes,
  LocalBudgets,
  LocalSupplierProducts,
  LocalInventoryItems,
  LocalInventoryMovements,
  LocalAccountPayments,
  LocalRemisiones,
  LocalFacturasEmitidas,
  LocalProjectStages,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // v1→v2: tablas transactions, quotes, budgets eliminadas (migradas a PocketBase)
          if (from < 2) {
            await customStatement('DROP TABLE IF EXISTS transactions');
            await customStatement('DROP TABLE IF EXISTS quotes');
            await customStatement('DROP TABLE IF EXISTS budgets');
          }
          // v2→v3: tablas inventory_items, inventory_movements eliminadas (migradas a PocketBase)
          if (from < 3) {
            await customStatement('DROP TABLE IF EXISTS inventory_items');
            await customStatement('DROP TABLE IF EXISTS inventory_movements');
          }
          // v3→v4: tablas locales de caché offline para las 15 colecciones
          if (from < 4) {
            await m.createTable(localProjects);
            await m.createTable(localCategories);
            await m.createTable(localAccounts);
            await m.createTable(localSuppliers);
            await m.createTable(localTasks);
            await m.createTable(localTransactions);
            await m.createTable(localQuotes);
            await m.createTable(localBudgets);
            await m.createTable(localSupplierProducts);
            await m.createTable(localInventoryItems);
            await m.createTable(localInventoryMovements);
            await m.createTable(localAccountPayments);
            await m.createTable(localRemisiones);
            await m.createTable(localFacturasEmitidas);
            await m.createTable(localProjectStages);
          }
        },
      );

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'katydecor.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
