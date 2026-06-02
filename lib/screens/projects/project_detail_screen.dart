import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../database/local_repository.dart';
import '../../models/project_model.dart';
import '../../models/project_stage_model.dart';
import '../../models/transaction_model.dart';
import '../../services/project_stage_service.dart';
import '../../services/transaction_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  List<Transaction> _transactions = [];
  bool _loadingTxns = true;

  List<ProjectStage> _stages = [];
  bool _loadingStages = true;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadStages();
  }

  Future<void> _loadTransactions() async {
    try {
      final repo = context.read<LocalRepository>();
      final txns = await TransactionService(repo: repo).getByProject(widget.project.id);
      if (mounted) setState(() { _transactions = txns; _loadingTxns = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingTxns = false);
    }
  }

  Future<void> _loadStages() async {
    try {
      final repo = context.read<LocalRepository>();
      final stages = await ProjectStageService(repo: repo).getByProject(widget.project.id);
      if (mounted) setState(() { _stages = stages; _loadingStages = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingStages = false);
    }
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
    return value < 0 ? '-$formatted' : formatted;
  }

  String _formatDate(String date) {
    if (date.length >= 10) {
      final parts = date.substring(0, 10).split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  void _openStageDialog({ProjectStage? stage}) {
    showDialog(
      context: context,
      builder: (_) => _StageDialog(
        projectId: widget.project.id,
        stage: stage,
        onSaved: _loadStages,
      ),
    );
  }

  Future<void> _deleteStage(ProjectStage stage) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Eliminar etapa', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        content: Text('¿Eliminar "${stage.name}"? Esta acción no se puede deshacer.',
            style: GoogleFonts.inter()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await ProjectStageService().delete(stage.id);
      _loadStages();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar: $e'), backgroundColor: AppTheme.colorError),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.colorFondo,
      body: SingleChildScrollView(
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
            _buildProjectHeader(),
            const SizedBox(height: 24),

            // ── Stat cards ────────────────────────────────────────────────
            _buildStatCards(),
            const SizedBox(height: 24),

            // ── Info adicional ────────────────────────────────────────────
            if (_hasAdditionalInfo()) ...[
              _buildInfoSection(),
              const SizedBox(height: 32),
            ],

            // ── Sección: Etapas ───────────────────────────────────────────
            _buildStagesSection(),
            const SizedBox(height: 32),

            // ── Sección: Transacciones ────────────────────────────────────
            _buildTransactionsSection(),
            const SizedBox(height: 32),

            // ── Sección: Cotizaciones ─────────────────────────────────────
            _buildPendingSection(
              title: 'Cotizaciones internas',
              icon: Icons.description_outlined,
              subtitle: 'Se mostrará cuando se migre el módulo de Cotizaciones',
            ),
            const SizedBox(height: 32),

            // ── Sección: Tareas ───────────────────────────────────────────
            _buildPendingSection(
              title: 'Bitácora / Tareas',
              icon: Icons.assignment_outlined,
              subtitle: 'Se mostrará cuando se migre el módulo de Tareas',
            ),
          ],
        ),
      ),
    );
  }

  bool _hasAdditionalInfo() {
    return widget.project.clientPhone != null ||
        widget.project.startDate != null ||
        widget.project.endDate != null ||
        widget.project.budget != null ||
        widget.project.notes != null;
  }

  Widget _buildProjectHeader() {
    final p = widget.project;
    final statusColors = <String, Color>{
      'activo': AppTheme.colorExito,
      'pausado': AppTheme.colorAdvertencia,
      'completado': AppTheme.colorTextoSecundario,
      'cancelado': AppTheme.colorError,
    };
    final statusColor = statusColors[p.status] ?? AppTheme.colorTextoSecundario;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
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
    final p = widget.project;
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Ingresos',
            value: _formatMxn(p.totalIncome),
            icon: Icons.arrow_downward_outlined,
            valueColor: AppTheme.colorExito,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Egresos',
            value: _formatMxn(p.totalExpense),
            icon: Icons.arrow_upward_outlined,
            valueColor: AppTheme.colorError,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Balance',
            value: _formatMxn(p.balance),
            icon: Icons.account_balance_wallet_outlined,
            valueColor: p.balance >= 0 ? AppTheme.colorExito : AppTheme.colorError,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
    final p = widget.project;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Wrap(
        spacing: 32,
        runSpacing: 12,
        children: [
          if (p.clientPhone != null)
            _InfoChip(icon: Icons.phone_outlined, label: 'Teléfono', value: p.clientPhone!),
          if (p.startDate != null)
            _InfoChip(icon: Icons.calendar_today_outlined, label: 'Inicio', value: _formatDate(p.startDate!)),
          if (p.endDate != null)
            _InfoChip(icon: Icons.event_outlined, label: 'Fin', value: _formatDate(p.endDate!)),
          if (p.budget != null)
            _InfoChip(icon: Icons.savings_outlined, label: 'Presupuesto', value: _formatMxn(p.budget!)),
          if (p.notes != null)
            _InfoChip(icon: Icons.notes_outlined, label: 'Notas', value: p.notes!),
        ],
      ),
    );
  }

  Widget _buildStagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con botón
        Row(
          children: [
            Expanded(
              child: Text(
                'Etapas',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorTextoSecundario,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => _openStageDialog(),
              icon: const Icon(Icons.add, size: 15),
              label: const Text('Nueva etapa'),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.colorPrimario,
                textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (_loadingStages)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_stages.isEmpty)
          EmptyState(
            icon: Icons.timeline_outlined,
            title: 'Sin etapas',
            subtitle: 'Agrega etapas para organizar el avance del proyecto',
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppTheme.colorCard,
              borderRadius: BorderRadius.circular(AppTheme.radiusCard),
              boxShadow: AppTheme.sombraCard,
            ),
            child: Column(
              children: _stages
                  .map((s) => _StageRow(
                        stage: s,
                        formatDate: _formatDate,
                        onEdit: () => _openStageDialog(stage: s),
                        onDelete: () => _deleteStage(s),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildTransactionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Transacciones'),
        const SizedBox(height: 8),
        if (_loadingTxns)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_transactions.isEmpty)
          EmptyState(
            icon: Icons.swap_vert,
            title: 'Sin transacciones',
            subtitle: 'Este proyecto no tiene transacciones registradas',
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
                  .map((t) => _TransactionRow(transaction: t, formatMxn: _formatMxn))
                  .toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildPendingSection({
    required String title,
    required IconData icon,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: title),
        EmptyState(
          icon: icon,
          title: 'Pendiente de migración',
          subtitle: subtitle,
        ),
      ],
    );
  }
}

// ── Fila de etapa ─────────────────────────────────────────────────────────────

class _StageRow extends StatelessWidget {
  final ProjectStage stage;
  final String Function(String) formatDate;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _StageRow({
    required this.stage,
    required this.formatDate,
    required this.onEdit,
    required this.onDelete,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'en_progreso':
        return AppTheme.colorAdvertencia;
      case 'completado':
        return AppTheme.colorExito;
      default:
        return AppTheme.colorTextoSecundario;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = stage;
    final color = _statusColor(s.status);
    final isLast = false; // handled by container border

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          // Número de orden
          SizedBox(
            width: 24,
            child: Text(
              '${s.order}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.colorTextoSecundario,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          // Nombre y fechas
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTexto,
                  ),
                ),
                if (s.startDate != null || s.endDate != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (s.startDate != null)
                        Text(
                          'Inicio: ${formatDate(s.startDate!)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.colorTextoSecundario,
                          ),
                        ),
                      if (s.startDate != null && s.endDate != null)
                        const SizedBox(width: 12),
                      if (s.endDate != null)
                        Text(
                          'Fin: ${formatDate(s.endDate!)}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.colorTextoSecundario,
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Badge de status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              s.statusLabel,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Menú tres puntos
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, size: 18, color: AppTheme.colorTextoSecundario),
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  const Icon(Icons.edit_outlined, size: 16),
                  const SizedBox(width: 8),
                  Text('Editar', style: GoogleFonts.inter(fontSize: 13)),
                ]),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  Icon(Icons.delete_outline, size: 16, color: AppTheme.colorError),
                  const SizedBox(width: 8),
                  Text('Eliminar',
                      style: GoogleFonts.inter(fontSize: 13, color: AppTheme.colorError)),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Dialog de etapa ───────────────────────────────────────────────────────────

class _StageDialog extends StatefulWidget {
  final String projectId;
  final ProjectStage? stage;
  final VoidCallback onSaved;

  const _StageDialog({
    required this.projectId,
    this.stage,
    required this.onSaved,
  });

  @override
  State<_StageDialog> createState() => _StageDialogState();
}

class _StageDialogState extends State<_StageDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _orderController = TextEditingController();
  final _descController = TextEditingController();

  String _status = 'pendiente';
  DateTime? _startDate;
  DateTime? _endDate;
  bool _saving = false;

  bool get _isEditing => widget.stage != null;

  @override
  void initState() {
    super.initState();
    final s = widget.stage;
    if (s != null) {
      _nameController.text = s.name;
      _orderController.text = s.order > 0 ? '${s.order}' : '';
      _descController.text = s.description ?? '';
      _status = s.status;
      if (s.startDate != null) _startDate = DateTime.tryParse(s.startDate!);
      if (s.endDate != null) _endDate = DateTime.tryParse(s.endDate!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _orderController.dispose();
    _descController.dispose();
    super.dispose();
  }

  String _dateLabel(DateTime? d) {
    if (d == null) return 'Seleccionar';
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  String _toIso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) _startDate = picked;
      else _endDate = picked;
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final body = <String, dynamic>{
      'project': widget.projectId,
      'name': _nameController.text.trim(),
      'status': _status,
      'order': int.tryParse(_orderController.text.trim()) ?? 0,
    };
    final desc = _descController.text.trim();
    if (desc.isNotEmpty) body['description'] = desc;
    if (_startDate != null) body['start_date'] = _toIso(_startDate!);
    if (_endDate != null) body['end_date'] = _toIso(_endDate!);

    try {
      final svc = ProjectStageService();
      if (_isEditing) {
        await svc.update(widget.stage!.id, body);
      } else {
        await svc.create(body);
      }
      if (mounted) {
        Navigator.of(context).pop();
        widget.onSaved();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: AppTheme.colorError),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar etapa' : 'Nueva etapa',
        style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre *'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Requerido' : null,
              ),
              const SizedBox(height: 16),

              // Status
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Estado'),
                items: const [
                  DropdownMenuItem(value: 'pendiente', child: Text('Pendiente')),
                  DropdownMenuItem(value: 'en_progreso', child: Text('En progreso')),
                  DropdownMenuItem(value: 'completado', child: Text('Completado')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'pendiente'),
              ),
              const SizedBox(height: 16),

              // Orden
              TextFormField(
                controller: _orderController,
                decoration: const InputDecoration(labelText: 'Orden (opcional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Fechas
              Row(
                children: [
                  Expanded(
                    child: _DatePickerField(
                      label: 'Fecha inicio',
                      value: _dateLabel(_startDate),
                      onTap: () => _pickDate(isStart: true),
                      onClear: _startDate != null
                          ? () => setState(() => _startDate = null)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DatePickerField(
                      label: 'Fecha fin',
                      value: _dateLabel(_endDate),
                      onTap: () => _pickDate(isStart: false),
                      onClear: _endDate != null
                          ? () => setState(() => _endDate = null)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Descripción
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Descripción (opcional)'),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_isEditing ? 'Guardar' : 'Crear'),
        ),
      ],
    );
  }
}

// ── Campo date picker ─────────────────────────────────────────────────────────

class _DatePickerField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.colorTextoSecundario),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.colorBorde),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: value == 'Seleccionar'
                          ? AppTheme.colorTextoSecundario
                          : AppTheme.colorTexto,
                    ),
                  ),
                ),
                if (onClear != null)
                  GestureDetector(
                    onTap: onClear,
                    child: const Icon(Icons.close, size: 14, color: AppTheme.colorTextoSecundario),
                  )
                else
                  const Icon(Icons.calendar_today_outlined,
                      size: 14, color: AppTheme.colorTextoSecundario),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Fila de transacción ───────────────────────────────────────────────────────

class _TransactionRow extends StatelessWidget {
  final Transaction transaction;
  final String Function(double) formatMxn;

  const _TransactionRow({required this.transaction, required this.formatMxn});

  String _fmtDate(String date) {
    if (date.length >= 10) {
      final parts = date.substring(0, 10).split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isIncome = t.isIncome;
    final color = isIncome ? AppTheme.colorExito : AppTheme.colorError;

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
              color: color.withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward_outlined : Icons.arrow_upward_outlined,
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              t.description.isNotEmpty ? t.description : 'Sin descripción',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.colorTexto,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              isIncome ? 'Ingreso' : 'Egreso',
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: color),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _fmtDate(t.date),
            style: GoogleFonts.inter(fontSize: 11, color: AppTheme.colorTextoSecundario),
          ),
          const SizedBox(width: 12),
          Text(
            '${isIncome ? '+' : '-'}\$${t.amount.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chip de información ───────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppTheme.colorTextoSecundario),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 10, color: AppTheme.colorTextoSecundario),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.colorTexto,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
