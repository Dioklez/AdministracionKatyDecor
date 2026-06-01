import 'package:pocketbase/pocketbase.dart';

class Quote {
  final String id;
  final String? folio;
  final String? projectId;
  final String? clientName;
  final String? clientPhone;
  final String? date; // 'YYYY-MM-DD'
  final String? validUntil; // 'YYYY-MM-DD'
  final String status; // 'borrador' | 'enviada' | 'aprobada' | 'rechazada' | 'cancelada'
  final double subtotal;
  final double tax;
  final double total;
  final String? notes;
  final List<Map<String, dynamic>> items;
  final DateTime created;
  final DateTime updated;

  Quote({
    required this.id,
    this.folio,
    this.projectId,
    this.clientName,
    this.clientPhone,
    this.date,
    this.validUntil,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.notes,
    required this.items,
    required this.created,
    required this.updated,
  });

  String get statusLabel =>
      const {
        'borrador': 'Borrador',
        'enviada': 'Enviada',
        'aprobada': 'Aprobada',
        'rechazada': 'Rechazada',
        'cancelada': 'Cancelada',
      }[status] ??
      status;

  factory Quote.fromRecord(RecordModel record) {
    final statusVal = record.getStringValue('status');
    final rawItems = record.get<List?>('items') ?? [];
    final items = rawItems
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return Quote(
      id: record.id,
      folio: record.getStringValue('folio').isEmpty
          ? null
          : record.getStringValue('folio'),
      projectId: record.getStringValue('project').isEmpty
          ? null
          : record.getStringValue('project'),
      clientName: record.getStringValue('client_name').isEmpty
          ? null
          : record.getStringValue('client_name'),
      clientPhone: record.getStringValue('client_phone').isEmpty
          ? null
          : record.getStringValue('client_phone'),
      date: record.getStringValue('date').isEmpty
          ? null
          : record.getStringValue('date'),
      validUntil: record.getStringValue('valid_until').isEmpty
          ? null
          : record.getStringValue('valid_until'),
      status: statusVal.isEmpty ? 'borrador' : statusVal,
      subtotal: record.getDoubleValue('subtotal'),
      tax: record.getDoubleValue('tax'),
      total: record.getDoubleValue('total'),
      notes: record.getStringValue('notes').isEmpty
          ? null
          : record.getStringValue('notes'),
      items: items,
      created: DateTime.parse(record.get<String>('created')),
      updated: DateTime.parse(record.get<String>('updated')),
    );
  }

  Map<String, dynamic> toJson() => {
        'folio': folio ?? '',
        'project': projectId ?? '',
        'client_name': clientName ?? '',
        'client_phone': clientPhone ?? '',
        'date': date ?? '',
        'valid_until': validUntil ?? '',
        'status': status,
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'notes': notes ?? '',
        'items': items,
      };
}
