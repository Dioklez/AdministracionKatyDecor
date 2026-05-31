import 'package:pocketbase/pocketbase.dart';

class Account {
  final String id;
  final String name;
  final String type;
  final double balance;
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
      balance: (record.getDoubleValue('balance')),
      bankName: record.getStringValue('bankName').isEmpty
          ? null
          : record.getStringValue('bankName'),
      accountNumber: record.getStringValue('accountNumber').isEmpty
          ? null
          : record.getStringValue('accountNumber'),
      isActive: record.getBoolValue('isActive'),
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'balance': balance,
        'bankName': bankName ?? '',
        'accountNumber': accountNumber ?? '',
        'isActive': isActive,
      };
}
