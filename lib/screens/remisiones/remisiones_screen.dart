import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../database/local_repository.dart';
import '../../services/remision_service.dart';
import '../../services/project_service.dart';
import '../../services/supplier_service.dart';
import '../../models/remision_model.dart';
import '../../models/project_model.dart';
import '../../models/supplier_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';

class RemisionesScreen extends StatefulWidget {
  const RemisionesScreen({super.key});

  @override
  State<RemisionesScreen> createState() => _RemisionesScreenState();
}

class _RemisionesScreenState extends State<RemisionesScreen> {
  List<Remision> _all = [];
  List<Project> _projects = [];
  List<Supplier> _suppliers = [];
  bool _loading = true;
  String? _error;

  String _statusFilter = 'all';
  String? _selectedId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = context.read<LocalRepository>();
      final futures = <Future>[
        RemisionService(repo: repo).getAll(),
        if (_projects.isEmpty) ProjectService(repo: repo).getAll(),
        if (_suppliers.isEmpty) SupplierService(repo: repo).getAll(),
      ];
      final results = await Future.wait(futures);
      if (!mounted) return;
      int idx = 0;
      final list = results[idx++] as List<Remision>;
      if (_projects.isEmpty) _projects = results[idx++] as List<Project>;
      if (_suppliers.isEmpty) _suppliers = results[idx++] as List<Supplier>;
      setState(() {
        _all = list;
        _loading = false;
        if (_selectedId != null && !list.any((r) => r.id == _selectedId)) {
          _selectedId = null;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar las remisiones.';
          _loading = false;
        });
      }
    }
  }

  List<Remision> get _filtered {
    if (_statusFilter == 'all') return _all;
    return _all.where((r) => r.status == _statusFilter).toList();
  }

  Remision? get _selected =>
      _selectedId == null
          ? null
          : _all.where((r) => r.id == _selectedId).firstOrNull;

  String _projectName(String? id) =>
      id == null ? '' : (_projects.where((p) => p.id == id).firstOrNull?.name ?? id);

  String _supplierName(String? id) =>
      id == null ? '' : (_suppliers.where((s) => s.id == id).firstOrNull?.name ?? id);

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
                  'Remisiones',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showRemisionDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nueva remisión'),
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
        _buildStatusFilter(),
        const Divider(height: 1),
        Expanded(
          child: _loading
              ? _buildShimmer()
              : _error != null
                  ? Center(
                      child: Text(_error!,
                          style: GoogleFonts.inter(
                              color: AppTheme.colorTextoSecundario)))
                  : _filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: 'Sin remisiones',
                          subtitle: 'Crea la primera remisión',
                          actionLabel: 'Nueva remisión',
                          onAction: _showRemisionDialog,
                        )
                      : ListView.builder(
                          itemCount: _filtered.length,
                          itemBuilder: (ctx, i) => _RemisionTile(
                            remision: _filtered[i],
                            selected: _selectedId == _filtered[i].id,
                            onTap: () =>
                                setState(() => _selectedId = _filtered[i].id),
                            onEdit: () =>
                                _showRemisionDialog(edit: _filtered[i]),
                            onDelete: () => _confirmDelete(_filtered[i]),
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildStatusFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TabBtn(
              label: 'Todas',
              selected: _statusFilter == 'all',
              onTap: () => setState(() => _statusFilter = 'all'),
            ),
            const SizedBox(width: 6),
            _TabBtn(
              label: 'Pendientes',
              color: AppTheme.colorAdvertencia,
              selected: _statusFilter == 'pendiente',
              onTap: () => setState(() => _statusFilter = 'pendiente'),
            ),
            const SizedBox(width: 6),
            _TabBtn(
              label: 'Recibidas',
              color: AppTheme.colorExito,
              selected: _statusFilter == 'recibida',
              onTap: () => setState(() => _statusFilter = 'recibida'),
            ),
            const SizedBox(width: 6),
            _TabBtn(
              label: 'Canceladas',
              color: AppTheme.colorError,
              selected: _statusFilter == 'cancelada',
              onTap: () => setState(() => _statusFilter = 'cancelada'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, i) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ShimmerBox(width: 120, height: 12),
          SizedBox(height: 6),
          ShimmerBox(height: 10),
        ]),
      ),
    );
  }

  // ── Panel derecho ─────────────────────────────────────────────────────────

  Widget _buildRightPanel() {
    final r = _selected;
    if (r == null) {
      return const EmptyState(
        icon: Icons.receipt_long_outlined,
        title: 'Selecciona una remisión',
        subtitle: 'Haz clic en una remisión para ver su detalle',
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _buildDetail(r),
    );
  }

  Widget _buildDetail(Remision r) {
    final statusColor = _statusColor(r.status);
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
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  r.folio?.isNotEmpty == true ? r.folio! : 'Sin folio',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.colorTexto,
                  ),
                ),
              ),
              _StatusBadge(label: r.statusLabel, color: statusColor),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    size: 18, color: AppTheme.colorTextoSecundario),
                onSelected: (v) {
                  if (v == 'edit') _showRemisionDialog(edit: r);
                  if (v == 'delete') _confirmDelete(r);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Campos
          Wrap(
            spacing: 32,
            runSpacing: 12,
            children: [
              if (r.date != null)
                _InfoCell(label: 'Fecha', value: _fmtDate(r.date)),
              if (r.projectId != null)
                _InfoCell(label: 'Proyecto', value: _projectName(r.projectId)),
              if (r.supplierId != null)
                _InfoCell(label: 'Proveedor', value: _supplierName(r.supplierId)),
              _InfoCell(
                  label: 'Subtotal', value: _fmtMoney(r.subtotal)),
              _InfoCell(label: 'IVA', value: _fmtMoney(r.tax)),
              _InfoCell(
                label: 'Total',
                value: _fmtMoney(r.total),
                color: AppTheme.colorPrimario,
              ),
            ],
          ),

          if (r.notes != null && r.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Notas',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTextoSecundario)),
            const SizedBox(height: 4),
            Text(r.notes!,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTexto)),
          ],

          if (r.items.isNotEmpty) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            Text('Partidas',
                style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto)),
            const SizedBox(height: 8),
            ...r.items.map((item) => _ItemRow(item: item)),
          ],
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _statusColor(String status) {
    switch (status) {
      case 'recibida':
        return AppTheme.colorExito;
      case 'cancelada':
        return AppTheme.colorError;
      default:
        return AppTheme.colorAdvertencia;
    }
  }

  String _fmtDate(String? iso) {
    if (iso == null || iso.length < 10) return '';
    final p = iso.substring(0, 10).split('-');
    if (p.length == 3) return '${p[2]}/${p[1]}/${p[0]}';
    return iso;
  }

  String _fmtMoney(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) {
      final s = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '\$$buf';
    }
    return '\$${v.toStringAsFixed(2)}';
  }

  // ── Diálogos ──────────────────────────────────────────────────────────────

  void _showRemisionDialog({Remision? edit}) {
    showDialog(
      context: context,
      builder: (ctx) => _RemisionDialog(
        projects: _projects,
        suppliers: _suppliers,
        editRemision: edit,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadData();
        },
      ),
    );
  }

  Future<void> _confirmDelete(Remision r) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
            '¿Eliminar remisión${r.folio != null ? ' ${r.folio}' : ''}?',
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w600)),
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
        await RemisionService().delete(r.id);
        if (mounted) {
          setState(() {
            if (_selectedId == r.id) _selectedId = null;
          });
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se pudo eliminar la remisión.')),
          );
        }
      }
    }
  }
}

