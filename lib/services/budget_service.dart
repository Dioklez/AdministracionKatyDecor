import '../core/pocketbase_service.dart';
import '../models/budget_model.dart';

class BudgetService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Budget>> getAll() async {
    final records = await _pb.collection('budgets').getFullList(
          sort: '-created',
        );
    return records.map(Budget.fromRecord).toList();
  }

  Future<Budget> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('budgets').create(body: data);
    return Budget.fromRecord(record);
  }

  Future<Budget> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('budgets').update(id, body: data);
    return Budget.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('budgets').delete(id);
  }
}
