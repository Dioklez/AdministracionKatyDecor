import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/quote_service.dart';
import '../../services/project_service.dart';
import '../../models/quote_model.dart';
import '../../models/project_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/project_badge.dart';

class QuotesScreen extends StatefulWidget {
  const QuotesScreen({super.key});

  @override
  State<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends State<QuotesScreen> {
  List<Quote> _allQuotes = [];
  List<Project> _projects = [];
  bool _loading = true;
  String? _error;

  String _statusFilter = 'all';
  String? _projectFilter;

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
      final futures = <Future>[
        QuoteService().getAll(),
        if (_projects.isEmpty) ProjectService().getAll(),
      ];
      final results = await Future.wait(futures);
      if (!mounted) return;
      final quotes = results[0] as List<Quote>;
      if (_projects.isEmpty) _projects = results[1] as List<Project>;
      setState(() {
        _allQuotes = quotes;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar las cotizaciones.';
          _loading = false;
        });
      }
    }
  }

  Project? _projectById(String? id) =>
      id == null ? null : _projects.where((p) => p.id == id).firstOrNull;

  List<Quote> get _filteredQuotes {
    var list = _allQuotes;
    if (_statusFilter != 'all') {
      list = list.where((q) => q.status == _statusFilter).toList();
    }
    if (_projectFilter != null) {
      list = list.where((q) => q.projectId == _projectFilter).toList();
    }
    return list;
  }

  Future<void> _deleteQuote(Quote q) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar cotización?',
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
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await QuoteService().delete(q.id);
        await _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se pudo eliminar la cotización.')),
          );
        }
      }
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
                  'Cotizaciones',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showQuoteDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nueva cotización'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
            child: _buildFilters(),
          ),

          const Divider(height: 1),

          Expanded(
            child: _error != null
                ? _buildError()
                : _loading
                    ? _buildShimmer()
                    : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StatusChip(
                  label: 'Todas',
                  selected: _statusFilter == 'all',
                  onTap: () => setState(() => _statusFilter = 'all'),
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  label: 'Pendientes',
                  selected: _statusFilter == 'pendiente',
                  color: AppTheme.colorAdvertencia,
                  onTap: () => setState(() => _statusFilter = 'pendiente'),
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  label: 'Aprobadas',
                  selected: _statusFilter == 'aprobada',
                  color: AppTheme.colorExito,
                  onTap: () => setState(() => _statusFilter = 'aprobada'),
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  label: 'Rechazadas',
                  selected: _statusFilter == 'rechazada',
                  color: AppTheme.colorError,
                  onTap: () => setState(() => _statusFilter = 'rechazada'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (_projects.isNotEmpty)
          DropdownButton<String?>(
            value: _projectFilter,
            hint: Text('Todos los proyectos',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario)),
            underline: const SizedBox(),
            style: GoogleFonts.inter(
                fontSize: 13, color: AppTheme.colorTextoSecundario),
            items: [
              const DropdownMenuItem<String?>(
                  value: null, child: Text('Todos los proyectos')),
              ..._projects.map((p) => DropdownMenuItem<String?>(
                    value: p.id,
                    child: Text(p.name),
                  )),
            ],
            onChanged: (v) => setState(() => _projectFilter = v),
          ),
      ],
    );
  }

  Widget _buildList() {
    final quotes = _filteredQuotes;
    if (quotes.isEmpty) {
      return EmptyState(
        icon: Icons.description_outlined,
        title: 'Sin cotizaciones',
        subtitle: _statusFilter != 'all'
            ? 'No hay cotizaciones con este estado'
            : 'Crea la primera cotización',
        actionLabel: 'Nueva cotización',
        onAction: _showQuoteDialog,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(28),
      itemCount: quotes.length,
      itemBuilder: (context, i) {
        final q = quotes[i];
        return _QuoteCard(
          quote: q,
          project: _projectById(q.projectId),
          onEdit: () => _showQuoteDialog(editQuote: q),
          onDelete: () => _deleteQuote(q),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(28),
      itemCount: 6,
      itemBuilder: (context, i) => const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: ShimmerBox(height: 76),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline,
              size: 48, color: AppTheme.colorTextoSecundario),
          const SizedBox(height: 12),
          Text(_error!,
              style: GoogleFonts.inter(color: AppTheme.colorTextoSecundario)),
          const SizedBox(height: 16),
          OutlinedButton(
              onPressed: _loadData, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  void _showQuoteDialog({Quote? editQuote}) {
    showDialog(
      context: context,
      builder: (ctx) => _QuoteDialog(
        projects: _projects,
        editQuote: editQuote,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadData();
        },
      ),
    );
  }
}

// ── Status chip ───────────────────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _StatusChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withAlpha(30) : AppTheme.colorCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppTheme.colorBorde,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? c : AppTheme.colorTextoSecundario,
          ),
        ),
      ),
    );
  }
}

// ── Card de cotización ────────────────────────────────────────────────────────

class _QuoteCard extends StatelessWidget {
  final Quote quote;
  final Project? project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuoteCard({
    required this.quote,
    this.project,
    required this.onEdit,
    required this.onDelete,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'aprobada':
        return AppTheme.colorExito;
      case 'rechazada':
        return AppTheme.colorError;
      default:
        return AppTheme.colorAdvertencia;
    }
  }

