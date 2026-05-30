import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../database/local_repository.dart';
import '../../widgets/sync_toast.dart';
import '../../models/project.dart';
import '../../models/transaction.dart';
import '../../models/quote.dart';
import '../../models/task.dart';
import '../../theme/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class ProjectDetailScreen extends StatefulWidget {
  final int projectId;

  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Project? _project;
  List<Transaction> _transactions = [];
  List<Quote> _quotes = [];
  List<Task> _tasks = [];
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
      final api = context.read<ApiService>();
      final id = widget.projectId;

      final results = await Future.wait([
        api.get('/api/mobile/projects/$id'),
        api.get('/api/mobile/transactions?project_id=$id'),
        api.get('/api/mobile/quotes?project_id=$id'),
        api.get('/api/mobile/tasks?project_id=$id'),
      ]);

      if (!mounted) return;
      final project = Project.fromJson(results[0] as Map<String, dynamic>);
      final transactions = (results[1] as List<dynamic>? ?? [])
          .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList();
      final quotes = (results[2] as List<dynamic>? ?? [])
          .map((e) => Quote.fromJson(e as Map<String, dynamic>))
          .toList();
      final tasks = (results[3] as List<dynamic>? ?? [])
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
      // Guardar en local (fire-and-forget)
      final repo = context.read<LocalRepository>();
      repo.upsertProject(project);
      repo.upsertTransactions(transactions);
      repo.upsertQuotes(quotes);
      repo.upsertTasks(tasks);
      setState(() {
        _project = project;
        _transactions = transactions;
        _quotes = quotes;
        _tasks = tasks;
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
      final id = widget.projectId;
      final results = await Future.wait([
        repo.getProjectById(id),
        repo.getTransactionsByProjectId(id),
        repo.getQuotesByProjectId(id),
        repo.getTasksByProjectId(id),
      ]);
      if (mounted) {
        setState(() {
          _project = results[0] as Project?;
          _transactions = results[1] as List<Transaction>;
          _quotes = results[2] as List<Quote>;
          _tasks = results[3] as List<Task>;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Sin datos disponibles.';
          _loading = false;
        });
      }
    }
  }

  // ── Cómputos ───────────────────────────────────────────────────────────────

  double get _income =>
      _transactions.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amountMxn);

  double get _expense =>
      _transactions.where((t) => !t.isIncome).fold(0.0, (s, t) => s + t.amountMxn);

  double get _balance => _income - _expense;

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
    return value < 0 ? '-$formatted' : formatted;
  }

  String _formatDate(String date) {
    if (date.length >= 10) {
      final parts = date.substring(0, 10).split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorFondo,
      body: _loading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildErrorState() {
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

  Widget _buildContent() {
    final p = _project!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Botón Volver ──────────────────────────────────────────────
          TextButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Proyectos'),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.colorTextoSecundario,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 16),

          // ── Header del proyecto ───────────────────────────────────────
          _buildProjectHeader(p),
          const SizedBox(height: 24),

          // ── Stat cards ────────────────────────────────────────────────
          _buildStatCards(),
          const SizedBox(height: 32),

          // ── Sección: Transacciones ────────────────────────────────────
          _buildTransactionsSection(),
          const SizedBox(height: 32),

          // ── Sección: Cotizaciones ─────────────────────────────────────
          _buildQuotesSection(),
          const SizedBox(height: 32),

          // ── Sección: Cuentas (no disponible) ─────────────────────────
          _buildAccountsSection(),
          const SizedBox(height: 32),

          // ── Sección: Bitácora / Tareas ────────────────────────────────
          _buildTasksSection(),
          const SizedBox(height: 32),

          // ── Sección: Presupuesto (no disponible) ─────────────────────
          _buildBudgetSection(),
        ],
      ),
    );
  }

  Widget _buildProjectHeader(Project p) {
    final statusColors = <String, Color>{
      'active': AppTheme.colorExito,
      'paused': AppTheme.colorAdvertencia,
      'completed': AppTheme.colorTextoSecundario,
    };
    final statusColor = statusColors[p.status] ?? AppTheme.colorTextoSecundario;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Dot de color del proyecto
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: p.displayColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.name,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.colorTexto,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    p.clientName,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      p.statusLabel,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (p.description != null && p.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  p.description!,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.colorTextoSecundario,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Ingresos',
            value: _formatMxn(_income),
            icon: Icons.arrow_downward_outlined,
            valueColor: AppTheme.colorExito,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Egresos',
            value: _formatMxn(_expense),
            icon: Icons.arrow_upward_outlined,
            valueColor: AppTheme.colorError,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Balance',
            value: _formatMxn(_balance),
            icon: Icons.account_balance_wallet_outlined,
            valueColor: _balance >= 0 ? AppTheme.colorExito : AppTheme.colorError,
          ),
        ),
      ],
    );
  }

  // ── Transacciones ─────────────────────────────────────────────────────────

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Transacciones',
          actionLabel: '+ Agregar transacción',
          onAction: () => _showAddTransactionDialog(),
        ),
        if (_transactions.isEmpty)
          EmptyState(
            icon: Icons.swap_vert,
            title: 'Sin transacciones',
            subtitle: 'Agrega la primera transacción de este proyecto',
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colorCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              boxShadow: AppTheme.sombraCard,
            ),
            child: Column(
              children: _transactions
                  .map((t) => _TxRow(t: t, formatDate: _formatDate))
                  .toList(),
            ),
          ),
      ],
    );
  }

  void _showAddTransactionDialog() {
    // TODO: Implementar form de transacción con proyecto pre-seleccionado
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función disponible en el módulo de Transacciones')),
    );
  }

  // ── Cotizaciones ──────────────────────────────────────────────────────────

  Widget _buildQuotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Cotizaciones internas',
          actionLabel: '+ Nueva cotización',
          onAction: () {
            // TODO: Form de cotización
          },
        ),
        if (_quotes.isEmpty)
          const EmptyState(
            icon: Icons.description_outlined,
            title: 'Sin cotizaciones',
            subtitle: 'No hay cotizaciones vinculadas a este proyecto',
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colorCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              boxShadow: AppTheme.sombraCard,
            ),
            child: Column(
              children: _quotes.map((q) => _QuoteRow(quote: q)).toList(),
            ),
          ),
      ],
    );
  }

  // ── Cuentas (sin endpoint) ────────────────────────────────────────────────

  Widget _buildAccountsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionHeader(title: 'Cuentas por cobrar / pagar'),
        EmptyState(
          icon: Icons.account_balance_outlined,
          title: 'No disponible por proyecto',
          // TODO: Endpoint GET /api/mobile/accounts no existe.
          // Account model no tiene project_id. Pendiente de implementar en backend.
          subtitle: 'Las cuentas se gestionan desde el módulo global de Cuentas',
        ),
      ],
    );
  }

  // ── Tareas / Bitácora ─────────────────────────────────────────────────────

  Widget _buildTasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Bitácora / Tareas',
          actionLabel: '+ Nueva tarea',
          onAction: () => _showAddTaskDialog(),
        ),
        if (_tasks.isEmpty)
          const EmptyState(
            icon: Icons.assignment_outlined,
            title: 'Sin tareas',
            subtitle: 'No hay tareas registradas en este proyecto',
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colorCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              boxShadow: AppTheme.sombraCard,
            ),
            child: Column(
              children: _tasks
                  .map((t) => _TaskRow(
                        task: t,
                        formatDate: _formatDate,
                        onToggle: (val) => _toggleTask(t, val),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Future<void> _toggleTask(Task task, bool newValue) async {
    // Actualización optimista en UI
    setState(() {
      _tasks = _tasks.map((t) => t.id == task.id
          ? Task(
              id: t.id,
              fecha: t.fecha,
              descripcion: t.descripcion,
              completada: newValue,
              proyectoId: t.proyectoId,
              notas: t.notas,
            )
          : t).toList();
    });
    try {
      final api = context.read<ApiService>();
      await api.put('/api/mobile/tasks/${task.id}', {'completada': newValue});
      final repo = context.read<LocalRepository>();
      final updated = Task(
        id: task.id,
        fecha: task.fecha,
        descripcion: task.descripcion,
        completada: newValue,
        proyectoId: task.proyectoId,
        notas: task.notas,
      );
      repo.upsertTask(updated);
    } on ApiOfflineException {
      final repo = context.read<LocalRepository>();
      await repo.addPendingOp(
        entityType: 'task',
        operation: 'update',
        entityId: task.id,
        endpoint: '/api/mobile/tasks/${task.id}',
        payload: jsonEncode({'completada': newValue}),
      );
      repo.upsertTask(Task(
        id: task.id,
        fecha: task.fecha,
        descripcion: task.descripcion,
        completada: newValue,
        proyectoId: task.proyectoId,
        notas: task.notas,
      ));
      SyncToast.show(context, 'Tarea guardada localmente. Se sincronizará al reconectar.');
    } catch (_) {}
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (ctx) => _AddTaskDialog(
        projectId: widget.projectId,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadData();
        },
      ),
    );
  }

  // ── Presupuesto (sin filtro por proyecto) ─────────────────────────────────

  Widget _buildBudgetSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        SectionHeader(title: 'Presupuesto'),
        EmptyState(
          icon: Icons.savings_outlined,
          title: 'No disponible por proyecto',
          // TODO: GET /api/mobile/budgets/status no acepta filtro por proyecto.
          // Pendiente de agregar soporte de project_id en el backend.
          subtitle: 'Los presupuestos se gestionan desde el módulo global de Presupuestos',
        ),
      ],
    );
  }
}

