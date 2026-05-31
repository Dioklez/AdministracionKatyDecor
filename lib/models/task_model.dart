import 'package:pocketbase/pocketbase.dart';

class Task {
  final String id;
  final String title;
  final String? description;
  final String? projectId;
  final String? stageId;
  final String status;   // 'pending' | 'in_progress' | 'completed'
  final String priority; // 'low' | 'medium' | 'high'
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

  bool get isCompleted => status == 'completed';

  String get priorityLabel {
    switch (priority) {
      case 'high':
        return 'Alta';
      case 'low':
        return 'Baja';
      default:
        return 'Media';
    }
  }

  factory Task.fromRecord(RecordModel record) {
    final dueDateStr = record.getStringValue('dueDate');
    final completedAtStr = record.getStringValue('completedAt');
    final statusVal = record.getStringValue('status');
    final priorityVal = record.getStringValue('priority');
    return Task(
      id: record.id,
      title: record.getStringValue('title'),
      description: record.getStringValue('description').isEmpty
          ? null
          : record.getStringValue('description'),
      projectId: record.getStringValue('projectId').isEmpty
          ? null
          : record.getStringValue('projectId'),
      stageId: record.getStringValue('stageId').isEmpty
          ? null
          : record.getStringValue('stageId'),
      status: statusVal.isEmpty ? 'pending' : statusVal,
      priority: priorityVal.isEmpty ? 'medium' : priorityVal,
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
      if (projectId != null) 'projectId': projectId,
      if (stageId != null) 'stageId': stageId,
      'status': status,
      'priority': priority,
      if (dueDate != null) 'dueDate': dueDate,
      if (notes != null) 'notes': notes,
    };
  }
}
