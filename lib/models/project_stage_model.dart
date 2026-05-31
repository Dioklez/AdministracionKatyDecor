import 'package:pocketbase/pocketbase.dart';

class ProjectStage {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String status; // 'pending' | 'active' | 'completed'
  final int order;
  final String? startDate;
  final String? endDate;
  final DateTime created;
  final DateTime updated;

  ProjectStage({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    required this.status,
    required this.order,
    this.startDate,
    this.endDate,
    required this.created,
    required this.updated,
  });

  String get statusLabel {
    switch (status) {
      case 'active':
        return 'Activo';
      case 'completed':
        return 'Completado';
      default:
        return 'Pendiente';
    }
  }

  factory ProjectStage.fromRecord(RecordModel record) {
    final startDateStr = record.getStringValue('startDate');
    final endDateStr = record.getStringValue('endDate');
    return ProjectStage(
      id: record.id,
      projectId: record.getStringValue('projectId'),
      name: record.getStringValue('name'),
      description: record.getStringValue('description').isEmpty
          ? null
          : record.getStringValue('description'),
      status: record.getStringValue('status').isEmpty
          ? 'pending'
          : record.getStringValue('status'),
      order: record.getIntValue('order'),
      startDate: startDateStr.isEmpty ? null : startDateStr,
      endDate: endDateStr.isEmpty ? null : endDateStr,
      created:
          DateTime.tryParse(record.get<String>('created')) ?? DateTime.now(),
      updated:
          DateTime.tryParse(record.get<String>('updated')) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectId': projectId,
      'name': name,
      if (description != null) 'description': description,
      'status': status,
      'order': order,
      if (startDate != null) 'startDate': startDate,
      if (endDate != null) 'endDate': endDate,
    };
  }
}
