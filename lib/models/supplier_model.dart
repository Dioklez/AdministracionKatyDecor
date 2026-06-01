import 'package:pocketbase/pocketbase.dart';

class Supplier {
  final String id;
  final String name;
  final String? contactName;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isActive;
  final DateTime created;
  final DateTime updated;

  Supplier({
    required this.id,
    required this.name,
    this.contactName,
    this.phone,
    this.email,
    this.address,
    this.notes,
    required this.isActive,
    required this.created,
    required this.updated,
  });

  factory Supplier.fromRecord(RecordModel record) {
    return Supplier(
      id: record.id,
      name: record.getStringValue('name'),
      contactName: record.getStringValue('contact_name').isEmpty
          ? null
          : record.getStringValue('contact_name'),
      phone: record.getStringValue('phone').isEmpty
          ? null
          : record.getStringValue('phone'),
      email: record.getStringValue('email').isEmpty
          ? null
          : record.getStringValue('email'),
      address: record.getStringValue('address').isEmpty
          ? null
          : record.getStringValue('address'),
      notes: record.getStringValue('notes').isEmpty
          ? null
          : record.getStringValue('notes'),
      isActive: record.getBoolValue('is_active'),
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'contact_name': contactName ?? '',
        'phone': phone ?? '',
        'email': email ?? '',
        'address': address ?? '',
        'notes': notes ?? '',
        'is_active': isActive,
      };
}
