import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../database/local_repository.dart';
import '../../services/budget_service.dart';
import '../../services/category_service.dart';
import '../../services/project_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/offline_queue_service.dart';
import '../../models/budget_model.dart';
import '../../models/category_model.dart';
import '../../models/project_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';

class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key});

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  List<Budget> _budgets = [];
  List<Category> _categories = [];
  List<Project> _projects = [];
  bool _loading = true;
  String? _error;

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
        BudgetService(repo: repo).getAll(),
        if (_categories.isEmpty) CategoryService(repo: repo).getAll(),
        if (_projects.isEmpty) ProjectService(repo: repo).getAll(),
      ];
      final results = await Future.wait(futures);
      if (!mounted) return;
      int idx = 0;
      final budgets = results[idx++] as List<Budget>;
      if (_categories.isEmpty) _categories = results[idx++] as List<Category>;
      if (_projects.isEmpty) _projects = results[idx++] as List<Project>;
      setState(() {
        _budgets = budgets;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar los presupuestos.';
          _loading = false;
        });
      }
    }
  }

  double get _totalPlanned =>
      _budgets.fold(0.0, (s, b) => s + b.plannedAmount);
  double get _totalActual =>
      _budgets.fold(0.0, (s, b) => s + b.actualAmount);
  double get _totalRemaining =>
      _budgets.fold(0.0, (s, b) => s + b.remaining);

  String _fmt(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) {
      final s = v.abs().toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '${v < 0 ? '-' : ''}\$$buf';
    }
    return '\$${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorFondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
            child: Row(
              children: [
                Text(
                  'Presupuestos',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showBudgetDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nuevo presupuesto'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: _error != null
                ? _buildError()
                : _loading
                    ? _buildShimmer()
                    : _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        if (_budgets.isNotEmpty) ...[
          _buildSummaryRow(),
          const SizedBox(height: 24),
        ],

        if (_budgets.isEmpty)
          EmptyState(
            icon: Icons.savings_outlined,
            title: 'Sin presupuestos',
            subtitle: 'Crea el primer presupuesto',
            actionLabel: 'Nuevo presupuesto',
            onAction: _showBudgetDialog,
          )
        else
          _buildGrid(),
      ],
    );
  }

  Widget _buildSummaryRow() {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Total planeado',
            value: _fmt(_totalPlanned),
            color: AppTheme.colorPrimario,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Total gastado',
            value: _fmt(_totalActual),
            color: AppTheme.colorError,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Total disponible',
            value: _fmt(_totalRemaining),
            color: _totalRemaining >= 0
                ? AppTheme.colorExito
                : AppTheme.colorError,
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      int crossCount;
      if (constraints.maxWidth > 1000) {
        crossCount = 3;
      } else if (constraints.maxWidth > 600) {
        crossCount = 2;
      } else {
        crossCount = 1;
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.8,
        ),
        itemCount: _budgets.length,
        itemBuilder: (context, i) => _BudgetCard(
          budget: _budgets[i],
          onEdit: () => _showBudgetDialog(editBudget: _budgets[i]),
          onDelete: () => _confirmDelete(_budgets[i]),
        ),
      );
    });
  }

  Widget _buildShimmer() {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        Row(
          children: List.generate(
              3,
              (i) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: i > 0 ? 16 : 0),
                      child: const ShimmerBox(height: 80),
                    ),
                  )),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.8,
          ),
          itemCount: 6,
          itemBuilder: (context, i) =>
              const ShimmerBox(height: double.infinity),
        ),
      ],
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

  void _showBudgetDialog({Budget? editBudget}) {
    showDialog(
      context: context,
      builder: (ctx) => _BudgetDialog(
        categories: _categories,
        projects: _projects,
        editBudget: editBudget,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadData();
        },
      ),
    );
  }

  Future<void> _confirmDelete(Budget b) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar presupuesto?',
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(
            'Presupuesto "${b.name}".\nEsta acción no se puede deshacer.',
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
        final connectivity = context.read<ConnectivityService>();
        final repo = context.read<LocalRepository>();
        final queue = context.read<OfflineQueueService>();
        Future<void> deleteOffline() async {
          await repo.deleteBudget(b.id);
          await queue.enqueue(entityType: 'budgets', operation: 'delete',
              endpoint: 'budgets', entityId: b.id, payload: {});
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
        }
        if (connectivity.isOnline) {
          try { await BudgetService(repo: repo).delete(b.id); }
          catch (_) { await deleteOffline(); }
        } else { await deleteOffline(); }
        await _loadData();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el presupuesto.')),
          );
        }
      }
    }
  }
}

