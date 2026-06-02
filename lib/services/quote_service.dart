import 'dart:convert';
import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/quote_model.dart';

class QuoteService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  QuoteService({LocalRepository? repo}) : _repo = repo;

  Future<List<Quote>> getAll() async {
    try {
      final records = await _pb.collection('quotes').getFullList(
            sort: '-created',
          );
      final result = records.map(Quote.fromRecord).toList();
      await _repo?.upsertQuotes(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getQuotes();
        return local.map(_quoteFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<Quote> create(Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('quotes').create(body: data);
      return Quote.fromRecord(record);
    } catch (e) {
      print('QuoteService.create error: $e');
      rethrow;
    }
  }

  Future<Quote> update(String id, Map<String, dynamic> data) async {
    final record = await _pb.collection('quotes').update(id, body: data);
    return Quote.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('quotes').delete(id);
  }

  Quote _quoteFromLocal(LocalQuote row) {
    List<Map<String, dynamic>> items = [];
    try {
      final decoded = jsonDecode(row.items ?? '[]');
      if (decoded is List) {
        items = decoded
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    } catch (_) {}

    return Quote(
      id: row.id,
      folio: row.folio,
      projectId: row.projectId,
      clientName: row.clientName,
      clientPhone: row.clientPhone,
      date: _dateStr(row.date),
      validUntil: _dateStr(row.validUntil),
      status: row.status ?? 'borrador',
      subtotal: row.subtotal ?? 0.0,
      tax: row.tax ?? 0.0,
      total: row.total ?? 0.0,
      notes: row.notes,
      items: items,
      created: row.syncedAt ?? DateTime.now(),
      updated: row.syncedAt ?? DateTime.now(),
    );
  }
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
