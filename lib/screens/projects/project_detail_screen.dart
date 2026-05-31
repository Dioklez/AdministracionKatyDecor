import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/project_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class ProjectDetailScreen extends StatelessWidget {
  final Project project;

  const ProjectDetailScreen({super.key, required this.project});

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
            _buildPendingSection(
              title: 'Transacciones',
              icon: Icons.swap_vert,
              subtitle: 'Se mostrará cuando se migre el módulo de Transacciones',
            ),
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
    return project.clientPhone != null ||
        project.startDate != null ||
        project.endDate != null ||
        project.budget != null ||
        project.notes != null;
  }

  Widget _buildProjectHeader() {
    final statusColors = <String, Color>{
      'active': AppTheme.colorExito,
      'paused': AppTheme.colorAdvertencia,
      'completed': AppTheme.colorTextoSecundario,
    };
    final statusColor =
        statusColors[project.status] ?? AppTheme.colorTextoSecundario;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 16,
          height: 16,
          margin: const EdgeInsets.only(top: 6),
          decoration: BoxDecoration(
            color: project.displayColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.name,
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
                    project.clientName,
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
                      project.statusLabel,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              if (project.description != null &&
                  project.description!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  project.description!,
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
            value: _formatMxn(project.totalIncome),
            icon: Icons.arrow_downward_outlined,
            valueColor: AppTheme.colorExito,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Egresos',
            value: _formatMxn(project.totalExpense),
            icon: Icons.arrow_upward_outlined,
            valueColor: AppTheme.colorError,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Balance',
            value: _formatMxn(project.balance),
            icon: Icons.account_balance_wallet_outlined,
            valueColor: project.balance >= 0
                ? AppTheme.colorExito
                : AppTheme.colorError,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection() {
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
          if (project.clientPhone != null)
            _InfoChip(
              icon: Icons.phone_outlined,
              label: 'Teléfono',
              value: project.clientPhone!,
            ),
          if (project.startDate != null)
            _InfoChip(
              icon: Icons.calendar_today_outlined,
              label: 'Inicio',
              value: _formatDate(project.startDate!),
            ),
          if (project.endDate != null)
            _InfoChip(
              icon: Icons.event_outlined,
              label: 'Fin',
              value: _formatDate(project.endDate!),
            ),
          if (project.budget != null)
            _InfoChip(
              icon: Icons.savings_outlined,
              label: 'Presupuesto',
              value: _formatMxn(project.budget!),
            ),
          if (project.notes != null)
            _InfoChip(
              icon: Icons.notes_outlined,
              label: 'Notas',
              value: project.notes!,
            ),
        ],
      ),
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

// ── Chip de información ───────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

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
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppTheme.colorTextoSecundario,
              ),
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
