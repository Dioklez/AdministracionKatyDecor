import 'package:pocketbase/pocketbase.dart';

class FacturaEmitida {
  final String id;
  final String? folio;
  final String? projectId;
  final String? clientName;
  final String? clientRfc;
  final String? date; // 'YYYY-MM-DD'
  final String status; // 'pendiente' | 'pagada' | 'cancelada'
  final double subtotal;
  final double tax;
  final double total;
  final String? notes;
  final List<Map<String, dynamic>> items;
  final DateTime created;
  final DateTime updated;

  FacturaEmitida({
    required this.id,
    this.folio,
    this.projectId,
    this.clientName,
    this.clientRfc,
    this.date,
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
        'pendiente': 'Pendiente',
        'pagada': 'Pagada',
        'cancelada': 'Cancelada',
      }[status] ??
      status;

  factory FacturaEmitida.fromRecord(RecordModel record) {
    final statusVal = record.getStringValue('status');
    final rawItems = record.get<List?>('items') ?? [];
    final items = rawItems
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    return FacturaEmitida(
      id: record.id,
      folio: record.getStringValue('folio').isEmpty
          ? null
          : record.getStringValue('folio'),
      projectId: record.getStringValue('projectId').isEmpty
          ? null
          : record.getStringValue('projectId'),
      clientName: record.getStringValue('clientName').isEmpty
          ? null
          : record.getStringValue('clientName'),
      clientRfc: record.getStringValue('clientRfc').isEmpty
          ? null
          : record.getStringValue('clientRfc'),
      date: record.getStringValue('date').isEmpty
          ? null
          : record.getStringValue('date'),
      status: statusVal.isEmpty ? 'pendiente' : statusVal,
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
        'projectId': projectId ?? '',
        'clientName': clientName ?? '',
        'clientRfc': clientRfc ?? '',
        'date': date ?? '',
        'status': status,
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'notes': notes ?? '',
        'items': items,
      };
}
