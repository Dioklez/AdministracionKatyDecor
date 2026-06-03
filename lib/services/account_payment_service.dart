import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/account_payment_model.dart';
import 'connectivity_service.dart';

class AccountPaymentService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  AccountPaymentService({LocalRepository? repo}) : _repo = repo;

  Future<List<AccountPayment>> getAll() async {
    if (!ConnectivityService.currentlyOnline) {
      if (_repo != null) {
        return (await _repo.getAccountPayments()).map(_paymentFromLocal).toList();
      }
      return [];
    }
    try {
      final records = await _pb.collection('account_payments').getFullList(
            sort: '-date',
          );
      final result = records.map(AccountPayment.fromRecord).toList();
      await _repo?.upsertAccountPayments(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getAccountPayments();
        return local.map(_paymentFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<List<AccountPayment>> getByAccount(String accountId) async {
    if (!ConnectivityService.currentlyOnline) {
      if (_repo != null) {
        final local = await _repo.getPaymentsByAccount(accountId);
        return local.map(_paymentFromLocal).toList();
      }
      return [];
    }
    try {
      final records = await _pb.collection('account_payments').getFullList(
            filter: "account='$accountId'",
            sort: '-date',
          );
      final result = records.map(AccountPayment.fromRecord).toList();
      await _repo?.upsertAccountPayments(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getPaymentsByAccount(accountId);
        return local.map(_paymentFromLocal).toList();
      }
      rethrow;
    }
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

  AccountPayment _paymentFromLocal(LocalAccountPayment row) => AccountPayment(
        id: row.id,
        accountId: row.accountId ?? '',
        description: row.description,
        amount: row.amount ?? 0.0,
        type: row.type ?? 'pago',
        date: _dateStr(row.date),
        projectId: row.projectId,
        status: row.status ?? 'pendiente',
        dueDate: _dateStr(row.dueDate),
        notes: row.notes,
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
