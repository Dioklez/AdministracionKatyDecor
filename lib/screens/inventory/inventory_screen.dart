import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../database/local_repository.dart';
import '../../services/inventory_item_service.dart';
import '../../services/inventory_movement_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/offline_queue_service.dart';
import '../../models/inventory_item_model.dart';
import '../../models/inventory_movement_model.dart';
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

  String? _selectedId;
  InventoryItem? _selectedItem;
  List<InventoryMovement> _movements = [];
  bool _loadingDetail = false;

  String _searchQuery = '';
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

  Future<void> _loadItems() async {
    setState(() {
      _loadingList = true;
      _listError = null;
    });
    try {
      final repo = context.read<LocalRepository>();
      final items = await InventoryItemService(repo: repo).getAll();
      if (!mounted) return;
      setState(() {
        _items = items;
        _loadingList = false;
        if (_selectedId != null) {
          _selectedItem =
              _items.where((i) => i.id == _selectedId).firstOrNull;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _listError = 'No se pudo cargar el inventario.';
          _loadingList = false;
        });
      }
    }
  }

  Future<void> _selectItem(String id) async {
    setState(() {
      _selectedId = id;
      _selectedItem = _items.where((i) => i.id == id).firstOrNull;
      _loadingDetail = true;
      _movements = [];
    });
    try {
      final movements = await InventoryMovementService(
              repo: context.read<LocalRepository>())
          .getByItem(id);
      if (mounted) {
        setState(() {
          _movements = movements;
          _loadingDetail = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  List<InventoryItem> get _filtered {
    if (_searchQuery.isEmpty) return _items;
    final q = _searchQuery.toLowerCase();
    return _items.where((i) => i.name.toLowerCase().contains(q)).toList();
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
    final filtered = _filtered;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar item...',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
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
                  : filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.inventory_2_outlined,
                          title: _searchQuery.isEmpty
                              ? 'Sin items'
                              : 'Sin resultados',
                          subtitle: _searchQuery.isEmpty
                              ? 'Agrega el primer item al inventario'
                              : 'Intenta con otro término',
                          actionLabel:
                              _searchQuery.isEmpty ? 'Nuevo item' : null,
                          onAction:
                              _searchQuery.isEmpty ? _showItemDialog : null,
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (ctx, i) => _ItemTile(
                            item: filtered[i],
                            selected: _selectedId == filtered[i].id,
                            onTap: () => _selectItem(filtered[i].id),
                            onEdit: () =>
                                _showItemDialog(editItem: filtered[i]),
                            onDelete: () => _confirmDelete(filtered[i]),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () =>
                      _showMovementDialog(item, initialType: 'entrada'),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Entrada'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.colorExito),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: item.currentStock > 0
                      ? () => _showMovementDialog(item, initialType: 'salida')
                      : null,
                  icon: const Icon(Icons.remove, size: 16),
                  label: const Text('Salida'),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.colorError),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () =>
                      _showMovementDialog(item, initialType: 'ajuste'),
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
                      item.name,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.colorTexto,
                      ),
                    ),
                    if (item.description != null) ...[
                      const SizedBox(height: 2),
                      Text(item.description!,
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
                    '${item.currentStock.toStringAsFixed(item.currentStock == item.currentStock.roundToDouble() ? 0 : 2)} ${item.unit ?? ''}',
                color: item.isBajoStock
                    ? AppTheme.colorError
                    : AppTheme.colorTexto,
              ),
              const SizedBox(width: 24),
              _StatCell(
                label: 'Stock mínimo',
                value: item.minStock != null
                    ? '${item.minStock!.toStringAsFixed(0)} ${item.unit ?? ''}'
                    : '—',
                color: AppTheme.colorTextoSecundario,
              ),
              if (item.location != null) ...[
                const SizedBox(width: 24),
                _StatCell(
                  label: 'Ubicación',
                  value: item.location!,
                  color: AppTheme.colorTextoSecundario,
                ),
              ],
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
                  child: Text('Notas',
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
      builder: (ctx) => _ItemDialog(
        editItem: editItem,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadItems().then((_) {
            final id = editItem?.id ?? _selectedId;
            if (id != null) _selectItem(id);
          });
        },
      ),
    );
  }

  void _showMovementDialog(InventoryItem item,
      {required String initialType}) {
    showDialog(
      context: context,
      builder: (ctx) => _MovementDialog(
        item: item,
        initialType: initialType,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadItems().then((_) => _selectItem(item.id));
        },
      ),
    );
  }

  Future<void> _confirmDelete(InventoryItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${item.name}"?',
            style:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Esta acción no se puede deshacer.',
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
        final connectivity = context.read<ConnectivityService>();
        final repo = context.read<LocalRepository>();
        final queue = context.read<OfflineQueueService>();
        Future<void> deleteOffline() async {
          await repo.deleteInventoryItem(item.id);
          await queue.enqueue(entityType: 'inventory_items', operation: 'delete',
              endpoint: 'inventory_items', entityId: item.id, payload: {});
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
        }
        if (connectivity.isOnline) {
          try { await InventoryItemService(repo: repo).delete(item.id); }
          catch (_) { await deleteOffline(); }
        } else { await deleteOffline(); }
        if (mounted) {
          setState(() {
            if (_selectedId == item.id) {
              _selectedId = null;
              _selectedItem = null;
              _movements = [];
            }
          });
          _loadItems();
        }
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
                            item.name,
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
                    Text(
                      'Stock: ${item.currentStock.toStringAsFixed(item.currentStock == item.currentStock.roundToDouble() ? 0 : 2)}${item.unit != null ? ' ${item.unit}' : ''}',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: item.isBajoStock
                              ? AppTheme.colorError
                              : AppTheme.colorTextoSecundario),
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

  Color _typeColor(String type) {
    switch (type) {
      case 'entrada':
        return AppTheme.colorExito;
      case 'salida':
        return AppTheme.colorError;
      default:
        return AppTheme.colorAdvertencia;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
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
    final color = _typeColor(m.type);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(_formatDate(m.date),
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
              child: Text(_typeLabel(m.type),
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: color)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${m.type == 'salida' ? '-' : '+'}${m.quantity.toStringAsFixed(m.quantity == m.quantity.roundToDouble() ? 0 : 2)}',
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
              child: Text(m.notes ?? '—',
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

class _ItemDialog extends StatefulWidget {
  final VoidCallback onSaved;
  final InventoryItem? editItem;

  const _ItemDialog({required this.onSaved, this.editItem});

  @override
  State<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends State<_ItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitController = TextEditingController();
  final _minStockController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.editItem;
    if (item != null) {
      _nameController.text = item.name;
      _unitController.text = item.unit ?? '';
      _minStockController.text = item.minStock?.toStringAsFixed(0) ?? '';
      _locationController.text = item.location ?? '';
      _descriptionController.text = item.description ?? '';
      _notesController.text = item.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _unitController.dispose();
    _minStockController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final data = {
      'name': _nameController.text.trim(),
      'unit': _unitController.text.trim(),
      'min_stock': double.tryParse(_minStockController.text.trim()) ?? 0,
      'location': _locationController.text.trim(),
      'description': _descriptionController.text.trim(),
      'notes': _notesController.text.trim(),
    };
    try {
      final connectivity = context.read<ConnectivityService>();
      final repo = context.read<LocalRepository>();
      final queue = context.read<OfflineQueueService>();

      if (_isEditing) {
        final id = widget.editItem!.id;
        Future<void> upsertOffline() async {
          await repo.upsertInventoryItem(InventoryItem(
            id: id,
            name: data['name'] as String,
            description: (data['description'] as String).isNotEmpty
                ? data['description'] as String : null,
            unit: (data['unit'] as String).isNotEmpty
                ? data['unit'] as String : null,
            currentStock: widget.editItem!.currentStock,
            minStock: (data['min_stock'] as num?) != 0
                ? (data['min_stock'] as num?)?.toDouble() : null,
            supplierProductId: widget.editItem!.supplierProductId,
            location: (data['location'] as String).isNotEmpty
                ? data['location'] as String : null,
            notes: (data['notes'] as String).isNotEmpty
                ? data['notes'] as String : null,
            created: widget.editItem!.created,
            updated: DateTime.now(),
          ));
          await queue.enqueue(entityType: 'inventory_items', operation: 'update',
              endpoint: 'inventory_items', entityId: id, payload: data);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
        }
        if (connectivity.isOnline) {
          try { await InventoryItemService(repo: repo).update(id, data); }
          catch (_) { await upsertOffline(); }
        } else { await upsertOffline(); }
        if (mounted) widget.onSaved();
        return;
      }

      // CREATE PATH
      if (!connectivity.isOnline) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertInventoryItem(InventoryItem(
          id: tempId,
          name: data['name'] as String,
          description: (data['description'] as String).isNotEmpty
              ? data['description'] as String : null,
          unit: (data['unit'] as String).isNotEmpty
              ? data['unit'] as String : null,
          currentStock: 0,
          minStock: (data['min_stock'] as num?) != 0
              ? (data['min_stock'] as num?)?.toDouble() : null,
          supplierProductId: null,
          location: (data['location'] as String).isNotEmpty
              ? data['location'] as String : null,
          notes: (data['notes'] as String).isNotEmpty
              ? data['notes'] as String : null,
          created: DateTime.now(),
          updated: DateTime.now(),
        ));
        await queue.enqueue(entityType: 'inventory_items', operation: 'create',
            endpoint: 'inventory_items', payload: {...data, '_tempId': tempId});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
          widget.onSaved();
        }
        return;
      }
      try {
        await InventoryItemService(repo: repo).create(data);
      } catch (_) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertInventoryItem(InventoryItem(
          id: tempId, name: data['name'] as String,
          description: (data['description'] as String).isNotEmpty
              ? data['description'] as String : null,
          unit: (data['unit'] as String).isNotEmpty
              ? data['unit'] as String : null,
          currentStock: 0,
          minStock: (data['min_stock'] as num?) != 0
              ? (data['min_stock'] as num?)?.toDouble() : null,
          supplierProductId: null,
          location: (data['location'] as String).isNotEmpty
              ? data['location'] as String : null,
          notes: (data['notes'] as String).isNotEmpty
              ? data['notes'] as String : null,
          created: DateTime.now(), updated: DateTime.now(),
        ));
        await queue.enqueue(entityType: 'inventory_items', operation: 'create',
            endpoint: 'inventory_items', payload: {...data, '_tempId': tempId});
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
      }
      if (mounted) widget.onSaved();
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
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _unitController,
                        decoration:
                            const InputDecoration(labelText: 'Unidad'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _minStockController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                            labelText: 'Stock mínimo'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _locationController,
                  decoration:
                      const InputDecoration(labelText: 'Ubicación (opcional)'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Descripción (opcional)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notesController,
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

class _MovementDialog extends StatefulWidget {
  final InventoryItem item;
  final String initialType;
  final VoidCallback onSaved;

  const _MovementDialog({
    required this.item,
    required this.initialType,
    required this.onSaved,
  });

  @override
  State<_MovementDialog> createState() => _MovementDialogState();
}

class _MovementDialogState extends State<_MovementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  late String _type;
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  String _typeLabel(String t) {
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
    final quantity = double.parse(_quantityController.text);
    if (_type == 'salida' && quantity > widget.item.currentStock) {
      setState(() {
        _error =
            'Stock insuficiente. Disponible: ${widget.item.currentStock.toStringAsFixed(2)}';
        _saving = false;
      });
      return;
    }
    try {
      final itemId = widget.item.id;
      final dateStr = _date.toIso8601String().substring(0, 10);
      final movBody = {
        'inventory_item': itemId,
        'type': _type,
        'quantity': quantity,
        'date': dateStr,
        'notes': _notesController.text.trim(),
      };
      final connectivity = context.read<ConnectivityService>();
      final repo = context.read<LocalRepository>();
      final queue = context.read<OfflineQueueService>();

      if (!connectivity.isOnline) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertInventoryMovements([InventoryMovement(
          id: tempId,
          inventoryItemId: itemId,
          type: _type,
          quantity: quantity,
          date: dateStr,
          projectId: null,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim() : null,
          created: DateTime.now(),
          updated: DateTime.now(),
        )]);
        await queue.enqueue(entityType: 'inventory_movements', operation: 'create',
            endpoint: 'inventory_movements',
            payload: {...movBody, '_tempId': tempId});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
          widget.onSaved();
        }
        return;
      }

      // ONLINE PATH
      bool savedOffline = false;
      try {
        // 1. Registrar movimiento
        await InventoryMovementService(repo: repo).create(movBody);

        // 2. Recalcular stock desde todos los movimientos
        final movements = await InventoryMovementService(repo: repo).getByItem(itemId);
        double newStock = 0;
        for (final m in movements) {
          if (m.type == 'salida') {
            newStock -= m.quantity;
          } else {
            newStock += m.quantity;
          }
        }

        // 3. Actualizar current_stock en PocketBase
        await InventoryItemService(repo: repo).update(itemId, {'current_stock': newStock});
      } catch (_) {
        savedOffline = true;
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertInventoryMovements([InventoryMovement(
          id: tempId,
          inventoryItemId: itemId,
          type: _type,
          quantity: quantity,
          date: dateStr,
          projectId: null,
          notes: _notesController.text.trim().isNotEmpty
              ? _notesController.text.trim() : null,
          created: DateTime.now(),
          updated: DateTime.now(),
        )]);
        await queue.enqueue(entityType: 'inventory_movements', operation: 'create',
            endpoint: 'inventory_movements',
            payload: {...movBody, '_tempId': tempId});
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
      }
      if (!savedOffline) {
        // noop — success message not needed
      }

      // 4. Refrescar UI
      if (mounted) widget.onSaved();
    } catch (e) {
      print('InventoryMovementService.create error: $e');
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
                '${widget.item.name} — Stock: ${widget.item.currentStock.toStringAsFixed(2)}${widget.item.unit != null ? ' ${widget.item.unit}' : ''}',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _type,
                items: ['entrada', 'salida', 'ajuste']
                    .map((t) => DropdownMenuItem(
                        value: t, child: Text(_typeLabel(t))))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _type = v);
                },
                decoration: const InputDecoration(labelText: 'Tipo'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: _type == 'ajuste'
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
                  child: Text(_formatDate(_date),
                      style: GoogleFonts.inter(fontSize: 14)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                    labelText: 'Notas / motivo (opcional)'),
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
