import 'package:pocketbase/pocketbase.dart';

class AccountPayment {
  final String id;
  final String accountId;
  final String? description;
  final double amount;
  final String type; // 'cobro' | 'pago' | 'abono'
  final String? date; // 'YYYY-MM-DD'
  final String? projectId;
  final String status; // 'pendiente' | 'pagado' | 'vencido'
  final String? dueDate; // 'YYYY-MM-DD'
  final String? notes;
  final DateTime created;
  final DateTime updated;

  AccountPayment({
    required this.id,
    required this.accountId,
    this.description,
    required this.amount,
    required this.type,
    this.date,
    this.projectId,
    required this.status,
    this.dueDate,
    this.notes,
    required this.created,
    required this.updated,
  });

  String get typeLabel =>
      const {
        'cobro': 'Cobro',
        'pago': 'Pago',
        'abono': 'Abono',
      }[type] ??
      type;

  String get statusLabel =>
      const {
        'pendiente': 'Pendiente',
        'pagado': 'Pagado',
        'vencido': 'Vencido',
      }[status] ??
      status;

  factory AccountPayment.fromRecord(RecordModel record) {
    final typeVal = record.getStringValue('type');
    final statusVal = record.getStringValue('status');

    return AccountPayment(
      id: record.id,
      accountId: record.getStringValue('accountId'),
      description: record.getStringValue('description').isEmpty
          ? null
          : record.getStringValue('description'),
      amount: record.getDoubleValue('amount'),
      type: typeVal.isEmpty ? 'pago' : typeVal,
      date: record.getStringValue('date').isEmpty
          ? null
          : record.getStringValue('date'),
      projectId: record.getStringValue('projectId').isEmpty
          ? null
          : record.getStringValue('projectId'),
      status: statusVal.isEmpty ? 'pendiente' : statusVal,
      dueDate: record.getStringValue('dueDate').isEmpty
          ? null
          : record.getStringValue('dueDate'),
      notes: record.getStringValue('notes').isEmpty
          ? null
          : record.getStringValue('notes'),
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'description': description ?? '',
        'amount': amount,
        'type': type,
        'date': date ?? '',
        'projectId': projectId ?? '',
        'status': status,
        'dueDate': dueDate ?? '',
        'notes': notes ?? '',
      };
}
