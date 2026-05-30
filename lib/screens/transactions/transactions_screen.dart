import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../database/local_repository.dart';
import '../../widgets/sync_toast.dart';
import '../../models/transaction.dart';
import '../../models/project.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/project_badge.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  List<Transaction> _transactions = [];
  List<Project> _projects = [];
  bool _loading = true;
  String? _error;

  // 'all' | 'general' | '<project_id>'
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
      final api = context.read<ApiService>();
      final repo = context.read<LocalRepository>();

      if (_projects.isEmpty) {
        final results = await Future.wait([
          _fetchTransactions(api),
          api.get('/api/mobile/projects'),
        ]);
        if (!mounted) return;
        final projectList = (results[1] as List<dynamic>? ?? [])
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList();
        repo.upsertProjects(projectList);
        repo.upsertTransactions(results[0] as List<Transaction>);
        setState(() {
          _transactions = results[0] as List<Transaction>;
          _projects = projectList;
          _loading = false;
        });
      } else {
        final txns = await _fetchTransactions(api);
        if (!mounted) return;
        repo.upsertTransactions(txns);
        setState(() {
          _transactions = txns;
          _loading = false;
        });
      }
    } on ApiOfflineException {
      await _loadFromLocal();
    } catch (e) {
      await _loadFromLocal();
    }
  }

  Future<void> _loadFromLocal() async {
    try {
      final repo = context.read<LocalRepository>();
      List<Transaction> txns;
      if (_filterMode == 'general') {
        txns = await repo.getTransactionsByScope('general');
      } else if (_filterMode != 'all') {
        final pid = int.tryParse(_filterMode);
        txns = pid != null
            ? await repo.getTransactionsByProjectId(pid)
            : await repo.getAllTransactions();
      } else {
        txns = await repo.getAllTransactions();
      }
      final projects =
          _projects.isEmpty ? await repo.getAllProjects() : _projects;
      if (!mounted) return;
      setState(() {
        _transactions = txns;
        _projects = projects;
        _loading = false;
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar las transacciones.';
          _loading = false;
        });
      }
    }
  }

  Future<List<Transaction>> _fetchTransactions(ApiService api) async {
    String endpoint = '/api/mobile/transactions';
    if (_filterMode == 'general') {
      endpoint += '?scope=general';
    } else if (_filterMode != 'all') {
      endpoint += '?project_id=$_filterMode';
    }
    final result = await api.get(endpoint);
    return (result as List<dynamic>? ?? [])
        .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void _applyFilter(String mode) {
    if (_filterMode == mode) return;
    setState(() => _filterMode = mode);
    _loadData();
  }

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
                  onPressed: () => _showAddTransactionDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Agregar transacción'),
                ),
              ],
            ),
          ),

          // ── Filtros por proyecto ────────────────────────────────────────
          if (!_loading || _projects.isNotEmpty)
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
            label: 'Generales',
            selected: _filterMode == 'general',
            onSelected: () => _applyFilter('general'),
          ),
          ..._projects.map((p) {
            final id = p.id.toString();
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _FilterChip(
                label: p.name,
                selected: _filterMode == id,
                color: p.displayColor,
                onSelected: () => _applyFilter(id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransactionsList() {
    if (_transactions.isEmpty) {
      return EmptyState(
        icon: Icons.swap_vert,
        title: 'Sin transacciones',
        subtitle: _filterMode == 'general'
            ? 'No hay transacciones generales registradas'
            : _filterMode != 'all'
                ? 'No hay transacciones para este proyecto'
                : 'No hay transacciones registradas',
        actionLabel: 'Agregar transacción',
        onAction: _showAddTransactionDialog,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(28),
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        return _TransactionRow(transaction: _transactions[index]);
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

  // ── Diálogo: Agregar transacción ──────────────────────────────────────────

  void _showAddTransactionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _AddTransactionDialog(
        projects: _projects,
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

  const _TransactionRow({required this.transaction});

  String _formatDate(String date) {
    if (date.length >= 10) {
      final parts = date.substring(0, 10).split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  String _formatMxn(double value) {
    final abs = value.abs();
    String formatted;
    if (abs >= 1000000) {
      formatted = '\$${(abs / 1000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000) {
      final s = abs.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      formatted = '\$$buf';
    } else {
      formatted = '\$${abs.toStringAsFixed(0)}';
    }
    return formatted;
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
              color: (isIncome ? AppTheme.colorExito : AppTheme.colorError).withAlpha(26),
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

          // Descripción + categoría
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description.isNotEmpty
                      ? t.description
                      : (t.categoryName ?? 'Sin descripción'),
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
                    if (t.categoryName != null) ...[
                      Text(
                        t.categoryName!,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.colorTextoSecundario,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (t.projectName != null)
                      ProjectBadge(
                        projectName: t.projectName!,
                        colorHex: t.projectColor,
                      )
                    else
                      ProjectBadge(projectName: 'General'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Fecha
          Text(
            _formatDate(t.transactionDate),
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.colorTextoSecundario,
            ),
          ),
          const SizedBox(width: 16),

          // Monto
          Text(
            '${isIncome ? '+' : '-'}${_formatMxn(t.amountMxn)}',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isIncome ? AppTheme.colorExito : AppTheme.colorError,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Diálogo para agregar transacción ──────────────────────────────────────────

class _AddTransactionDialog extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback onSaved;

  const _AddTransactionDialog({
    required this.projects,
    required this.onSaved,
  });

  @override
  State<_AddTransactionDialog> createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<_AddTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'expense';
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String _currency = 'MXN';
  final _exchangeController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  int? _selectedProjectId;
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _descController.dispose();
    _amountController.dispose();
    _exchangeController.dispose();
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

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final amount = double.tryParse(_amountController.text) ?? 0.0;
    final exchangeRate = double.tryParse(_exchangeController.text) ?? 1.0;
    final amountMxn = _currency == 'MXN' ? amount : amount * exchangeRate;
    final body = <String, dynamic>{
      'type': _type,
      'scope_type': _selectedProjectId != null ? 'project' : 'general',
      if (_selectedProjectId != null) 'scope_id': _selectedProjectId,
      'description': _descController.text.trim(),
      'amount': amount,
      'currency': _currency,
      'exchange_rate': exchangeRate,
      'amount_mxn': amountMxn,
      'transaction_date': _date.toIso8601String().substring(0, 10),
      if (_notesController.text.isNotEmpty) 'notes': _notesController.text.trim(),
    };

    try {
      final api = context.read<ApiService>();
      final repo = context.read<LocalRepository>();
      final result = await api.post('/api/mobile/transactions', body);
      if (result != null) {
        repo.upsertTransaction(
            Transaction.fromJson(result as Map<String, dynamic>));
      }
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      final repo = context.read<LocalRepository>();
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      await repo.addPendingOp(
        entityType: 'transaction', operation: 'create',
        tempId: tempId, endpoint: '/api/mobile/transactions',
        payload: jsonEncode(body),
      );
      repo.upsertTransaction(Transaction.fromJson({
        ...body, 'id': tempId,
        'created_at': DateTime.now().toIso8601String(),
      }));
      if (mounted) {
        SyncToast.show(context, 'Guardado localmente. Se sincronizará al reconectar.');
        widget.onSaved();
      }
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
    return AlertDialog(
      title: Text(
        'Nueva transacción',
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
                        selected: _type == 'expense',
                        color: AppTheme.colorError,
                        onTap: () => setState(() => _type = 'expense'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TypeButton(
                        label: 'Ingreso',
                        icon: Icons.arrow_downward_outlined,
                        selected: _type == 'income',
                        color: AppTheme.colorExito,
                        onTap: () => setState(() => _type = 'income'),
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

                // Monto + moneda
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monto'),
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
                        onChanged: (v) => setState(() => _currency = v ?? 'MXN'),
                        decoration: const InputDecoration(labelText: 'Moneda'),
                      ),
                    ),
                  ],
                ),
                if (_currency != 'MXN') ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _exchangeController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Tipo de cambio (MXN/USD)'),
                  ),
                ],
                const SizedBox(height: 12),

                // Proyecto
                DropdownButtonFormField<int?>(
                  initialValue: _selectedProjectId,
                  items: [
                    const DropdownMenuItem<int?>(
                        value: null, child: Text('Ninguno — General')),
                    ...widget.projects.map((p) => DropdownMenuItem<int?>(
                          value: p.id,
                          child: Text(p.name),
                        )),
                  ],
                  onChanged: (v) => setState(() => _selectedProjectId = v),
                  decoration: const InputDecoration(labelText: 'Proyecto (opcional)'),
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
                  decoration: const InputDecoration(labelText: 'Notas (opcional)'),
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
              : const Text('Guardar'),
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
            Icon(icon, size: 16, color: selected ? color : AppTheme.colorTextoSecundario),
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
