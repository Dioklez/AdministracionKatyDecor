import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../database/local_repository.dart';
import '../../widgets/sync_toast.dart';
import '../../models/inventory_item.dart';
import '../../models/inventory_movement.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<InventoryItem> _items = [];
  bool _loadingList = true;
  String? _listError;

  int? _selectedId;
  InventoryItem? _selectedItem;
  List<InventoryMovement> _movements = [];
  bool _loadingDetail = false;

  String _tipoFilter = 'all'; // 'all' | 'venta' | 'material'
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadItems({String q = ''}) async {
    setState(() {
      _loadingList = true;
      _listError = null;
    });
    try {
      final api = context.read<ApiService>();
      String endpoint = '/api/mobile/inventory';
      final params = <String>[];
      if (_tipoFilter != 'all') params.add('tipo=$_tipoFilter');
      if (q.isNotEmpty) params.add('q=${Uri.encodeQueryComponent(q)}');
      if (params.isNotEmpty) endpoint += '?${params.join('&')}';
      final result = await api.get(endpoint);
      if (!mounted) return;
      final items = (result as List<dynamic>? ?? [])
          .map((e) => InventoryItem.fromJson(e as Map<String, dynamic>))
          .toList();
      // Guardar en local (fire-and-forget, solo sin filtros)
      if (_tipoFilter == 'all' && q.isEmpty) {
        context.read<LocalRepository>().upsertInventoryItems(items);
      }
      setState(() {
        _items = items;
        _loadingList = false;
        if (_selectedId != null) {
          _selectedItem = _items.where((i) => i.id == _selectedId).firstOrNull;
        }
      });
    } on ApiOfflineException {
      await _loadItemsFromLocal(q);
    } catch (e) {
      await _loadItemsFromLocal(q);
    }
  }

  Future<void> _loadItemsFromLocal(String q) async {
    try {
      final repo = context.read<LocalRepository>();
      final items = await repo.getInventoryFiltered(
        tipo: _tipoFilter == 'all' ? null : _tipoFilter,
        query: q.isEmpty ? null : q,
      );
      if (mounted) {
        setState(() {
          _items = items;
          _loadingList = false;
          if (_selectedId != null) {
            _selectedItem = _items.where((i) => i.id == _selectedId).firstOrNull;
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _listError = 'Sin datos disponibles.';
          _loadingList = false;
        });
      }
    }
  }

  Future<void> _selectItem(int id) async {
    setState(() {
      _selectedId = id;
      _loadingDetail = true;
      _selectedItem = _items.where((i) => i.id == id).firstOrNull;
      _movements = [];
    });
    try {
      final api = context.read<ApiService>();
      final results = await Future.wait([
        api.get('/api/mobile/inventory/$id'),
        api.get('/api/mobile/inventory/$id/movements'),
      ]);
      if (!mounted) return;
      final item = InventoryItem.fromJson(results[0] as Map<String, dynamic>);
      final movements = (results[1] as List<dynamic>? ?? [])
          .map((e) => InventoryMovement.fromJson(e as Map<String, dynamic>))
          .toList();
      // Guardar en local (fire-and-forget)
      final repo = context.read<LocalRepository>();
      repo.upsertInventoryItem(item);
      repo.upsertMovements(movements);
      setState(() {
        _selectedItem = item;
        _movements = movements;
        _loadingDetail = false;
      });
    } on ApiOfflineException {
      await _loadItemDetailFromLocal(id);
    } catch (e) {
      await _loadItemDetailFromLocal(id);
    }
  }

  Future<void> _loadItemDetailFromLocal(int id) async {
    try {
      final repo = context.read<LocalRepository>();
      final item = await repo.getInventoryItemById(id);
      final movements = await repo.getMovementsByItemId(id);
      if (mounted) {
        setState(() {
          if (item != null) _selectedItem = item;
          _movements = movements;
          _loadingDetail = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorFondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
            child: Row(
              children: [
                Text(
                  'Inventario',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showItemDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nuevo item'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 340, child: _buildLeftPanel()),
                const VerticalDivider(width: 1),
                Expanded(child: _buildRightPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Panel izquierdo ───────────────────────────────────────────────────────

  Widget _buildLeftPanel() {
    return Column(
      children: [
        // Búsqueda
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar item...',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        _loadItems();
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => _loadItems(q: v),
          ),
        ),
        // Filtro tipo
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: Row(
            children: [
              _FilterChip(
                label: 'Todos',
                selected: _tipoFilter == 'all',
                onTap: () {
                  setState(() => _tipoFilter = 'all');
                  _loadItems(q: _searchController.text);
                },
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: 'Venta',
                selected: _tipoFilter == 'venta',
                color: AppTheme.colorPrimario,
                onTap: () {
                  setState(() => _tipoFilter = 'venta');
                  _loadItems(q: _searchController.text);
                },
              ),
              const SizedBox(width: 6),
              _FilterChip(
                label: 'Material',
                selected: _tipoFilter == 'material',
                color: AppTheme.colorTextoSecundario,
                onTap: () {
                  setState(() => _tipoFilter = 'material');
                  _loadItems(q: _searchController.text);
                },
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _loadingList
              ? _buildListShimmer()
              : _listError != null
                  ? Center(
                      child: Text(_listError!,
                          style: GoogleFonts.inter(
                              color: AppTheme.colorTextoSecundario)))
                  : _items.isEmpty
                      ? EmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: 'Sin items',
                          subtitle: 'Agrega el primer item al inventario',
                          actionLabel: 'Nuevo item',
                          onAction: _showItemDialog,
                        )
                      : ListView.builder(
                          itemCount: _items.length,
                          itemBuilder: (ctx, i) => _ItemTile(
                            item: _items[i],
                            selected: _selectedId == _items[i].id,
                            onTap: () => _selectItem(_items[i].id),
                            onEdit: () =>
                                _showItemDialog(editItem: _items[i]),
                            onDelete: () => _confirmDelete(_items[i]),
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, i) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ShimmerBox(width: 160, height: 13),
          SizedBox(height: 6),
          ShimmerBox(width: 100, height: 11),
        ]),
      ),
    );
  }

  // ── Panel derecho ─────────────────────────────────────────────────────────

  Widget _buildRightPanel() {
    if (_selectedId == null) {
      return const EmptyState(
        icon: Icons.inventory_2_outlined,
        title: 'Selecciona un item',
        subtitle: 'Haz clic en un item para ver su detalle y movimientos',
      );
    }
    final item = _selectedItem;
    if (item == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildItemHeader(item),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Historial de movimientos',
            actionLabel: null,
            onAction: null,
          ),
          // Botones de acción
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      _showMovementDialog(item, tipo: 'entrada'),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Entrada'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.colorExito),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: item.stockActual > 0
                      ? () => _showMovementDialog(item, tipo: 'salida')
                      : null,
                  icon: const Icon(Icons.remove, size: 16),
                  label: const Text('Salida'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.colorError),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () =>
                      _showMovementDialog(item, tipo: 'ajuste'),
                  icon: const Icon(Icons.tune, size: 16),
                  label: const Text('Ajuste'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.colorAdvertencia),
                ),
              ],
            ),
          ),
          _loadingDetail
              ? const ShimmerBox(height: 120)
              : _movements.isEmpty
                  ? const EmptyState(
                      icon: Icons.swap_vert_outlined,
                      title: 'Sin movimientos',
                      subtitle: 'Registra el primer movimiento',
                    )
                  : _buildMovementsTable(),
        ],
      ),
    );
  }

  Widget _buildItemHeader(InventoryItem item) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nombre,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.colorTexto,
                      ),
                    ),
                    if (item.codigo != null) ...[
                      const SizedBox(height: 2),
                      Text('Código: ${item.codigo}',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.colorTextoSecundario)),
                    ],
                  ],
                ),
              ),
              if (item.isBajoStock)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.colorError.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 12, color: AppTheme.colorError),
                      const SizedBox(width: 4),
                      Text('Stock bajo',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.colorError)),
                    ],
                  ),
                ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    size: 18, color: AppTheme.colorTextoSecundario),
                onSelected: (v) {
                  if (v == 'edit') _showItemDialog(editItem: item);
                  if (v == 'delete') _confirmDelete(item);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatCell(
                label: 'Stock actual',
                value:
                    '${item.stockActual.toStringAsFixed(item.stockActual == item.stockActual.roundToDouble() ? 0 : 2)} ${item.unidad}',
                color: item.isBajoStock
                    ? AppTheme.colorError
                    : AppTheme.colorTexto,
              ),
              const SizedBox(width: 24),
              _StatCell(
                label: 'Stock mínimo',
                value: item.stockMinimo != null
                    ? '${item.stockMinimo!.toStringAsFixed(0)} ${item.unidad}'
                    : '—',
                color: AppTheme.colorTextoSecundario,
              ),
              const SizedBox(width: 24),
              _StatCell(
                label: 'Precio unitario',
                value: '\$${item.precioUnitario.toStringAsFixed(2)}',
                color: AppTheme.colorTexto,
              ),
              const SizedBox(width: 24),
              _StatCell(
                label: 'Valor total',
                value: '\$${item.valorTotal.toStringAsFixed(2)}',
                color: AppTheme.colorPrimario,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMovementsTable() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text('Fecha',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Tipo',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Cantidad',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Referencia',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
              ],
            ),
          ),
          ..._movements.map((m) => _MovementRow(movement: m)),
        ],
      ),
    );
  }

  // ── Diálogos ──────────────────────────────────────────────────────────────

  void _showItemDialog({InventoryItem? editItem}) {
    showDialog(
      context: context,
      builder: (ctx) => _NewItemDialog(
        editItem: editItem,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadItems(q: _searchController.text).then((_) {
            final id = editItem?.id ?? _selectedId;
            if (id != null) _selectItem(id);
          });
        },
      ),
    );
  }

  void _showMovementDialog(InventoryItem item, {required String tipo}) {
    showDialog(
      context: context,
      builder: (ctx) => _NewMovementDialog(
        item: item,
        initialTipo: tipo,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadItems(q: _searchController.text)
              .then((_) => _selectItem(item.id));
        },
      ),
    );
  }

  Future<void> _confirmDelete(InventoryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${item.nombre}"?',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(
            'El item quedará inactivo y no aparecerá en el inventario.',
            style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await context
            .read<ApiService>()
            .delete('/api/mobile/inventory/${item.id}');
        setState(() {
          if (_selectedId == item.id) {
            _selectedId = null;
            _selectedItem = null;
            _movements = [];
          }
        });
        _loadItems(q: _searchController.text);
      } on ApiOfflineException {
        final repo = context.read<LocalRepository>();
        await repo.addPendingOp(
          entityType: 'inventory_item',
          operation: 'delete',
          entityId: item.id,
          endpoint: '/api/mobile/inventory/${item.id}',
        );
        repo.deleteInventoryItem(item.id);
        setState(() {
          _items.removeWhere((x) => x.id == item.id);
          if (_selectedId == item.id) {
            _selectedId = null;
            _selectedItem = null;
            _movements = [];
          }
        });
        SyncToast.show(context, 'Eliminado localmente. Se sincronizará al reconectar.');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el item.')),
          );
        }
      }
    }
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.colorPrimario;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? c.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppTheme.colorBorde,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? c : AppTheme.colorTextoSecundario,
          ),
        ),
      ),
    );
  }
}

