import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final bool? trendUp; // null = neutro (proyectos activos)
  final Color? valueColor;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.trendUp,
    this.valueColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final Color efectivoColor = valueColor ??
        (trendUp == null
            ? AppTheme.colorTexto
            : trendUp!
                ? AppTheme.colorExito
                : AppTheme.colorError);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Encabezado: ícono + título ─────────────────────────────────
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.colorPrimario.withAlpha(26),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 18, color: AppTheme.colorPrimario),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTextoSecundario,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Valor principal ────────────────────────────────────────────
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: AppTheme.tamanoNumero,
              fontWeight: FontWeight.w700,
              color: efectivoColor,
            ),
          ),

          // ── Indicador de tendencia ─────────────────────────────────────
          if (trendUp != null || subtitle != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                if (trendUp != null) ...[
                  Icon(
                    trendUp! ? Icons.trending_up : Icons.trending_down,
                    size: 14,
                    color: trendUp! ? AppTheme.colorExito : AppTheme.colorError,
                  ),
                  const SizedBox(width: 4),
                ],
                Expanded(
                  child: Text(
                    subtitle ?? (trendUp != null ? 'Este mes' : ''),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.colorTextoSecundario,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
