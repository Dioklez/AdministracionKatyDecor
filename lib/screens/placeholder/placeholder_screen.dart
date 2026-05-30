import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorFondo,
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
            color: AppTheme.colorFondo,
            child: Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Contenido centrado ─────────────────────────────────────────
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 80,
                    color: AppTheme.colorPrimario.withAlpha(77),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorTexto,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Próximamente',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.colorPrimario.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Este módulo estará disponible próximamente',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.colorPrimario,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
