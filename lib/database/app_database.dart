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

// ── Base de datos ──────────────────────────────────────────────────────────
@DriftDatabase(tables: [
  PendingOps,
  CacheEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
