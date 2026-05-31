import 'package:pocketbase/pocketbase.dart';

class Budget {
  final String id;
  final String name;
  final String? projectId;
  final String? period; // e.g. '2026-05'
  final String? startDate; // 'YYYY-MM-DD'
  final String? endDate; // 'YYYY-MM-DD'
  final double plannedAmount;
  final double actualAmount;
  final String? categoryId;
  final String? notes;
  final DateTime created;
  final DateTime updated;

  Budget({
    required this.id,
    required this.name,
    this.projectId,
    this.period,
    this.startDate,
    this.endDate,
    required this.plannedAmount,
    required this.actualAmount,
    this.categoryId,
    this.notes,
    required this.created,
    required this.updated,
  });

  double get remaining => plannedAmount - actualAmount;
  double get pct => plannedAmount > 0
      ? (actualAmount / plannedAmount * 100).clamp(0, 100)
      : 0;

  factory Budget.fromRecord(RecordModel record) {
    return Budget(
      id: record.id,
      name: record.getStringValue('name'),
      projectId: record.getStringValue('projectId').isEmpty
          ? null
          : record.getStringValue('projectId'),
      period: record.getStringValue('period').isEmpty
          ? null
          : record.getStringValue('period'),
      startDate: record.getStringValue('startDate').isEmpty
          ? null
          : record.getStringValue('startDate'),
      endDate: record.getStringValue('endDate').isEmpty
          ? null
          : record.getStringValue('endDate'),
      plannedAmount: record.getDoubleValue('plannedAmount'),
      actualAmount: record.getDoubleValue('actualAmount'),
      categoryId: record.getStringValue('categoryId').isEmpty
          ? null
          : record.getStringValue('categoryId'),
      notes: record.getStringValue('notes').isEmpty
          ? null
          : record.getStringValue('notes'),
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'projectId': projectId ?? '',
        'period': period ?? '',
        'startDate': startDate ?? '',
        'endDate': endDate ?? '',
        'plannedAmount': plannedAmount,
        'actualAmount': actualAmount,
        'categoryId': categoryId ?? '',
        'notes': notes ?? '',
      };
}