// ── Fila de transacción ───────────────────────────────────────────────────────

class _TxRow extends StatelessWidget {
  final Transaction t;
  final String Function(String) formatDate;

  const _TxRow({required this.t, required this.formatDate});

  @override
  Widget build(BuildContext context) {
    final isIncome = t.isIncome;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color:
                  (isIncome ? AppTheme.colorExito : AppTheme.colorError).withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_outlined
                  : Icons.arrow_upward_outlined,
              size: 14,
              color: isIncome ? AppTheme.colorExito : AppTheme.colorError,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description.isNotEmpty ? t.description : (t.categoryName ?? ''),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTexto,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (t.categoryName != null)
                  Text(
                    t.categoryName!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            formatDate(t.transactionDate),
            style: GoogleFonts.inter(
                fontSize: 11, color: AppTheme.colorTextoSecundario),
          ),
          const SizedBox(width: 12),
          Text(
            '${isIncome ? '+' : '-'}\$${t.amountMxn.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isIncome ? AppTheme.colorExito : AppTheme.colorError,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fila de cotización ────────────────────────────────────────────────────────

class _QuoteRow extends StatelessWidget {
  final Quote quote;

  const _QuoteRow({required this.quote});

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

  @override
  Widget build(BuildContext context) {
    final q = quote;
    final statusColor = _statusColor(q.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined,
              size: 18, color: AppTheme.colorTextoSecundario),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              q.description ?? 'Sin descripción',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppTheme.colorTexto,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusColor.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              q.statusLabel,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${q.amountMxn.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppTheme.colorTexto,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fila de tarea ─────────────────────────────────────────────────────────────

class _TaskRow extends StatelessWidget {
  final Task task;
  final String Function(String) formatDate;
  final ValueChanged<bool> onToggle;

  const _TaskRow({
    required this.task,
    required this.formatDate,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: task.completada,
            onChanged: (v) => onToggle(v ?? false),
            activeColor: AppTheme.colorExito,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.descripcion,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: task.completada
                        ? AppTheme.colorTextoSecundario
                        : AppTheme.colorTexto,
                    decoration:
                        task.completada ? TextDecoration.lineThrough : null,
                  ),
                ),
                if (task.notas != null && task.notas!.isNotEmpty)
                  Text(
                    task.notas!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
              ],
            ),
          ),
          Text(
            formatDate(task.fecha),
            style: GoogleFonts.inter(
                fontSize: 11, color: AppTheme.colorTextoSecundario),
          ),
        ],
      ),
    );
  }
}

