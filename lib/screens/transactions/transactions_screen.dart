import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../database/local_repository.dart';
import '../../services/transaction_service.dart';
import '../../services/category_service.dart';
import '../../services/account_service.dart';
import '../../services/project_service.dart';
import '../../services/recalculate_service.dart';
import '../../models/transaction_model.dart';
import '../../models/category_model.dart';
import '../../models/account_model.dart';
import '../../models/project_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/project_badge.dart';
import '../../services/connectivity_service.dart';
import '../../services/offline_queue_service.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];
  List<Project> _projects = [];
  List<Category> _categories = [];
  List<Account> _accounts = [];
  bool _loading = true;
  String? _error;

  // 'all' | 'income' | 'expense' | '<project_id>'
  String _filterMode = 'all';

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
        TransactionService(repo: repo).getAll(),
        if (_projects.isEmpty) ProjectService(repo: repo).getAll(),
        if (_categories.isEmpty) CategoryService(repo: repo).getAll(),
        if (_accounts.isEmpty) AccountService(repo: repo).getAll(),
      ];
      final results = await Future.wait(futures);
      if (!mounted) return;
      int idx = 0;
      final txns = results[idx++] as List<Transaction>;
      if (_projects.isEmpty) _projects = results[idx++] as List<Project>;
      if (_categories.isEmpty) _categories = results[idx++] as List<Category>;
      if (_accounts.isEmpty) _accounts = results[idx++] as List<Account>;
      setState(() {
        _transactions = txns;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar las transacciones.';
          _loading = false;
        });
      }
    }
  }

  List<Transaction> get _filtered {
    switch (_filterMode) {
      case 'income':
        return _transactions.where((t) => t.isIncome).toList();
      case 'expense':
        return _transactions.where((t) => !t.isIncome).toList();
      case 'all':
        return _transactions;
      default:
        return _transactions.where((t) => t.projectId == _filterMode).toList();
    }
  }

  void _applyFilter(String mode) {
    if (_filterMode == mode) return;
    setState(() => _filterMode = mode);
  }

  Category? _categoryById(String? id) =>
      id == null ? null : _categories.where((c) => c.id == id).firstOrNull;

  Project? _projectById(String? id) =>
      id == null ? null : _projects.where((p) => p.id == id).firstOrNull;

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorFondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
            child: Row(
              children: [
                Text(
                  'Transacciones',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showTransactionDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Agregar transacción'),
                ),
              ],
            ),
          ),

          // ── Filtros ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
            child: _buildFilterChips(),
          ),

          const Divider(height: 1),

          // ── Cuerpo ─────────────────────────────────────────────────────
          Expanded(
            child: _error != null
                ? _buildError()
                : _loading
                    ? _buildShimmer()
                    : _buildTransactionsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Todas',
            selected: _filterMode == 'all',
            onSelected: () => _applyFilter('all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Ingresos',
            selected: _filterMode == 'income',
            color: AppTheme.colorExito,
            onSelected: () => _applyFilter('income'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Egresos',
            selected: _filterMode == 'expense',
            color: AppTheme.colorError,
            onSelected: () => _applyFilter('expense'),
          ),
          ..._projects.map((p) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _FilterChip(
                label: p.name,
                selected: _filterMode == p.id,
                color: p.displayColor,
                onSelected: () => _applyFilter(p.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    final txns = _filtered;
    if (txns.isEmpty) {
      return EmptyState(
        icon: Icons.swap_vert,
        title: 'Sin transacciones',
        subtitle: 'No hay transacciones registradas',
        actionLabel: 'Agregar transacción',
        onAction: _showTransactionDialog,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(28),
      itemCount: txns.length,
      itemBuilder: (context, index) {
        final t = txns[index];
        return _TransactionRow(
          transaction: t,
          category: _categoryById(t.categoryId),
          project: _projectById(t.projectId),
          onEdit: () => _showTransactionDialog(transaction: t),
          onDelete: () => _deleteTransaction(t),
        );
      },
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(28),
      itemCount: 8,
      itemBuilder: (context, idx) => const Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            ShimmerBox(width: 36, height: 36, borderRadius: 18),
            SizedBox(width: 12),
            Expanded(child: ShimmerBox(height: 44)),
            SizedBox(width: 12),
            ShimmerBox(width: 80, height: 16),
          ],
        ),
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
          OutlinedButton(onPressed: _loadData, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  Future<void> _deleteTransaction(Transaction t) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar transacción'),
        content: Text('¿Eliminar "${t.description}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorError),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final projectId = t.projectId;
      final accountId = t.accountId;
      final connectivity = context.read<ConnectivityService>();
      if (connectivity.isOnline) {
        await TransactionService().delete(t.id);
        if (projectId != null && projectId.isNotEmpty)
          RecalculateService().recalculateProject(projectId).ignore();
        if (accountId != null && accountId.isNotEmpty)
          RecalculateService().recalculateAccount(accountId).ignore();
      } else {
        final repo = context.read<LocalRepository>();
        final queue = context.read<OfflineQueueService>();
        await repo.deleteTransaction(t.id);
        await queue.enqueue(
          entityType: 'transactions',
          operation: 'delete',
          endpoint: 'transactions',
          entityId: t.id,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Guardado localmente. Se sincronizará al reconectar.')),
          );
        }
      }
      await _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo eliminar la transacción.')),
        );
      }
    }
  }

  void _showTransactionDialog({Transaction? transaction}) {
    showDialog(
      context: context,
      builder: (ctx) => _TransactionDialog(
        transaction: transaction,
        projects: _projects,
        categories: _categories,
        accounts: _accounts,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadData();
        },
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.colorPrimario;
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withAlpha(30) : AppTheme.colorCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppTheme.colorBorde,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: c, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? c : AppTheme.colorTextoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fila de transacción ───────────────────────────────────────────────────────

class _TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final Category? category;
  final Project? project;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TransactionRow({
    required this.transaction,
    this.category,
    this.project,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(String date) {
    if (date.length >= 10) {
      final parts = date.substring(0, 10).split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  String _formatAmount(double value) {
    final abs = value.abs();
    if (abs >= 1000000) {
      return '\$${(abs / 1000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000) {
      final s = abs.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '\$$buf';
    } else {
      return '\$${abs.toStringAsFixed(0)}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isIncome = t.isIncome;

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Row(
        children: [
          // Ícono tipo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (isIncome ? AppTheme.colorExito : AppTheme.colorError)
                  .withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_outlined
                  : Icons.arrow_upward_outlined,
              size: 16,
              color: isIncome ? AppTheme.colorExito : AppTheme.colorError,
            ),
          ),
          const SizedBox(width: 12),

          // Descripción + categoría / proyecto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description.isNotEmpty ? t.description : 'Sin descripción',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTexto,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (category != null) ...[
                      Text(
                        category!.name,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.colorTextoSecundario,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (project != null)
                      ProjectBadge(
                        projectName: project!.name,
                        colorHex: project!.color,
                      )
                    else
                      const ProjectBadge(projectName: 'General'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Fecha
          Text(
            _formatDate(t.date),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.colorTextoSecundario,
            ),
          ),
          const SizedBox(width: 16),

          // Monto
          Text(
            '${isIncome ? '+' : '-'}${_formatAmount(t.amount)}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isIncome ? AppTheme.colorExito : AppTheme.colorError,
            ),
          ),
          const SizedBox(width: 8),

          // Acciones
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

// ── Diálogo crear/editar transacción ─────────────────────────────────────────

class _TransactionDialog extends StatefulWidget {
  final Transaction? transaction;
  final List<Project> projects;
  final List<Category> categories;
  final List<Account> accounts;
  final VoidCallback onSaved;

  const _TransactionDialog({
    this.transaction,
    required this.projects,
    required this.categories,
    required this.accounts,
    required this.onSaved,
  });

  @override
  State<_TransactionDialog> createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<_TransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _type;
  late TextEditingController _descController;
  late TextEditingController _amountController;
  late TextEditingController _notesController;
  String? _selectedProjectId;
  String? _selectedCategoryId;
  String? _selectedAccountId;
  late DateTime _date;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _type = t?.type ?? 'egreso';
    _descController = TextEditingController(text: t?.description ?? '');
    _amountController =
        TextEditingController(text: t != null ? t.amount.toStringAsFixed(2) : '');
    _notesController = TextEditingController(text: t?.notes ?? '');
    _selectedProjectId = t?.projectId;
    _selectedCategoryId = t?.categoryId;
    _selectedAccountId = t?.accountId;
    _date = t != null && t.date.isNotEmpty
        ? DateTime.tryParse(t.date) ?? DateTime.now()
        : DateTime.now();
  }

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
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
      'description': _descController.text.trim(),
      'amount': double.tryParse(_amountController.text) ?? 0.0,
      'type': _type,
      'date': _date.toIso8601String().substring(0, 10),
      'project': _selectedProjectId?.isNotEmpty == true ? _selectedProjectId : null,
      'category': _selectedCategoryId?.isNotEmpty == true ? _selectedCategoryId : null,
      'account': _selectedAccountId?.isNotEmpty == true ? _selectedAccountId : null,
      'notes': _notesController.text.trim(),
    };
    try {
      final connectivity = context.read<ConnectivityService>();
      final repo = context.read<LocalRepository>();
      final queue = context.read<OfflineQueueService>();
      final isCreate = widget.transaction == null;

      if (!isCreate) {
        // UPDATE PATH
        final id = widget.transaction!.id;
        Future<void> upsertOffline() async {
          await repo.upsertTransaction(Transaction(
            id: id,
            description: body['description'] as String,
            amount: (body['amount'] as num).toDouble(),
            type: body['type'] as String,
            date: body['date'] as String,
            projectId: body['project'] as String?,
            categoryId: body['category'] as String?,
            accountId: body['account'] as String?,
            notes: body['notes'] as String?,
            created: widget.transaction!.created,
            updated: DateTime.now(),
          ));
          await queue.enqueue(
            entityType: 'transactions',
            operation: 'update',
            endpoint: 'transactions',
            entityId: id,
            payload: body,
          );
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Guardado localmente. Se sincronizará al reconectar.')));
        }

        if (connectivity.isOnline) {
          try {
            await TransactionService(repo: repo).update(id, body);
            final projectId = _selectedProjectId;
            final accountId = _selectedAccountId;
            if (projectId != null && projectId.isNotEmpty)
              RecalculateService().recalculateProject(projectId).ignore();
            if (accountId != null && accountId.isNotEmpty)
              RecalculateService().recalculateAccount(accountId).ignore();
          } catch (_) {
            await upsertOffline();
          }
        } else {
          await upsertOffline();
        }
        if (mounted) widget.onSaved();
        return;
      }

      // CREATE PATH
      if (!connectivity.isOnline) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertTransaction(Transaction(
          id: tempId,
          description: body['description'] as String,
          amount: (body['amount'] as num).toDouble(),
          type: body['type'] as String,
          date: body['date'] as String,
          projectId: body['project'] as String?,
          categoryId: body['category'] as String?,
          accountId: body['account'] as String?,
          notes: body['notes'] as String?,
          created: DateTime.now(),
          updated: DateTime.now(),
        ));
        await queue.enqueue(
          entityType: 'transactions',
          operation: 'create',
          endpoint: 'transactions',
          payload: {...body, '_tempId': tempId},
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Guardado localmente. Se sincronizará al reconectar.')),
          );
          widget.onSaved();
        }
        return;
      }
      await TransactionService(repo: repo).create(body);
      final projectId = _selectedProjectId;
      final accountId = _selectedAccountId;
      if (projectId != null && projectId.isNotEmpty)
        RecalculateService().recalculateProject(projectId).ignore();
      if (accountId != null && accountId.isNotEmpty)
        RecalculateService().recalculateAccount(accountId).ignore();
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo guardar la transacción.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaction != null;
    return AlertDialog(
      title: Text(
        isEdit ? 'Editar transacción' : 'Nueva transacción',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tipo
                Row(
                  children: [
                    Expanded(
                      child: _TypeButton(
                        label: 'Egreso',
                        icon: Icons.arrow_upward_outlined,
                        selected: _type == 'egreso',
                        color: AppTheme.colorError,
                        onTap: () => setState(() => _type = 'egreso'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeButton(
                        label: 'Ingreso',
                        icon: Icons.arrow_downward_outlined,
                        selected: _type == 'ingreso',
                        color: AppTheme.colorExito,
                        onTap: () => setState(() => _type = 'ingreso'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Descripción
                TextFormField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),

                // Monto
                TextFormField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Monto (MXN)', prefixText: '\$ '),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (double.tryParse(v) == null) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

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
                  onChanged: (v) => setState(() => _selectedCategoryId = v),
                  decoration:
                      const InputDecoration(labelText: 'Categoría (opcional)'),
                ),
                const SizedBox(height: 12),

                // Proyecto
                DropdownButtonFormField<String?>(
                  value: _selectedProjectId,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Ninguno — General')),
                    ...widget.projects.map((p) => DropdownMenuItem<String?>(
                          value: p.id,
                          child: Text(p.name),
                        )),
                  ],
                  onChanged: (v) => setState(() => _selectedProjectId = v),
                  decoration:
                      const InputDecoration(labelText: 'Proyecto (opcional)'),
                ),
                const SizedBox(height: 12),

                // Cuenta
                DropdownButtonFormField<String?>(
                  value: _selectedAccountId,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Sin cuenta')),
                    ...widget.accounts.map((a) => DropdownMenuItem<String?>(
                          value: a.id,
                          child: Text(a.name),
                        )),
                  ],
                  onChanged: (v) => setState(() => _selectedAccountId = v),
                  decoration:
                      const InputDecoration(labelText: 'Cuenta (opcional)'),
                ),
                const SizedBox(height: 12),

                // Fecha
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Fecha'),
                    child: Text(_formatDate(_date),
                        style: GoogleFonts.inter(fontSize: 14)),
                  ),
                ),
                const SizedBox(height: 12),

                // Notas
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Notas (opcional)'),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 12),
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
              : Text(isEdit ? 'Guardar cambios' : 'Guardar'),
        ),
      ],
    );
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(30) : AppTheme.colorFondo,
          borderRadius: BorderRadius.circular(AppTheme.radiusBoton),
          border: Border.all(
            color: selected ? color : AppTheme.colorBorde,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 16,
                color: selected ? color : AppTheme.colorTextoSecundario),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? color : AppTheme.colorTextoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
