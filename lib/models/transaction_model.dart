import 'package:pocketbase/pocketbase.dart';

class Transaction {
  final String id;
  final String description;
  final double amount;
  final String type; // 'income' | 'expense'
  final String date; // 'YYYY-MM-DD'
  final String? projectId;
  final String? categoryId;
  final String? accountId;
  final String? notes;
  final DateTime created;
  final DateTime updated;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.type,
    required this.date,
    this.projectId,
    this.categoryId,
    this.accountId,
    this.notes,
    required this.created,
    required this.updated,
  });

  bool get isIncome => type == 'income';

  factory Transaction.fromRecord(RecordModel record) {
    final typeVal = record.getStringValue('type');
    return Transaction(
      id: record.id,
      description: record.getStringValue('description'),
      amount: record.getDoubleValue('amount'),
      type: typeVal.isEmpty ? 'expense' : typeVal,
      date: record.getStringValue('date'),
      projectId: record.getStringValue('projectId').isEmpty
          ? null
          : record.getStringValue('projectId'),
      categoryId: record.getStringValue('categoryId').isEmpty
          ? null
          : record.getStringValue('categoryId'),
      accountId: record.getStringValue('accountId').isEmpty
          ? null
          : record.getStringValue('accountId'),
      notes: record.getStringValue('notes').isEmpty
          ? null
          : record.getStringValue('notes'),
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'description': description,
        'amount': amount,
        'type': type,
        'date': date,
        'projectId': projectId ?? '',
        'categoryId': categoryId ?? '',
        'accountId': accountId ?? '',
        'notes': notes ?? '',
      };
}
