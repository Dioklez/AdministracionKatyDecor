import 'package:pocketbase/pocketbase.dart';

class InventoryItem {
  final String id;
  final String name;
  final String? description;
  final String? unit;
  final double currentStock;
  final double? minStock;
  final String? supplierProductId;
  final String? location;
  final String? notes;
  final DateTime created;
  final DateTime updated;

  const InventoryItem({
    required this.id,
    required this.name,
    this.description,
    this.unit,
    required this.currentStock,
    this.minStock,
    this.supplierProductId,
    this.location,
    this.notes,
    required this.created,
    required this.updated,
  });

  bool get isBajoStock => minStock != null && currentStock <= minStock!;

  factory InventoryItem.fromRecord(RecordModel record) => InventoryItem(
        id: record.id,
        name: record.getStringValue('name'),
        description: record.getStringValue('description').isEmpty
            ? null
            : record.getStringValue('description'),
        unit: record.getStringValue('unit').isEmpty
            ? null
            : record.getStringValue('unit'),
        currentStock: record.getDoubleValue('currentStock'),
        minStock: record.getStringValue('minStock').isEmpty
            ? null
            : record.getDoubleValue('minStock'),
        supplierProductId: record.getStringValue('supplierProductId').isEmpty
            ? null
            : record.getStringValue('supplierProductId'),
        location: record.getStringValue('location').isEmpty
            ? null
            : record.getStringValue('location'),
        notes: record.getStringValue('notes').isEmpty
            ? null
            : record.getStringValue('notes'),
        created: DateTime.parse(record.get<String>('created')),
        updated: DateTime.parse(record.get<String>('updated')),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'unit': unit,
        'currentStock': currentStock,
        'minStock': minStock,
        'supplierProductId': supplierProductId,
        'location': location,
        'notes': notes,
      };
}
