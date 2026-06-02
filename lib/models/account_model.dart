import 'package:pocketbase/pocketbase.dart';

class Account {
  final String id;
  final String name;
  final String type;
  final double balance;
  final double initialBalance;
  final String? bankName;
  final String? accountNumber;
  final bool isActive;
  final DateTime created;
  final DateTime updated;

  Account({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.initialBalance,
    this.bankName,
    this.accountNumber,
    required this.isActive,
    required this.created,
    required this.updated,
  });

  factory Account.fromRecord(RecordModel record) {
    return Account(
      id: record.id,
      name: record.getStringValue('name'),
      type: record.getStringValue('type'),
      balance: record.getDoubleValue('balance'),
      initialBalance: record.getDoubleValue('initial_balance'),
      bankName: record.getStringValue('bank_name').isEmpty
          ? null
          : record.getStringValue('bank_name'),
      accountNumber: record.getStringValue('account_number').isEmpty
          ? null
          : record.getStringValue('account_number'),
      isActive: record.getBoolValue('is_active'),
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'balance': balance,
        'bank_name': bankName ?? '',
        'account_number': accountNumber ?? '',
        'is_active': isActive,
      };
}
