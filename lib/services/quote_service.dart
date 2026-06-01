import '../core/pocketbase_service.dart';
import '../models/quote_model.dart';

class QuoteService {
  final _pb = PocketBaseService.instance.pb;

  Future<List<Quote>> getAll() async {
    final records = await _pb.collection('quotes').getFullList(
          sort: '-created',
        );
    return records.map(Quote.fromRecord).toList();
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
}
