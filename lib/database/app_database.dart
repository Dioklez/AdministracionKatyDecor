import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Transacciones ──────────────────────────────────────────────────────────
@DataClassName('TransactionRow')
class Transactions extends Table {
  IntColumn get id => integer()();
  TextColumn get type => text()();
  TextColumn get scopeType => text()();
  IntColumn get scopeId => integer().nullable()();
  IntColumn get categoryId => integer().nullable()();
  TextColumn get categoryName => text().nullable()();
  TextColumn get projectName => text().nullable()();
  TextColumn get projectColor => text().nullable()();
  TextColumn get description => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text()();
  RealColumn get exchangeRate => real()();
  RealColumn get amountMxn => real()();
  TextColumn get transactionDate => text()();
  TextColumn get etapa => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Cotizaciones ───────────────────────────────────────────────────────────
@DataClassName('QuoteRow')
class Quotes extends Table {
  IntColumn get id => integer()();
  IntColumn get projectId => integer()();
  TextColumn get description => text().nullable()();
  RealColumn get amountMxn => real()();
  TextColumn get currency => text().withDefault(const Constant('MXN'))();
  TextColumn get status => text().withDefault(const Constant('pendiente'))();
  TextColumn get createdAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Inventario ─────────────────────────────────────────────────────────────
@DataClassName('InventoryItemRow')
class InventoryItems extends Table {
  IntColumn get id => integer()();
  TextColumn get codigo => text().nullable()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get tipo => text()();
  TextColumn get categoria => text().nullable()();
  TextColumn get unidad => text().withDefault(const Constant('pieza'))();
  RealColumn get stockActual => real().withDefault(const Constant(0.0))();
  RealColumn get stockMinimo => real().nullable()();
  RealColumn get precioUnitario => real().withDefault(const Constant(0.0))();
  IntColumn get proveedorId => integer().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  TextColumn get notas => text().nullable()();
  RealColumn get valorTotal => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Movimientos de inventario ──────────────────────────────────────────────
@DataClassName('InventoryMovementRow')
class InventoryMovements extends Table {
  IntColumn get id => integer()();
  IntColumn get itemId => integer()();
  TextColumn get tipo => text()();
  RealColumn get cantidad => real()();
  RealColumn get precioUnitario => real().nullable()();
  TextColumn get referencia => text().nullable()();
  TextColumn get fecha => text().nullable()();
  TextColumn get createdAt => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Presupuestos ───────────────────────────────────────────────────────────
// NOTA: 'limit' es palabra reservada en SQL — se usa 'budgetLimit'
@DataClassName('BudgetRow')
class Budgets extends Table {
  IntColumn get budgetId => integer()();
  IntColumn get categoryId => integer()();
  TextColumn get categoryName => text()();
  TextColumn get scopeType => text()();
  RealColumn get budgetLimit => real()();
  RealColumn get spent => real().withDefault(const Constant(0.0))();
  RealColumn get remaining => real().withDefault(const Constant(0.0))();
  RealColumn get pct => real().withDefault(const Constant(0.0))();
  TextColumn get alertLevel => text().withDefault(const Constant('ok'))();
  IntColumn get alertThresholdPct => integer().withDefault(const Constant(80))();

  @override
  Set<Column> get primaryKey => {budgetId};
}

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

// ── Base de datos ──────────────────────────────────────────────────────────
@DriftDatabase(tables: [
  Transactions,
  Quotes,
  InventoryItems,
  InventoryMovements,
  Budgets,
  PendingOps,
  CacheEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'katydecor.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
