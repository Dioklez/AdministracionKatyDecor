import '../core/pocketbase_service.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Transaction>> getAll() async {
    final records = await _pb.collection('transactions').getFullList(
          sort: '-date',
        );
    return records.map(Transaction.fromRecord).toList();
  }

  Future<List<Transaction>> getByProject(String projectId) async {
    final records = await _pb.collection('transactions').getFullList(
          filter: 'projectId = "$projectId"',
          sort: '-date',
        );
    return records.map(Transaction.fromRecord).toList();
  }

  Future<Transaction> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('transactions').create(body: data);
    return Transaction.fromRecord(record);
  }

  Future<Transaction> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('transactions').update(id, body: data);
    return Transaction.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('transactions').delete(id);
  }
}