// ── Tab button ────────────────────────────────────────────────────────────────

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _TabBtn({
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

// ── Tile de remisión ──────────────────────────────────────────────────────────

class _RemisionTile extends StatefulWidget {
  final Remision remision;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RemisionTile({
    required this.remision,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_RemisionTile> createState() => _RemisionTileState();
}

class _RemisionTileState extends State<_RemisionTile> {
  bool _hovered = false;

  Color _statusColor(String status) {
    switch (status) {
      case 'recibida':
        return AppTheme.colorExito;
      case 'cancelada':
        return AppTheme.colorError;
      default:
        return AppTheme.colorAdvertencia;
    }
  }

  String _fmtDate(String? iso) {
    if (iso == null || iso.length < 10) return '';
    final p = iso.substring(0, 10).split('-');
    if (p.length == 3) return '${p[2]}/${p[1]}/${p[0]}';
    return iso;
  }

  String _fmtMoney(double v) {
    if (v >= 1000) {
      final s = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '\$$buf';
    }
    return '\$${v.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.remision;
    final statusColor = _statusColor(r.status);

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
                    Text(
                      r.folio?.isNotEmpty == true ? r.folio! : 'Sin folio',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.selected
                            ? AppTheme.colorPrimario
                            : AppTheme.colorTexto,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (r.date != null)
                          Text(
                            _fmtDate(r.date),
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.colorTextoSecundario),
                          ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            r.statusLabel,
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: statusColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _fmtMoney(r.total),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colorPrimario,
                      ),
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

// ── Status badge ──────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ── Info cell ─────────────────────────────────────────────────────────────────

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _InfoCell({required this.label, required this.value, this.color});

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
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color ?? AppTheme.colorTexto)),
      ],
    );
  }
}

// ── Item row ──────────────────────────────────────────────────────────────────

class _ItemRow extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final desc = item['description']?.toString() ??
        item['desc']?.toString() ??
        item['name']?.toString() ??
        '';
    final qty = item['quantity']?.toString() ?? item['qty']?.toString() ?? '';
    final price = item['price']?.toString() ?? item['unit_price']?.toString() ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(desc,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTexto)),
          ),
          if (qty.isNotEmpty)
            Text('x$qty ',
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppTheme.colorTextoSecundario)),
          if (price.isNotEmpty)
            Text('\$$price',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTexto)),
        ],
      ),
    );
  }
}

