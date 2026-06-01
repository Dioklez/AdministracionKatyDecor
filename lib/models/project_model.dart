import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../theme/app_theme.dart';

class Project {
  final String id;
  final String name;
  final String clientName;
  final String? clientPhone;
  final String? description;
  final String status;
  final String? startDate;
  final String? endDate;
  final double? budget;
  final double totalIncome;
  final double totalExpense;
  final String? notes;
  final String? color;
  final DateTime created;
  final DateTime updated;

  Project({
    required this.id,
    required this.name,
    required this.clientName,
    this.clientPhone,
    this.description,
    required this.status,
    this.startDate,
    this.endDate,
    this.budget,
    required this.totalIncome,
    required this.totalExpense,
    this.notes,
    this.color,
    required this.created,
    required this.updated,
  });

  double get balance => totalIncome - totalExpense;

  String get statusLabel {
    switch (status) {
      case 'activo':
        return 'Activo';
      case 'pausado':
        return 'Pausado';
      case 'completado':
        return 'Completado';
      case 'cancelado':
        return 'Cancelado';
      default:
        return status;
    }
  }

  Color get displayColor {
    if (color != null && color!.startsWith('#') && color!.length == 7) {
      try {
        return Color(int.parse('FF${color!.substring(1)}', radix: 16));
      } catch (_) {}
    }
    return AppTheme.colorPrimario;
  }

  factory Project.fromRecord(RecordModel record) {
    final budgetVal = record.getDoubleValue('budget');
    final startDateStr = record.getStringValue('start_date');
    final endDateStr = record.getStringValue('end_date');
    return Project(
      id: record.id,
      name: record.getStringValue('name'),
      clientName: record.getStringValue('client_name'),
      clientPhone: record.getStringValue('client_phone').isEmpty
          ? null
          : record.getStringValue('client_phone'),
      description: record.getStringValue('description').isEmpty
          ? null
          : record.getStringValue('description'),
      status: record.getStringValue('status').isEmpty
          ? 'activo'
          : record.getStringValue('status'),
      startDate: startDateStr.isEmpty ? null : startDateStr,
      endDate: endDateStr.isEmpty ? null : endDateStr,
      budget: budgetVal == 0.0 ? null : budgetVal,
      totalIncome: record.getDoubleValue('total_income'),
      totalExpense: record.getDoubleValue('total_expense'),
      notes: record.getStringValue('notes').isEmpty
          ? null
          : record.getStringValue('notes'),
      color: record.getStringValue('color').isEmpty
          ? null
          : record.getStringValue('color'),
      created:
          DateTime.tryParse(record.get<String>('created')) ?? DateTime.now(),
      updated:
          DateTime.tryParse(record.get<String>('updated')) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'client_name': clientName,
      if (clientPhone != null) 'client_phone': clientPhone,
      if (description != null) 'description': description,
      'status': status,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (budget != null) 'budget': budget,
      if (notes != null) 'notes': notes,
      if (color != null) 'color': color,
    };
  }
}