// ── Diálogo: Nueva tarea ──────────────────────────────────────────────────────

class _AddTaskDialog extends StatefulWidget {
  final int projectId;
  final VoidCallback onSaved;

  const _AddTaskDialog({required this.projectId, required this.onSaved});

  @override
  State<_AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<_AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _descController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDisplay(DateTime d) =>
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
    final taskBody = {
      'descripcion': _descController.text.trim(),
      'fecha': _date.toIso8601String().substring(0, 10),
      'proyecto_id': widget.projectId,
      if (_notesController.text.isNotEmpty) 'notas': _notesController.text.trim(),
    };
    try {
      final api = context.read<ApiService>();
      await api.post('/api/mobile/tasks', taskBody);
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      if (!mounted) return;
      final repo = context.read<LocalRepository>();
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      await repo.addPendingOp(
        entityType: 'task',
        operation: 'create',
        tempId: tempId,
        endpoint: '/api/mobile/tasks',
        payload: jsonEncode(taskBody),
      );
      repo.upsertTask(Task(
        id: tempId,
        fecha: _date.toIso8601String().substring(0, 10),
        descripcion: _descController.text.trim(),
        completada: false,
        proyectoId: widget.projectId,
        notas: _notesController.text.isEmpty ? null : _notesController.text.trim(),
      ));
      SyncToast.show(context, 'Tarea guardada localmente. Se sincronizará al reconectar.');
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo guardar la tarea.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nueva tarea',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  child: Text(_formatDisplay(_date),
                      style: GoogleFonts.inter(fontSize: 14)),
                ),
              ),
              const SizedBox(height: 12),
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
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
