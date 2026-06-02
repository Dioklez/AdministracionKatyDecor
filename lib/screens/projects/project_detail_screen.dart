import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/project_model.dart';
import '../../models/transaction_model.dart';
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

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final txns = await TransactionService().getByProject(widget.project.id);
      if (mounted) setState(() { _transactions = txns; _loadingTxns = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingTxns = false);
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
