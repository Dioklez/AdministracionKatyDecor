import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../services/project_service.dart';
import '../../database/local_repository.dart';
import '../../widgets/sync_toast.dart';
import '../../models/quote.dart';
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
      final api = context.read<ApiService>();
      final repo = context.read<LocalRepository>();

      String quoteEndpoint = '/api/mobile/quotes';
      if (_projectFilter != null) {
        quoteEndpoint += '?project_id=$_projectFilter';
      }

      final futures = <Future>[
        api.get(quoteEndpoint),
        if (_projects.isEmpty) ProjectService().getAll(),
      ];

      final results = await Future.wait(futures);

      if (!mounted) return;

      final quoteList = (results[0] as List<dynamic>? ?? [])
          .map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList();

      if (results.length > 1) {
        _projects = results[1] as List<Project>;
      }

      repo.upsertQuotes(quoteList);

      setState(() {
        _allQuotes = quoteList;
        _projects = _projects;
        _loading = false;
      });
    } on ApiOfflineException {
      await _loadFromLocal();
    } catch (e) {
      await _loadFromLocal();
    }
  }

  Future<void> _loadFromLocal() async {
    try {
      final repo = context.read<LocalRepository>();
      final quoteList = await repo.getAllQuotes();
      if (!mounted) return;
      setState(() {
        _allQuotes = quoteList;
        _projects = _projects;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar las cotizaciones.';
          _loading = false;
        });
      }
    }
  }

  Project? _projectById(int? id) => null;

  List<Quote> get _filteredQuotes {
    if (_statusFilter == 'all') return _allQuotes;
    return _allQuotes.where((q) => q.status == _statusFilter).toList();
  }

  Future<void> _deleteQuote(Quote q) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar cotización?',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
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
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        final api = context.read<ApiService>();
        final repo = context.read<LocalRepository>();
        await api.delete('/api/mobile/quotes/${q.id}');
        repo.deleteQuote(q.id);
        _loadData();
      } on ApiOfflineException {
        final repo = context.read<LocalRepository>();
        await repo.addPendingOp(
          entityType: 'quote', operation: 'delete',
          entityId: q.id, endpoint: '/api/mobile/quotes/${q.id}',
        );
        repo.deleteQuote(q.id);
        if (mounted) {
          SyncToast.show(context, 'Eliminado localmente. Se sincronizará al reconectar.');
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar la cotización.')),
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
              ..._projects.map((p) =>
                  DropdownMenuItem<String?>(value: p.id, child: Text(p.name))),
            ],
            onChanged: (v) {
              setState(() => _projectFilter = v);
              _loadData();
            },
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
        final project = _projectById(quotes[i].projectId);
        return _QuoteCard(
          quote: quotes[i],
          project: project,
          onEdit: () => _showQuoteDialog(editQuote: quotes[i]),
          onDelete: () => _deleteQuote(quotes[i]),
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
          const Icon(Icons.wifi_off_outlined,
              size: 48, color: AppTheme.colorTextoSecundario),
          const SizedBox(height: 12),
          Text(_error!,
              style:
                  GoogleFonts.inter(color: AppTheme.colorTextoSecundario)),
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
      builder: (ctx) => _NewQuoteDialog(
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

  String _formatMxn(double v) {
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
          // Descripción + proyecto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  q.description ?? 'Sin descripción',
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
                    const SizedBox(width: 8),
                    Text(
                      _formatDate(q.createdAt),
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.colorTextoSecundario),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Badge de status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

          // Monto
          Text(
            _formatMxn(q.amountMxn),
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.colorTexto,
            ),
          ),
          const SizedBox(width: 4),

          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
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

class _NewQuoteDialog extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback onSaved;
  final Quote? editQuote;

  const _NewQuoteDialog({
    required this.projects,
    required this.onSaved,
    this.editQuote,
  });

  @override
  State<_NewQuoteDialog> createState() => _NewQuoteDialogState();
}

class _NewQuoteDialogState extends State<_NewQuoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  final _exchangeController = TextEditingController(text: '1');
  String? _selectedProjectId;
  String _currency = 'MXN';
  String _status = 'pendiente';
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editQuote != null;

  @override
  void initState() {
    super.initState();
    final q = widget.editQuote;
    if (q != null) {
      _descController.text = q.description ?? '';
      _amountController.text = q.amountMxn.toStringAsFixed(2);
      _selectedProjectId = q.projectId.toString();
      _status = q.status;
    }
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _exchangeController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final amount = double.parse(_amountController.text);
    final exchangeRate = double.tryParse(_exchangeController.text) ?? 1.0;
    final amountMxn = _currency == 'MXN' ? amount : amount * exchangeRate;

    final editBody = <String, dynamic>{
      'description': _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      'amount': amount,
      'currency': _currency,
      'exchange_rate': exchangeRate,
      'status': _status,
    };
    final createBody = <String, dynamic>{
      ...editBody,
      'project_id': _selectedProjectId,
    };

    print('[QUOTES] Creando cotización - isOnline: ${!_isEditing ? "check" : "edit"}');
    try {
      final api = context.read<ApiService>();
      final repo = context.read<LocalRepository>();
      if (_isEditing) {
        print('[QUOTES] Editando cotización ID: ${widget.editQuote!.id}');
        await api.put('/api/mobile/quotes/${widget.editQuote!.id}', editBody);
        repo.upsertQuote(Quote.fromJson({
          ...editBody, 'id': widget.editQuote!.id,
          'project_id': widget.editQuote!.projectId,
          'amount_mxn': amountMxn,
          'created_at': widget.editQuote!.createdAt,
        }));
      } else {
        print('[QUOTES] Creando cotización - isOnline: true');
        final result = await api.post('/api/mobile/quotes', createBody);
        if (result != null) {
          repo.upsertQuote(Quote.fromJson(result as Map<String, dynamic>));
        }
      }
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      final repo = context.read<LocalRepository>();
      if (_isEditing) {
        final endpoint = '/api/mobile/quotes/${widget.editQuote!.id}';
        print('[QUOTES] Creando cotización - isOnline: false');
        print('[QUOTES] Agregando a PendingOps: $endpoint');
        await repo.addPendingOp(
          entityType: 'quote', operation: 'update',
          entityId: widget.editQuote!.id,
          endpoint: endpoint,
          payload: jsonEncode(editBody),
        );
        repo.upsertQuote(Quote.fromJson({
          ...editBody, 'id': widget.editQuote!.id,
          'project_id': widget.editQuote!.projectId,
          'amount_mxn': amountMxn,
          'created_at': widget.editQuote!.createdAt,
        }));
      } else {
        const endpoint = '/api/mobile/quotes';
        print('[QUOTES] Creando cotización - isOnline: false');
        print('[QUOTES] Agregando a PendingOps: $endpoint');
        final tempId = -DateTime.now().millisecondsSinceEpoch;
        await repo.addPendingOp(
          entityType: 'quote', operation: 'create',
          tempId: tempId, endpoint: endpoint,
          payload: jsonEncode(createBody),
        );
        repo.upsertQuote(Quote.fromJson({
          ...createBody, 'id': tempId,
          'amount_mxn': amountMxn,
          'created_at': DateTime.now().toIso8601String(),
        }));
      }
      if (mounted) {
        SyncToast.show(context, 'Guardado localmente. Se sincronizará al reconectar.');
        widget.onSaved();
      }
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
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Proyecto (solo en creación)
                if (!_isEditing)
                  DropdownButtonFormField<String?>(
                    value: _selectedProjectId,
                    items: [
                      const DropdownMenuItem<String?>(
                          value: null, child: Text('— Selecciona un proyecto —')),
                      ...widget.projects.map((p) =>
                          DropdownMenuItem<String?>(value: p.id, child: Text(p.name))),
                    ],
                    onChanged: (v) => setState(() => _selectedProjectId = v),
                    decoration: const InputDecoration(labelText: 'Proyecto *'),
                    validator: (v) => v == null ? 'Selecciona un proyecto' : null,
                  ),
                if (!_isEditing) const SizedBox(height: 10),
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(
                      labelText: 'Descripción (opcional)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monto *'),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          if (double.tryParse(v) == null) return 'Número inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: DropdownButtonFormField<String>(
                        initialValue: _currency,
                        items: const [
                          DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                          DropdownMenuItem(value: 'USD', child: Text('USD')),
                        ],
                        onChanged: (v) =>
                            setState(() => _currency = v ?? 'MXN'),
                        decoration: const InputDecoration(labelText: 'Moneda'),
                      ),
                    ),
                  ],
                ),
                if (_currency == 'USD') ...[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _exchangeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Tipo de cambio (MXN/USD)'),
                  ),
                ],
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: _status,
                  items: const [
                    DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                    DropdownMenuItem(value: 'aprobada', child: Text('Aprobada')),
                    DropdownMenuItem(value: 'rechazada', child: Text('Rechazada')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                  decoration: const InputDecoration(labelText: 'Estado'),
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
              : Text(_isEditing ? 'Guardar cambios' : 'Crear cotización'),
        ),
      ],
    );
  }
}
