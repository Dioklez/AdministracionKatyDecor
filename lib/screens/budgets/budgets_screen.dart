import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../services/category_service.dart';
import '../../database/local_repository.dart';
import '../../widgets/sync_toast.dart';
import '../../models/budget.dart';
import '../../models/category_model.dart';
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
  bool _loading = true;
  String? _error;

  late int _month;
  late int _year;

  static const _months = [
    '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
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

      // Categorías desde PocketBase (solo si no están cargadas)
      if (_categories.isEmpty) {
        try {
          _categories = await CategoryService().getAll();
        } catch (_) {
          // Continuar aunque fallen las categorías
        }
      }

      final budgetData = await api.get('/api/mobile/budgets/status?month=$_month&year=$_year');
      if (!mounted) return;

      final budgetList = (budgetData as List<dynamic>? ?? [])
          .map((e) => Budget.fromJson(e as Map<String, dynamic>))
          .toList();

      await repo.clearBudgets();
      repo.upsertBudgets(budgetList);

      setState(() {
        _budgets = budgetList;
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
      final budgetList = await repo.getBudgets();
      if (!mounted) return;
      setState(() {
        _budgets = budgetList;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar los presupuestos.';
          _loading = false;
        });
      }
    }
  }

  void _prevMonth() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year--;
      } else {
        _month--;
      }
    });
    _loadData();
  }

  void _nextMonth() {
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year++;
      } else {
        _month++;
      }
    });
    _loadData();
  }

  double get _totalLimit =>
      _budgets.fold(0.0, (sum, b) => sum + b.limit);
  double get _totalSpent =>
      _budgets.fold(0.0, (sum, b) => sum + b.spent);
  double get _totalRemaining => _totalLimit - _totalSpent;

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
                const SizedBox(width: 24),
                // Selector de mes/año
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _prevMonth,
                  color: AppTheme.colorTextoSecundario,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.colorCard,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.colorBorde),
                  ),
                  child: Text(
                    '${_months[_month]} $_year',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorTexto,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                  color: AppTheme.colorTextoSecundario,
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
        // Resumen general
        if (_budgets.isNotEmpty) ...[
          _buildSummaryRow(),
          const SizedBox(height: 24),
        ],

        // Grid de cards
        if (_budgets.isEmpty)
          EmptyState(
            icon: Icons.savings_outlined,
            title: 'Sin presupuestos',
            subtitle: 'Crea un presupuesto para ${_months[_month]}',
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
            label: 'Total presupuestado',
            value: _fmt(_totalLimit),
            color: AppTheme.colorPrimario,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Total gastado',
            value: _fmt(_totalSpent),
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
          itemBuilder: (context, i) => const ShimmerBox(height: double.infinity),
        ),
      ],
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
              style: GoogleFonts.inter(color: AppTheme.colorTextoSecundario)),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: _loadData, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  // ── Diálogos ──────────────────────────────────────────────────────────────

  void _showBudgetDialog({Budget? editBudget}) {
    showDialog(
      context: context,
      builder: (ctx) => _NewBudgetDialog(
        categories: _categories,
        month: _month,
        year: _year,
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
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(
            'Presupuesto de ${b.categoryName} para ${_months[_month]} $_year.\nEsta acción no se puede deshacer.',
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
            .delete('/api/mobile/budgets/${b.budgetId}');
        context.read<LocalRepository>().deleteBudget(b.budgetId);
        _loadData();
      } on ApiOfflineException {
        final repo = context.read<LocalRepository>();
        await repo.addPendingOp(
          entityType: 'budget', operation: 'delete',
          entityId: b.budgetId, endpoint: '/api/mobile/budgets/${b.budgetId}',
        );
        repo.deleteBudget(b.budgetId);
        if (mounted) {
          SyncToast.show(context, 'Eliminado localmente. Se sincronizará al reconectar.');
          _loadData();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se pudo eliminar el presupuesto.')),
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

  Color _alertColor(String level) {
    switch (level) {
      case 'danger':
        return AppTheme.colorError;
      case 'warning':
        return AppTheme.colorAdvertencia;
      default:
        return AppTheme.colorExito;
    }
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
    final barColor = _alertColor(b.alertLevel);
    final pctClamped = (b.pct / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
        border: b.alertLevel == 'danger'
            ? Border.all(color: AppTheme.colorError.withAlpha(80), width: 1.5)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  b.categoryName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
                            fontSize: 10, color: AppTheme.colorTextoSecundario)),
                    Text(_fmt(b.spent),
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
                  Text('Límite',
                      style: GoogleFonts.inter(
                          fontSize: 10, color: AppTheme.colorTextoSecundario)),
                  Text(_fmt(b.limit),
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
                '${b.pct.toStringAsFixed(1)}% usado',
                style: GoogleFonts.inter(
                    fontSize: 11, color: barColor, fontWeight: FontWeight.w500),
              ),
              if (b.alertLevel != 'ok')
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: barColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    b.alertLevel == 'danger' ? 'Excedido' : 'Alerta',
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

class _NewBudgetDialog extends StatefulWidget {
  final List<Category> categories;
  final int month;
  final int year;
  final VoidCallback onSaved;
  final Budget? editBudget;

  const _NewBudgetDialog({
    required this.categories,
    required this.month,
    required this.year,
    required this.onSaved,
    this.editBudget,
  });

  @override
  State<_NewBudgetDialog> createState() => _NewBudgetDialogState();
}

class _NewBudgetDialogState extends State<_NewBudgetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _limitController = TextEditingController();
  String? _selectedCategoryId;
  late int _month;
  late int _year;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editBudget != null;

  static const _months = [
    '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
    'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
  ];

  @override
  void initState() {
    super.initState();
    _month = widget.month;
    _year = widget.year;
    final b = widget.editBudget;
    if (b != null) {
      _limitController.text = b.limit.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _limitController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final limitAmount = double.parse(_limitController.text);

    try {
      final api = context.read<ApiService>();
      if (_isEditing) {
        await api.put('/api/mobile/budgets/${widget.editBudget!.budgetId}', {
          'limit_amount': limitAmount,
        });
      } else {
        await api.post('/api/mobile/budgets', {
          'category_id': _selectedCategoryId,
          'limit_amount': limitAmount,
          'month': _month,
          'year': _year,
        });
      }
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      final repo = context.read<LocalRepository>();
      if (_isEditing) {
        await repo.addPendingOp(
          entityType: 'budget', operation: 'update',
          entityId: widget.editBudget!.budgetId,
          endpoint: '/api/mobile/budgets/${widget.editBudget!.budgetId}',
          payload: jsonEncode({'limit_amount': limitAmount}),
        );
      } else {
        await repo.addPendingOp(
          entityType: 'budget', operation: 'create',
          endpoint: '/api/mobile/budgets',
          payload: jsonEncode({
            'category_id': _selectedCategoryId,
            'limit_amount': limitAmount,
            'month': _month,
            'year': _year,
          }),
        );
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
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Categoría (solo en creación)
              if (!_isEditing)
                DropdownButtonFormField<String?>(
                  initialValue: _selectedCategoryId,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('— Selecciona una categoría —')),
                    ...widget.categories.map((c) => DropdownMenuItem<String?>(
                          value: c.id,
                          child: Text(c.name),
                        )),
                  ],
                  onChanged: (v) => setState(() => _selectedCategoryId = v),
                  decoration: const InputDecoration(labelText: 'Categoría *'),
                  validator: (v) =>
                      v == null ? 'Selecciona una categoría' : null,
                ),
              if (!_isEditing) const SizedBox(height: 10),

              // Mes/año (solo en creación)
              if (!_isEditing)
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        initialValue: _month,
                        items: List.generate(
                            12,
                            (i) => DropdownMenuItem(
                                value: i + 1, child: Text(_months[i + 1]))),
                        onChanged: (v) {
                          if (v != null) setState(() => _month = v);
                        },
                        decoration: const InputDecoration(labelText: 'Mes'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: _year.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Año'),
                        onChanged: (v) {
                          final y = int.tryParse(v);
                          if (y != null) _year = y;
                        },
                      ),
                    ),
                  ],
                ),
              if (!_isEditing) const SizedBox(height: 10),

              TextFormField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Límite (MXN) *'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  if (double.tryParse(v) == null) return 'Número inválido';
                  if (double.parse(v) <= 0) return 'Debe ser mayor a 0';
                  return null;
                },
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
              : Text(_isEditing ? 'Guardar cambios' : 'Crear presupuesto'),
        ),
      ],
    );
  }
}
