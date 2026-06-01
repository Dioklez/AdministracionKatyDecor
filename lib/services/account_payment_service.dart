import '../core/pocketbase_service.dart';
import '../models/account_payment_model.dart';

class AccountPaymentService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<AccountPayment>> getAll() async {
    final records = await _pb.collection('account_payments').getFullList(
          sort: '-date',
        );
    return records.map(AccountPayment.fromRecord).toList();
  }

  Future<List<AccountPayment>> getByAccount(String accountId) async {
    final records = await _pb.collection('account_payments').getFullList(
          filter: "account='$accountId'",
          sort: '-date',
        );
    return records.map(AccountPayment.fromRecord).toList();
  }

  Future<AccountPayment> create(Map<String, dynamic> data) async {
    final record =
        await _pb.collection('account_payments').create(body: data);
    return AccountPayment.fromRecord(record);
  }

  Future<AccountPayment> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('account_payments').update(id, body: data);
    return AccountPayment.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('account_payments').delete(id);
  }
}
