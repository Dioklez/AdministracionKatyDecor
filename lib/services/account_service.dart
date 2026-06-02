import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/account_model.dart';

class AccountService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  AccountService({LocalRepository? repo}) : _repo = repo;

  Future<List<Account>> getAll() async {
    try {
      final records = await _pb.collection('accounts').getFullList(
            sort: 'name',
          );
      final result = records.map(Account.fromRecord).toList();
      await _repo?.upsertAccounts(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getAccounts();
        return local.map(_accountFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<Account> getById(String id) async {
    final record = await _pb.collection('accounts').getOne(id);
    return Account.fromRecord(record);
  }

  Future<Account> create(Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('accounts').create(body: data);
      final account = Account.fromRecord(record);
      await _repo?.upsertAccount(account);
      return account;
    } catch (e) {
      print('AccountService.create error: $e');
      rethrow;
    }
  }

  Future<Account> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('accounts').update(id, body: data);
    final account = Account.fromRecord(record);
    await _repo?.upsertAccount(account);
    return account;
  }

  Future<void> delete(String id) async {
    await _pb.collection('accounts').delete(id);
  }

  Account _accountFromLocal(LocalAccount row) => Account(
        id: row.id,
        name: row.name,
        type: row.type ?? 'banco',
        balance: row.balance ?? 0.0,
        initialBalance: row.initialBalance ?? 0.0,
        bankName: row.bankName,
        accountNumber: row.accountNumber,
        isActive: row.isActive ?? true,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}
