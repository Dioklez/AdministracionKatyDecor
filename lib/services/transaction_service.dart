import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/transaction_model.dart';
import 'connectivity_service.dart';

class TransactionService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  TransactionService({LocalRepository? repo}) : _repo = repo;

  Future<List<Transaction>> getAll() async {
    if (!ConnectivityService.currentlyOnline) {
      if (_repo != null) {
        return (await _repo.getTransactions()).map(_txFromLocal).toList();
      }
      return [];
    }
    try {
      final records = await _pb.collection('transactions').getFullList(
            sort: '-date',
          );
      final result = records.map(Transaction.fromRecord).toList();
      await _repo?.upsertTransactions(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getTransactions();
        return local.map(_txFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<List<Transaction>> getByProject(String projectId) async {
    if (!ConnectivityService.currentlyOnline) {
      if (_repo != null) {
        final local = await _repo.getTransactionsByProject(projectId);
        return local.map(_txFromLocal).toList();
      }
      return [];
    }
    try {
      final records = await _pb.collection('transactions').getFullList(
            filter: 'project = "$projectId"',
            sort: '-date',
          );
      final result = records.map(Transaction.fromRecord).toList();
      await _repo?.upsertTransactions(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local =
            await _repo.getTransactionsByProject(projectId);
        return local.map(_txFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<Transaction> create(Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('transactions').create(body: data);
      final tx = Transaction.fromRecord(record);
      await _repo?.upsertTransaction(tx);
      return tx;
    } catch (e) {
      print('TransactionService.create error: $e');
      rethrow;
    }
  }

  Future<Transaction> update(String id, Map<String, dynamic> data) async {
    try {
      final record =
          await _pb.collection('transactions').update(id, body: data);
      final tx = Transaction.fromRecord(record);
      await _repo?.upsertTransaction(tx);
      return tx;
    } catch (e) {
      print('TransactionService.update error: $e');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _pb.collection('transactions').delete(id);
      await _repo?.deleteTransaction(id);
    } catch (e) {
      print('TransactionService.delete error: $e');
      rethrow;
    }
  }

  Transaction _txFromLocal(LocalTransaction row) => Transaction(
        id: row.id,
        description: row.description ?? '',
        amount: row.amount ?? 0.0,
        type: row.type ?? 'egreso',
        date: _dateStr(row.date) ?? '',
        projectId: row.projectId,
        categoryId: row.categoryId,
        accountId: row.accountId,
        notes: row.notes,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
