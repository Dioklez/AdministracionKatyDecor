import '../core/pocketbase_service.dart';
import '../database/local_repository.dart';
import '../database/app_database.dart';
import '../models/remision_model.dart';

class RemisionService {
  final _pb = PocketBaseService.instance.pb;
  final LocalRepository? _repo;

  RemisionService({LocalRepository? repo}) : _repo = repo;

  Future<List<Remision>> getAll() async {
    try {
      final records = await _pb.collection('remisiones').getFullList(
            sort: '-created',
          );
      final result = records.map(Remision.fromRecord).toList();
      await _repo?.upsertRemisiones(result);
      return result;
    } catch (_) {
      if (_repo != null) {
        final local = await _repo.getRemisiones();
        return local.map(_remisionFromLocal).toList();
      }
      rethrow;
    }
  }

  Future<Remision> create(Map<String, dynamic> data) async {
    try {
      final record = await _pb.collection('remisiones').create(body: data);
      return Remision.fromRecord(record);
    } catch (e) {
      print('RemisionService.create error: $e');
      rethrow;
    }
  }

  Future<Remision> update(String id, Map<String, dynamic> data) async {
    final record =
        await _pb.collection('remisiones').update(id, body: data);
    return Remision.fromRecord(record);
  }

  Future<void> delete(String id) async {
    await _pb.collection('remisiones').delete(id);
  }

  // items no se almacenan en caché local; se retorna lista vacía en offline
  Remision _remisionFromLocal(LocalRemisione row) => Remision(
        id: row.id,
        folio: row.folio,
        projectId: row.projectId,
        supplierId: row.supplierId,
        date: _dateStr(row.date),
        status: row.status ?? 'pendiente',
        subtotal: row.subtotal ?? 0.0,
        tax: row.tax ?? 0.0,
        total: row.total ?? 0.0,
        notes: row.notes,
        items: const [],
        created: row.syncedAt ?? DateTime.now(),
        updated: row.syncedAt ?? DateTime.now(),
      );
}

String? _dateStr(DateTime? d) => d != null
    ? '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}'
    : null;
