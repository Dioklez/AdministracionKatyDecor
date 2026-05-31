import 'package:pocketbase/pocketbase.dart';

class InventoryMovement {
  final String id;
  final String inventoryItemId;
  final String type; // 'entrada' | 'salida' | 'ajuste'
  final double quantity;
  final String? date; // 'YYYY-MM-DD'
  final String? projectId;
  final String? notes;
  final DateTime created;
  final DateTime updated;

  const InventoryMovement({
    required this.id,
    required this.inventoryItemId,
    required this.type,
    required this.quantity,
    this.date,
    this.projectId,
    this.notes,
    required this.created,
    required this.updated,
  });

  factory InventoryMovement.fromRecord(RecordModel record) => InventoryMovement(
        id: record.id,
        inventoryItemId: record.getStringValue('inventoryItemId'),
        type: record.getStringValue('type').isEmpty
            ? 'entrada'
            : record.getStringValue('type'),
        quantity: record.getDoubleValue('quantity'),
        date: record.getStringValue('date').isEmpty
            ? null
            : record.getStringValue('date'),
        projectId: record.getStringValue('projectId').isEmpty
            ? null
            : record.getStringValue('projectId'),
        notes: record.getStringValue('notes').isEmpty
            ? null
            : record.getStringValue('notes'),
        created: DateTime.parse(record.get<String>('created')),
        updated: DateTime.parse(record.get<String>('updated')),
      );

  Map<String, dynamic> toJson() => {
        'inventoryItemId': inventoryItemId,
        'type': type,
        'quantity': quantity,
        'date': date,
        'projectId': projectId,
        'notes': notes,
      };
}
