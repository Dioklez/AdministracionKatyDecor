import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

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
  InventoryItems,
  InventoryMovements,
  PendingOps,
  CacheEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // v1→v2: tablas transactions, quotes, budgets eliminadas (migradas a PocketBase)
          if (from < 2) {
            await customStatement('DROP TABLE IF EXISTS transactions');
            await customStatement('DROP TABLE IF EXISTS quotes');
            await customStatement('DROP TABLE IF EXISTS budgets');
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