// ── Tile de item ──────────────────────────────────────────────────────────────

class _ItemTile extends StatefulWidget {
  final InventoryItem item;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ItemTile({
    required this.item,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<_ItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppTheme.colorPrimario.withAlpha(20)
                : _hovered
                    ? AppTheme.colorHover
                    : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: widget.selected
                    ? AppTheme.colorPrimario
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.nombre,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.selected
                                  ? AppTheme.colorPrimario
                                  : AppTheme.colorTexto,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isBajoStock)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.colorError.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Stock bajo',
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.colorError)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Text(
                          'Stock: ${item.stockActual.toStringAsFixed(item.stockActual == item.stockActual.roundToDouble() ? 0 : 2)} ${item.unidad}',
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: item.isBajoStock
                                  ? AppTheme.colorError
                                  : AppTheme.colorTextoSecundario),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppTheme.colorBorde,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.tipo == 'venta' ? 'Venta' : 'Material',
                            style: GoogleFonts.inter(
                                fontSize: 9,
                                color: AppTheme.colorTextoSecundario),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    size: 16, color: AppTheme.colorTextoSecundario),
                onSelected: (v) {
                  if (v == 'edit') widget.onEdit();
                  if (v == 'delete') widget.onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Fila de movimiento ────────────────────────────────────────────────────────

class _MovementRow extends StatelessWidget {
  final InventoryMovement movement;

  const _MovementRow({required this.movement});

  String _formatDate(String? iso) {
    if (iso == null || iso.length < 10) return '—';
    final parts = iso.substring(0, 10).split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return iso;
  }

  Color _tipoColor(String tipo) {
    switch (tipo) {
      case 'entrada':
        return AppTheme.colorExito;
      case 'salida':
        return AppTheme.colorError;
      default:
        return AppTheme.colorAdvertencia;
    }
  }

  String _tipoLabel(String tipo) {
    switch (tipo) {
      case 'entrada':
        return 'Entrada';
      case 'salida':
        return 'Salida';
      default:
        return 'Ajuste';
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = movement;
    final color = _tipoColor(m.tipo);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(_formatDate(m.fecha),
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario)),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(_tipoLabel(m.tipo),
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${m.tipo == 'salida' ? '-' : '+'}${m.cantidad.toStringAsFixed(m.cantidad == m.cantidad.roundToDouble() ? 0 : 2)}',
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(m.referencia ?? '—',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppTheme.colorTextoSecundario),
                  overflow: TextOverflow.ellipsis),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat cell ─────────────────────────────────────────────────────────────────

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCell(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 11, color: AppTheme.colorTextoSecundario)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 15, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

// ── Dialog: Nuevo / Editar item ───────────────────────────────────────────────

class _NewItemDialog extends StatefulWidget {
  final VoidCallback onSaved;
  final InventoryItem? editItem;

  const _NewItemDialog({required this.onSaved, this.editItem});

  @override
  State<_NewItemDialog> createState() => _NewItemDialogState();
}

class _NewItemDialogState extends State<_NewItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _codigoController = TextEditingController();
  final _stockController = TextEditingController();
  final _stockMinimoController = TextEditingController();
  final _precioController = TextEditingController();
  final _notasController = TextEditingController();
  String _tipo = 'venta';
  String _unidad = 'pieza';
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editItem != null;

  static const _unidades = [
    'pieza', 'metro', 'metro cuadrado', 'kg', 'gramo', 'litro', 'ml',
    'par', 'caja', 'rollo', 'otro',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.editItem;
    if (item != null) {
      _nombreController.text = item.nombre;
      _codigoController.text = item.codigo ?? '';
      _stockMinimoController.text = item.stockMinimo?.toStringAsFixed(0) ?? '';
      _precioController.text = item.precioUnitario.toStringAsFixed(2);
      _notasController.text = item.notas ?? '';
      _tipo = item.tipo;
      _unidad = _unidades.contains(item.unidad) ? item.unidad : 'pieza';
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoController.dispose();
    _stockController.dispose();
    _stockMinimoController.dispose();
    _precioController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final stockMin = double.tryParse(_stockMinimoController.text);
    final body = <String, dynamic>{
      'nombre': _nombreController.text.trim(),
      'tipo': _tipo,
      'unidad': _unidad,
      'precio_unitario': double.parse(_precioController.text),
      'stock_minimo': stockMin,
      if (_codigoController.text.isNotEmpty)
        'codigo': _codigoController.text.trim(),
      if (_notasController.text.isNotEmpty)
        'notas': _notasController.text.trim(),
    };
    try {
      final api = context.read<ApiService>();
      if (_isEditing) {
        await api.put('/api/mobile/inventory/${widget.editItem!.id}', body);
      } else {
        body['stock_actual'] =
            double.tryParse(_stockController.text) ?? 0.0;
        await api.post('/api/mobile/inventory', body);
      }
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      if (!mounted) return;
      final repo = context.read<LocalRepository>();
      final precio = double.parse(_precioController.text);
      final stockMin = double.tryParse(_stockMinimoController.text);
      if (_isEditing) {
        final ei = widget.editItem!;
        await repo.addPendingOp(
          entityType: 'inventory_item',
          operation: 'update',
          entityId: ei.id,
          endpoint: '/api/mobile/inventory/${ei.id}',
          payload: jsonEncode(body),
        );
        repo.upsertInventoryItem(InventoryItem(
          id: ei.id,
          codigo: _codigoController.text.isEmpty ? null : _codigoController.text.trim(),
          nombre: _nombreController.text.trim(),
          tipo: _tipo,
          unidad: _unidad,
          stockActual: ei.stockActual,
          stockMinimo: stockMin,
          precioUnitario: precio,
          activo: ei.activo,
          notas: _notasController.text.isEmpty ? null : _notasController.text.trim(),
          valorTotal: ei.stockActual * precio,
        ));
      } else {
        final stockActual = double.tryParse(_stockController.text) ?? 0.0;
        final tempId = -DateTime.now().millisecondsSinceEpoch;
        body['stock_actual'] = stockActual;
        await repo.addPendingOp(
          entityType: 'inventory_item',
          operation: 'create',
          tempId: tempId,
          endpoint: '/api/mobile/inventory',
          payload: jsonEncode(body),
        );
        repo.upsertInventoryItem(InventoryItem(
          id: tempId,
          codigo: _codigoController.text.isEmpty ? null : _codigoController.text.trim(),
          nombre: _nombreController.text.trim(),
          tipo: _tipo,
          unidad: _unidad,
          stockActual: stockActual,
          stockMinimo: stockMin,
          precioUnitario: precio,
          activo: true,
          notas: _notasController.text.isEmpty ? null : _notasController.text.trim(),
          valorTotal: stockActual * precio,
        ));
      }
      SyncToast.show(context, 'Guardado localmente. Se sincronizará al reconectar.');
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear el item.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar item' : 'Nuevo item',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Nombre
                TextFormField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                // Código + tipo
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _codigoController,
                        decoration:
                            const InputDecoration(labelText: 'Código (opcional)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _tipo,
                        items: const [
                          DropdownMenuItem(
                              value: 'venta', child: Text('Venta')),
                          DropdownMenuItem(
                              value: 'material', child: Text('Material')),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _tipo = v);
                        },
                        decoration: const InputDecoration(labelText: 'Tipo'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Unidad
                DropdownButtonFormField<String>(
                  initialValue: _unidad,
                  items: _unidades
                      .map((u) =>
                          DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _unidad = v);
                  },
                  decoration: const InputDecoration(labelText: 'Unidad'),
                ),
                const SizedBox(height: 10),
                // Stock inicial (solo creación) + Stock mínimo
                Row(
                  children: [
                    if (!_isEditing)
                      Expanded(
                        child: TextFormField(
                          controller: _stockController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              labelText: 'Stock inicial'),
                        ),
                      ),
                    if (!_isEditing) const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _stockMinimoController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Stock mínimo (alerta)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Precio
                TextFormField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Precio unitario *'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (double.tryParse(v) == null) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notasController,
                  decoration:
                      const InputDecoration(labelText: 'Notas (opcional)'),
                  maxLines: 2,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!,
                      style: GoogleFonts.inter(
                          color: AppTheme.colorError, fontSize: 13)),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text(_isEditing ? 'Guardar cambios' : 'Crear item'),
        ),
      ],
    );
  }
}

// ── Dialog: Registrar movimiento ──────────────────────────────────────────────

class _NewMovementDialog extends StatefulWidget {
  final InventoryItem item;
  final String initialTipo;
  final VoidCallback onSaved;

  const _NewMovementDialog({
    required this.item,
    required this.initialTipo,
    required this.onSaved,
  });

  @override
  State<_NewMovementDialog> createState() => _NewMovementDialogState();
}

class _NewMovementDialogState extends State<_NewMovementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _referenciaController = TextEditingController();
  late String _tipo;
  DateTime _fecha = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tipo = widget.initialTipo;
  }

  @override
  void dispose() {
    _cantidadController.dispose();
    _referenciaController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) setState(() => _fecha = picked);
  }

  String _tipoLabel(String t) {
    switch (t) {
      case 'entrada':
        return 'Entrada (agrega stock)';
      case 'salida':
        return 'Salida (reduce stock)';
      default:
        return 'Ajuste (establece stock)';
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final api = context.read<ApiService>();
      final cantidad = double.parse(_cantidadController.text);
      if (_tipo == 'salida' && cantidad > widget.item.stockActual) {
        setState(() {
          _error =
              'Stock insuficiente. Disponible: ${widget.item.stockActual.toStringAsFixed(2)}';
          _saving = false;
        });
        return;
      }
      final movBody = {
        'tipo': _tipo,
        'cantidad': cantidad,
        'fecha': _fecha.toIso8601String().substring(0, 10),
        if (_referenciaController.text.isNotEmpty)
          'referencia': _referenciaController.text.trim(),
      };
      await api.post('/api/mobile/inventory/${widget.item.id}/movements', movBody);
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      if (!mounted) return;
      final cantidad = double.parse(_cantidadController.text);
      final repo = context.read<LocalRepository>();
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      await repo.addPendingOp(
        entityType: 'inventory_movement',
        operation: 'create',
        tempId: tempId,
        endpoint: '/api/mobile/inventory/${widget.item.id}/movements',
        payload: jsonEncode({
          'tipo': _tipo,
          'cantidad': cantidad,
          'fecha': _fecha.toIso8601String().substring(0, 10),
          if (_referenciaController.text.isNotEmpty)
            'referencia': _referenciaController.text.trim(),
        }),
      );
      // Actualizar stock optimistamente
      double nuevoStock;
      if (_tipo == 'entrada') {
        nuevoStock = widget.item.stockActual + cantidad;
      } else if (_tipo == 'salida') {
        nuevoStock = widget.item.stockActual - cantidad;
      } else {
        nuevoStock = cantidad; // ajuste
      }
      repo.upsertInventoryItem(InventoryItem(
        id: widget.item.id,
        codigo: widget.item.codigo,
        nombre: widget.item.nombre,
        descripcion: widget.item.descripcion,
        tipo: widget.item.tipo,
        categoria: widget.item.categoria,
        unidad: widget.item.unidad,
        stockActual: nuevoStock,
        stockMinimo: widget.item.stockMinimo,
        precioUnitario: widget.item.precioUnitario,
        proveedorId: widget.item.proveedorId,
        activo: widget.item.activo,
        notas: widget.item.notas,
        valorTotal: nuevoStock * widget.item.precioUnitario,
      ));
      repo.upsertMovements([
        InventoryMovement(
          id: tempId,
          itemId: widget.item.id,
          tipo: _tipo,
          cantidad: cantidad,
          fecha: _fecha.toIso8601String().substring(0, 10),
          referencia: _referenciaController.text.isEmpty
              ? null
              : _referenciaController.text.trim(),
        ),
      ]);
      SyncToast.show(context, 'Movimiento guardado localmente. Se sincronizará al reconectar.');
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo registrar el movimiento.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Registrar movimiento',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.item.nombre} — Stock: ${widget.item.stockActual.toStringAsFixed(2)} ${widget.item.unidad}',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _tipo,
                items: ['entrada', 'salida', 'ajuste']
                    .map((t) => DropdownMenuItem(
                        value: t, child: Text(_tipoLabel(t))))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _tipo = v);
                },
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: _tipo == 'ajuste'
                      ? 'Nuevo stock total *'
                      : 'Cantidad *',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (double.tryParse(v) == null) return 'Número inválido';
                  if (double.parse(v) <= 0) return 'Debe ser mayor a 0';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  child: Text(_formatDate(_fecha),
                      style: GoogleFonts.inter(fontSize: 14)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _referenciaController,
                decoration: const InputDecoration(
                    labelText: 'Referencia / motivo (opcional)'),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!,
                    style: GoogleFonts.inter(
                        color: AppTheme.colorError, fontSize: 13)),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : const Text('Registrar'),
        ),
      ],
    );
  }
}
