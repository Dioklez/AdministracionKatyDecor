import 'transaction_service.dart';
import 'project_service.dart';
import 'account_service.dart';

class RecalculateService {
  // Recalcula totalIncome y totalExpense de un proyecto
  // sumando todas sus transacciones y hace update en PocketBase
  Future<void> recalculateProject(String projectId) async {
    final transactions = await TransactionService().getByProject(projectId);
    double income = 0;
    double expense = 0;
    for (final t in transactions) {
      if (t.isIncome) income += t.amount;
      else expense += t.amount;
    }
    await ProjectService().update(projectId, {
      'total_income': income,
      'total_expense': expense,
    });
  }

  // Recalcula el balance de una cuenta partiendo de initial_balance
  // y sumando/restando todas sus transacciones
  Future<void> recalculateAccount(String accountId) async {
    final account = await AccountService().getById(accountId);
    final transactions = await TransactionService().getAll();
    final accountTxns = transactions.where((t) => t.accountId == accountId);
    double balance = account.initialBalance;
    for (final t in accountTxns) {
      if (t.isIncome) balance += t.amount;
      else balance -= t.amount;
    }
    await AccountService().update(accountId, {
      'balance': balance,
    });
  }
}