// ── Dialog: Nueva / Editar remisión ───────────────────────────────────────────

class _RemisionDialog extends StatefulWidget {
  final List<Project> projects;
  final List<Supplier> suppliers;
  final Remision? editRemision;
  final VoidCallback onSaved;

  const _RemisionDialog({
    required this.projects,
    required this.suppliers,
    this.editRemision,
    required this.onSaved,
  });

  @override
  State<_RemisionDialog> createState() => _RemisionDialogState();
}

class _RemisionDialogState extends State<_RemisionDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _folioCtrl;
  late TextEditingController _subtotalCtrl;
  late TextEditingController _taxCtrl;
  late TextEditingController _totalCtrl;
  late TextEditingController _notesCtrl;
  String? _selectedProjectId;
  String? _selectedSupplierId;
  String _status = 'pendiente';
  DateTime? _date;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editRemision != null;

  @override
  void initState() {
    super.initState();
    final r = widget.editRemision;
    _folioCtrl = TextEditingController(text: r?.folio ?? '');
    _subtotalCtrl = TextEditingController(
        text: r != null ? r.subtotal.toStringAsFixed(2) : '');
    _taxCtrl = TextEditingController(
        text: r != null ? r.tax.toStringAsFixed(2) : '');
    _totalCtrl = TextEditingController(
        text: r != null ? r.total.toStringAsFixed(2) : '');
    _notesCtrl = TextEditingController(text: r?.notes ?? '');
    _selectedProjectId = r?.projectId;
    _selectedSupplierId = r?.supplierId;
    _status = r?.status ?? 'pendiente';
    _date = r?.date != null ? DateTime.tryParse(r!.date!) : null;
  }

  @override
  void dispose() {
    _folioCtrl.dispose();
    _subtotalCtrl.dispose();
    _taxCtrl.dispose();
    _totalCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _recalcTotal() {
    final sub = double.tryParse(_subtotalCtrl.text) ?? 0;
    final tax = double.tryParse(_taxCtrl.text) ?? 0;
    _totalCtrl.text = (sub + tax).toStringAsFixed(2);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'folio': _folioCtrl.text.trim(),
      'project': _selectedProjectId ?? '',
      'supplier': _selectedSupplierId ?? '',
      'date': _date?.toIso8601String().substring(0, 10) ?? '',
      'status': _status,
      'subtotal': double.tryParse(_subtotalCtrl.text) ?? 0.0,
      'tax': double.tryParse(_taxCtrl.text) ?? 0.0,
      'total': double.tryParse(_totalCtrl.text) ?? 0.0,
      'notes': _notesCtrl.text.trim(),
    };
    try {
      final svc = RemisionService();
      if (_isEditing) {
        await svc.update(widget.editRemision!.id, body);
      } else {
        await svc.create(body);
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear la remisión.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar remisión' : 'Nueva remisión',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 460,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _folioCtrl,
                        decoration:
                            const InputDecoration(labelText: 'Folio (opcional)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _pickDate,
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Fecha'),
                          child: Text(
                            _date != null ? _formatDate(_date!) : 'Sin fecha',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  value: _selectedProjectId,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Sin proyecto')),
                    ...widget.projects.map((p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(p.name),
                        )),
                  ],
                  onChanged: (v) => setState(() => _selectedProjectId = v),
                  decoration:
                      const InputDecoration(labelText: 'Proyecto (opcional)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  value: _selectedSupplierId,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Sin proveedor')),
                    ...widget.suppliers.map((s) => DropdownMenuItem<String?>(
                          value: s.id,
                          child: Text(s.name),
                        )),
                  ],
                  onChanged: (v) => setState(() => _selectedSupplierId = v),
                  decoration:
                      const InputDecoration(labelText: 'Proveedor (opcional)'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _subtotalCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Subtotal', prefixText: '\$ '),
                        onChanged: (_) => _recalcTotal(),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          if (double.tryParse(v) == null) return 'Inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _taxCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'IVA', prefixText: '\$ '),
                        onChanged: (_) => _recalcTotal(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _totalCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Total', prefixText: '\$ '),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          if (double.tryParse(v) == null) return 'Inválido';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: const [
                    DropdownMenuItem(
                        value: 'pendiente', child: Text('Pendiente')),
                    DropdownMenuItem(
                        value: 'recibida', child: Text('Recibida')),
                    DropdownMenuItem(
                        value: 'cancelada', child: Text('Cancelada')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Notas (opcional)'),
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
              : Text(_isEditing ? 'Guardar cambios' : 'Crear remisión'),
        ),
      ],
    );
  }
}
