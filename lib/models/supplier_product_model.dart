import 'package:pocketbase/pocketbase.dart';

class SupplierProduct {
  final String id;
  final String supplierId;
  final String name;
  final String? description;
  final String? sku;
  final String? unit;
  final double price;
  final bool isActive;
  final DateTime created;
  final DateTime updated;

  const SupplierProduct({
    required this.id,
    required this.supplierId,
    required this.name,
    this.description,
    this.sku,
    this.unit,
    required this.price,
    required this.isActive,
    required this.created,
    required this.updated,
  });

  factory SupplierProduct.fromRecord(RecordModel record) => SupplierProduct(
        id: record.id,
        supplierId: record.getStringValue('supplier'),
        name: record.getStringValue('name'),
        description: record.getStringValue('description').isEmpty
            ? null
            : record.getStringValue('description'),
        sku: record.getStringValue('sku').isEmpty
            ? null
            : record.getStringValue('sku'),
        unit: record.getStringValue('unit').isEmpty
            ? null
            : record.getStringValue('unit'),
        price: record.getDoubleValue('price'),
        isActive: record.getBoolValue('is_active'),
        created: DateTime.parse(record.get<String>('created')),
        updated: DateTime.parse(record.get<String>('updated')),
      );

  Map<String, dynamic> toJson() => {
        'supplier': supplierId,
        'name': name,
        'description': description,
        'sku': sku,
        'unit': unit,
        'price': price,
        'is_active': isActive,
      };
}
