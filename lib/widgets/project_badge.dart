import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ProjectBadge extends StatelessWidget {
  final String projectName;
  final String? colorHex;

  const ProjectBadge({
    super.key,
    required this.projectName,
    this.colorHex,
  });

  Color _parseColor() {
    if (colorHex != null && colorHex!.startsWith('#') && colorHex!.length == 7) {
      try {
        return Color(int.parse('FF${colorHex!.substring(1)}', radix: 16));
      } catch (_) {}
    }
    return AppTheme.colorTextoSecundario;
  }

  @override
  Widget build(BuildContext context) {
    final color = _parseColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        projectName,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
