import 'package:pocketbase/pocketbase.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final String? projectId;
  final String? stageId;
  final String status;   // 'pendiente' | 'en_progreso' | 'completado' | 'cancelado'
  final String priority; // 'baja' | 'media' | 'alta'
  final String? dueDate; // 'YYYY-MM-DD'
  final String? completedAt;
  final String? notes;
  final DateTime created;
  final DateTime updated;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.projectId,
    this.stageId,
    required this.status,
    required this.priority,
    this.dueDate,
    this.completedAt,
    this.notes,
    required this.created,
    required this.updated,
  });

  bool get isCompleted => status == 'completado';

  String get priorityLabel {
    switch (priority) {
      case 'alta':
        return 'Alta';
      case 'baja':
        return 'Baja';
      default:
        return 'Media';
    }
  }

  factory Task.fromRecord(RecordModel record) {
    final dueDateStr = record.getStringValue('due_date');
    final completedAtStr = record.getStringValue('completed_at');
    final statusVal = record.getStringValue('status');
    final priorityVal = record.getStringValue('priority');
    return Task(
      id: record.id,
      title: record.getStringValue('title'),
      description: record.getStringValue('description').isEmpty
          ? null
          : record.getStringValue('description'),
      projectId: record.getStringValue('project').isEmpty
          ? null
          : record.getStringValue('project'),
      stageId: record.getStringValue('stage').isEmpty
          ? null
          : record.getStringValue('stage'),
      status: statusVal.isEmpty ? 'pendiente' : statusVal,
      priority: priorityVal.isEmpty ? 'media' : priorityVal,
      dueDate: dueDateStr.isEmpty ? null : dueDateStr,
      completedAt: completedAtStr.isEmpty ? null : completedAtStr,
      notes: record.getStringValue('notes').isEmpty
          ? null
          : record.getStringValue('notes'),
      created:
          DateTime.tryParse(record.get<String>('created')) ?? DateTime.now(),
      updated:
          DateTime.tryParse(record.get<String>('updated')) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      if (projectId != null) 'project': projectId,
      if (stageId != null) 'stage': stageId,
      'status': status,
      'priority': priority,
      if (dueDate != null) 'due_date': dueDate,
      if (notes != null) 'notes': notes,
    };
  }
}
