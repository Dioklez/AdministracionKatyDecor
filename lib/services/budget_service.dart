import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/budget_model.dart';

class BudgetService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  BudgetService({LocalRepository? repo}) : _repo = repo;

  Future<List<Budget>> getAll() async {
    try {
      final records = await _pb.collection('budgets').getFullList(
            sort: '-created',
          );
      final result = records.map(Budget.fromRecord).toList();
      await _repo?.upsertBudgets(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getBudgets();
        return local.map(_budgetFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<Budget> create(Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('budgets').create(body: data);
      return Budget.fromRecord(record);
    } catch (e) {
      print('BudgetService.create error: $e');
      rethrow;
    }
  }

  Future<Budget> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('budgets').update(id, body: data);
    return Budget.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('budgets').delete(id);
  }

  Budget _budgetFromLocal(LocalBudget row) => Budget(
        id: row.id,
        name: row.name,
        projectId: row.projectId,
        period: row.period,
        startDate: _dateStr(row.startDate),
        endDate: _dateStr(row.endDate),
        plannedAmount: row.plannedAmount ?? 0.0,
        actualAmount: row.actualAmount ?? 0.0,
        categoryId: row.categoryId,
        notes: row.notes,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
