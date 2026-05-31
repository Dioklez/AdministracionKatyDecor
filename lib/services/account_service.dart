import '../core/pocketbase_service.dart';
import '../models/account_model.dart';

class AccountService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Account>> getAll() async {
    final records = await _pb.collection('accounts').getFullList(
          sort: 'name',
        );
    return records.map(Account.fromRecord).toList();
  }

  Future<Account> create(Map<String, dynamic> data) async {
    final record = await _pb.collection('accounts').create(body: data);
    return Account.fromRecord(record);
  }

  Future<Account> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('accounts').update(id, body: data);
    return Account.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('accounts').delete(id);
  }
}