  String _formatAmount(double v) {
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
    return '\$${v.toStringAsFixed(0)}';
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.length < 10) return '';
    final parts = iso.substring(0, 10).split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return iso;
  }

  @override
  Widget build(BuildContext context) {
    final q = quote;
    final statusColor = _statusColor(q.status);
    final title = q.clientName?.isNotEmpty == true
        ? q.clientName!
        : q.folio?.isNotEmpty == true
            ? q.folio!
            : 'Sin cliente';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Row(
        children: [
          // Título + proyecto + fecha
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTexto,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (project != null)
                      ProjectBadge(
                        projectName: project!.name,
                        colorHex: project!.color,
                      )
                    else
                      const ProjectBadge(projectName: 'Sin proyecto'),
                    if (q.date != null && q.date!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        _formatDate(q.date),
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.colorTextoSecundario),
                      ),
                    ],
                    if (q.folio != null && q.folio!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        q.folio!,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.colorTextoSecundario),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Badge de status
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              q.statusLabel,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Total
          Text(
            _formatAmount(q.total),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.colorTexto,
            ),
          ),
          const SizedBox(width: 4),

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                size: 18, color: AppTheme.colorTextoSecundario),
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dialog: Nueva / Editar cotización ─────────────────────────────────────────

class _QuoteDialog extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback onSaved;
  final Quote? editQuote;

  const _QuoteDialog({
    required this.projects,
    required this.onSaved,
    this.editQuote,
  });

  @override
  State<_QuoteDialog> createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<_QuoteDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _folioController;
  late TextEditingController _clientNameController;
  late TextEditingController _clientPhoneController;
  late TextEditingController _subtotalController;
  late TextEditingController _taxController;
  late TextEditingController _totalController;
  late TextEditingController _notesController;
  String? _selectedProjectId;
  String _status = 'pendiente';
  DateTime? _date;
  DateTime? _validUntil;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editQuote != null;

  @override
  void initState() {
    super.initState();
    final q = widget.editQuote;
    _folioController = TextEditingController(text: q?.folio ?? '');
    _clientNameController =
        TextEditingController(text: q?.clientName ?? '');
    _clientPhoneController =
        TextEditingController(text: q?.clientPhone ?? '');
    _subtotalController = TextEditingController(
        text: q != null ? q.subtotal.toStringAsFixed(2) : '');
    _taxController = TextEditingController(
        text: q != null ? q.tax.toStringAsFixed(2) : '');
    _totalController = TextEditingController(
        text: q != null ? q.total.toStringAsFixed(2) : '');
    _notesController = TextEditingController(text: q?.notes ?? '');
    _selectedProjectId = q?.projectId;
    _status = q?.status ?? 'pendiente';
    _date = q?.date != null ? DateTime.tryParse(q!.date!) : null;
    _validUntil =
        q?.validUntil != null ? DateTime.tryParse(q!.validUntil!) : null;
  }

  @override
  void dispose() {
    _folioController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _subtotalController.dispose();
    _taxController.dispose();
    _totalController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _recalcTotal() {
    final sub = double.tryParse(_subtotalController.text) ?? 0;
    final tax = double.tryParse(_taxController.text) ?? 0;
    _totalController.text = (sub + tax).toStringAsFixed(2);
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate(bool isValidUntil) async {
    final initial = isValidUntil
        ? (_validUntil ?? DateTime.now())
        : (_date ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isValidUntil) {
          _validUntil = picked;
        } else {
          _date = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'folio': _folioController.text.trim(),
      'clientName': _clientNameController.text.trim(),
      'clientPhone': _clientPhoneController.text.trim(),
      'projectId': _selectedProjectId ?? '',
      'date': _date?.toIso8601String().substring(0, 10) ?? '',
      'validUntil': _validUntil?.toIso8601String().substring(0, 10) ?? '',
      'status': _status,
      'subtotal': double.tryParse(_subtotalController.text) ?? 0.0,
      'tax': double.tryParse(_taxController.text) ?? 0.0,
      'total': double.tryParse(_totalController.text) ?? 0.0,
      'notes': _notesController.text.trim(),
    };
    try {
      final svc = QuoteService();
      if (_isEditing) {
        await svc.update(widget.editQuote!.id, body);
      } else {
        await svc.create(body);
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear la cotización.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar cotización' : 'Nueva cotización',
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
                // Folio + cliente
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _folioController,
                        decoration:
                            const InputDecoration(labelText: 'Folio (opcional)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _clientNameController,
                        decoration:
                            const InputDecoration(labelText: 'Cliente (opcional)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Teléfono cliente
                TextFormField(
                  controller: _clientPhoneController,
                  decoration:
                      const InputDecoration(labelText: 'Teléfono (opcional)'),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                // Proyecto
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
                  onChanged: (v) =>
                      setState(() => _selectedProjectId = v),
                  decoration: const InputDecoration(
                      labelText: 'Proyecto (opcional)'),
                ),
                const SizedBox(height: 10),

                // Fechas
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(false),
                        child: InputDecorator(
                          decoration:
                              const InputDecoration(labelText: 'Fecha'),
                          child: Text(
                            _date != null ? _formatDate(_date!) : 'Sin fecha',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(true),
                        child: InputDecorator(
                          decoration:
                              const InputDecoration(labelText: 'Válida hasta'),
                          child: Text(
                            _validUntil != null
                                ? _formatDate(_validUntil!)
                                : 'Sin fecha',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Subtotal + IVA + Total
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _subtotalController,
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
                        controller: _taxController,
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
                        controller: _totalController,
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

                // Estado
                DropdownButtonFormField<String>(
                  value: _status,
                  items: const [
                    DropdownMenuItem(
                        value: 'pendiente', child: Text('Pendiente')),
                    DropdownMenuItem(
                        value: 'aprobada', child: Text('Aprobada')),
                    DropdownMenuItem(
                        value: 'rechazada', child: Text('Rechazada')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                const SizedBox(height: 10),

                // Notas
                TextFormField(
                  controller: _notesController,
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
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(_isEditing ? 'Guardar cambios' : 'Crear cotización'),
        ),
      ],
    );
  }
}