// ── Summary card ──────────────────────────────────────────────────────────────

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryCard(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppTheme.colorTextoSecundario)),
          const SizedBox(height: 4),
          Text(value,
              style: GoogleFonts.inter(
                  fontSize: 22, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

// ── Card de presupuesto ───────────────────────────────────────────────────────

class _BudgetCard extends StatelessWidget {
  final Budget budget;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _BudgetCard({
    required this.budget,
    required this.onEdit,
    required this.onDelete,
  });

  Color _barColor(double pct) {
    if (pct >= 100) return AppTheme.colorError;
    if (pct >= 80) return AppTheme.colorAdvertencia;
    return AppTheme.colorExito;
  }

  String _fmt(double v) {
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

  @override
  Widget build(BuildContext context) {
    final b = budget;
    final pct = b.pct;
    final barColor = _barColor(pct);
    final pctClamped = (pct / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
        border: pct >= 100
            ? Border.all(
                color: AppTheme.colorError.withAlpha(80), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  b.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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

          if (b.period != null && b.period!.isNotEmpty)
            Text(
              b.period!,
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppTheme.colorTextoSecundario),
            ),

          const Spacer(),

          // Montos
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Gastado',
                        style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppTheme.colorTextoSecundario)),
                    Text(_fmt(b.actualAmount),
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: barColor)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Planeado',
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppTheme.colorTextoSecundario)),
                  Text(_fmt(b.plannedAmount),
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTexto)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pctClamped,
              minHeight: 8,
              backgroundColor: AppTheme.colorBorde,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${pct.toStringAsFixed(1)}% usado',
                style: GoogleFonts.inter(
                    fontSize: 11,
                    color: barColor,
                    fontWeight: FontWeight.w500),
              ),
              if (pct >= 80)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: barColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    pct >= 100 ? 'Excedido' : 'Alerta',
                    style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: barColor),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dialog: Nuevo / Editar presupuesto ────────────────────────────────────────

class _BudgetDialog extends StatefulWidget {
  final List<Category> categories;
  final List<Project> projects;
  final VoidCallback onSaved;
  final Budget? editBudget;

  const _BudgetDialog({
    required this.categories,
    required this.projects,
    required this.onSaved,
    this.editBudget,
  });

  @override
  State<_BudgetDialog> createState() => _BudgetDialogState();
}

