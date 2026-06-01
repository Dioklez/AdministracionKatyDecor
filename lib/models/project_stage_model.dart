import 'package:pocketbase/pocketbase.dart';

class ProjectStage {
  final String id;
  final String projectId;
  final String name;
  final String? description;
  final String status; // 'pendiente' | 'activo' | 'completado'
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
      case 'activo':
        return 'Activo';
      case 'completado':
        return 'Completado';
      default:
        return 'Pendiente';
    }
  }

  factory ProjectStage.fromRecord(RecordModel record) {
    final startDateStr = record.getStringValue('start_date');
    final endDateStr = record.getStringValue('end_date');
    return ProjectStage(
      id: record.id,
      projectId: record.getStringValue('project'),
      name: record.getStringValue('name'),
      description: record.getStringValue('description').isEmpty
          ? null
          : record.getStringValue('description'),
      status: record.getStringValue('status').isEmpty
          ? 'pendiente'
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
      'project': projectId,
      'name': name,
      if (description != null) 'description': description,
      'status': status,
      'order': order,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
    };
  }
}