class _BudgetDialogState extends State<_BudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _plannedController;
  late TextEditingController _actualController;
  String _period = 'mensual';
  late TextEditingController _notesController;
  String? _selectedCategoryId;
  String? _selectedProjectId;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editBudget != null;

  @override
  void initState() {
    super.initState();
    final b = widget.editBudget;
    _nameController = TextEditingController(text: b?.name ?? '');
    _plannedController = TextEditingController(
        text: b != null ? b.plannedAmount.toStringAsFixed(2) : '');
    _actualController = TextEditingController(
        text: b != null ? b.actualAmount.toStringAsFixed(2) : '0');
    _period = ['mensual', 'trimestral', 'anual', 'proyecto']
            .contains(b?.period)
        ? b!.period!
        : 'mensual';
    _notesController = TextEditingController(text: b?.notes ?? '');
    _selectedCategoryId = b?.categoryId;
    _selectedProjectId = b?.projectId;
    _startDate = b?.startDate != null ? DateTime.tryParse(b!.startDate!) : null;
    _endDate = b?.endDate != null ? DateTime.tryParse(b!.endDate!) : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _plannedController.dispose();
    _actualController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate(bool isEnd) async {
    final initial =
        isEnd ? (_endDate ?? DateTime.now()) : (_startDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isEnd) {
          _endDate = picked;
        } else {
          _startDate = picked;
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
      'name': _nameController.text.trim(),
      'planned_amount':
          double.tryParse(_plannedController.text) ?? 0.0,
      'actual_amount': double.tryParse(_actualController.text) ?? 0.0,
      'category': _selectedCategoryId ?? '',
      'project': _selectedProjectId ?? '',
      'period': _period,
      'start_date': _startDate?.toIso8601String().substring(0, 10) ?? '',
      'end_date': _endDate?.toIso8601String().substring(0, 10) ?? '',
      'notes': _notesController.text.trim(),
    };
    try {
      final connectivity = context.read<ConnectivityService>();
      final repo = context.read<LocalRepository>();
      final queue = context.read<OfflineQueueService>();

      Budget _budgetFromBody(String id, {required DateTime created}) => Budget(
        id: id,
        name: body['name'] as String,
        projectId: (body['project'] as String).isNotEmpty
            ? body['project'] as String : null,
        period: (body['period'] as String).isNotEmpty
            ? body['period'] as String : null,
        startDate: (body['start_date'] as String).isNotEmpty
            ? body['start_date'] as String : null,
        endDate: (body['end_date'] as String).isNotEmpty
            ? body['end_date'] as String : null,
        plannedAmount: (body['planned_amount'] as num).toDouble(),
        actualAmount: (body['actual_amount'] as num).toDouble(),
        categoryId: (body['category'] as String).isNotEmpty
            ? body['category'] as String : null,
        notes: (body['notes'] as String).isNotEmpty
            ? body['notes'] as String : null,
        created: created,
        updated: DateTime.now(),
      );

      if (_isEditing) {
        final id = widget.editBudget!.id;
        Future<void> upsertOffline() async {
          await repo.upsertBudgets([_budgetFromBody(id,
              created: widget.editBudget!.created)]);
          await queue.enqueue(entityType: 'budgets', operation: 'update',
              endpoint: 'budgets', entityId: id, payload: body);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
        }
        if (connectivity.isOnline) {
          try { await BudgetService(repo: repo).update(id, body); }
          catch (_) { await upsertOffline(); }
        } else { await upsertOffline(); }
        if (mounted) widget.onSaved();
        return;
      }

      // CREATE PATH
      if (!connectivity.isOnline) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertBudgets([_budgetFromBody(tempId, created: DateTime.now())]);
        await queue.enqueue(entityType: 'budgets', operation: 'create',
            endpoint: 'budgets', payload: {...body, '_tempId': tempId});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
          widget.onSaved();
        }
        return;
      }
      try {
        await BudgetService(repo: repo).create(body);
      } catch (_) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertBudgets([_budgetFromBody(tempId, created: DateTime.now())]);
        await queue.enqueue(entityType: 'budgets', operation: 'create',
            endpoint: 'budgets', payload: {...body, '_tempId': tempId});
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear el presupuesto.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar presupuesto' : 'Nuevo presupuesto',
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
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre del presupuesto *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),

                // Categoría
                DropdownButtonFormField<String?>(
                  value: _selectedCategoryId,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Sin categoría')),
                    ...widget.categories.map((c) => DropdownMenuItem<String?>(
                          value: c.id,
                          child: Text(c.name),
                        )),
                  ],
                  onChanged: (v) =>
                      setState(() => _selectedCategoryId = v),
                  decoration:
                      const InputDecoration(labelText: 'Categoría (opcional)'),
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
                  decoration:
                      const InputDecoration(labelText: 'Proyecto (opcional)'),
                ),
                const SizedBox(height: 10),

                // Periodo
                DropdownButtonFormField<String>(
                  value: _period,
                  items: const [
                    DropdownMenuItem(value: 'mensual', child: Text('Mensual')),
                    DropdownMenuItem(
                        value: 'trimestral', child: Text('Trimestral')),
                    DropdownMenuItem(value: 'anual', child: Text('Anual')),
                    DropdownMenuItem(
                        value: 'proyecto', child: Text('Proyecto')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _period = v);
                  },
                  decoration: const InputDecoration(labelText: 'Periodo'),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(false),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                              labelText: 'Fecha inicio'),
                          child: Text(
                            _startDate != null
                                ? _formatDate(_startDate!)
                                : 'Sin fecha',
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
                          decoration: const InputDecoration(
                              labelText: 'Fecha fin'),
                          child: Text(
                            _endDate != null
                                ? _formatDate(_endDate!)
                                : 'Sin fecha',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Monto planeado + real
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _plannedController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Monto planeado *',
                            prefixText: '\$ '),
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
                        controller: _actualController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Monto gastado',
                            prefixText: '\$ '),
                      ),
                    ),
                  ],
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
              : Text(_isEditing ? 'Guardar cambios' : 'Crear presupuesto'),
        ),
      ],
    );
  }
}
