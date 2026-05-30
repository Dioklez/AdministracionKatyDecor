import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Paleta de colores ─────────────────────────────────────────────────────
  static const Color colorPrimario = Color(0xFF8B6914);
  static const Color colorSecundario = Color(0xFF3D2B1A);
  static const Color colorFondo = Color(0xFFF5F5F7);
  static const Color colorCard = Color(0xFFFFFFFF);
  static const Color colorSidebar = Color(0xFFFFFFFF);
  static const Color colorTexto = Color(0xFF1D1D1F);
  static const Color colorTextoSecundario = Color(0xFF6E6E73);
  static const Color colorBorde = Color(0xFFE5E5EA);
  static const Color colorHover = Color(0xFFF5F0E8);
  static const Color colorExito = Color(0xFF34C759);
  static const Color colorError = Color(0xFFFF3B30);
  static const Color colorAdvertencia = Color(0xFFFF9500);

  // ── Sombras ───────────────────────────────────────────────────────────────
  static const List<BoxShadow> sombraCard = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> sombraMedia = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  // ── Radio de bordes ───────────────────────────────────────────────────────
  static const double radiusCard = 12.0;
  static const double radiusBoton = 8.0;
  static const double radiusInput = 8.0;
  static const double radiusSidebarItem = 8.0;

  // ── Tamaños tipográficos ──────────────────────────────────────────────────
  static const double tamanoTituloPagina = 24.0;
  static const double tamanoLabelSeccion = 11.0;
  static const double tamanoItemSidebar = 14.0;
  static const double tamanoBody = 14.0;
  static const double tamanoNumero = 28.0;

  // ── ThemeData principal ───────────────────────────────────────────────────
  static ThemeData get themeData {
    final textTheme = GoogleFonts.interTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: tamanoNumero,
          fontWeight: FontWeight.w700,
          color: colorTexto,
        ),
        headlineMedium: TextStyle(
          fontSize: tamanoTituloPagina,
          fontWeight: FontWeight.w600,
          color: colorTexto,
        ),
        bodyLarge: TextStyle(
          fontSize: tamanoBody,
          fontWeight: FontWeight.w400,
          color: colorTexto,
        ),
        bodyMedium: TextStyle(
          fontSize: tamanoBody,
          fontWeight: FontWeight.w400,
          color: colorTextoSecundario,
        ),
        labelLarge: TextStyle(
          fontSize: tamanoItemSidebar,
          fontWeight: FontWeight.w500,
          color: colorTexto,
        ),
        labelSmall: TextStyle(
          fontSize: tamanoLabelSeccion,
          fontWeight: FontWeight.w600,
          color: colorTextoSecundario,
          letterSpacing: 0.8,
        ),
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colorFondo,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colorPrimario,
        brightness: Brightness.light,
        primary: colorPrimario,
        secondary: colorSecundario,
        surface: colorCard,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: colorTexto,
      ),
      textTheme: textTheme,
      // Botones primarios
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorPrimario,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBoton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          textStyle: GoogleFonts.inter(
            fontSize: tamanoBody,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Botones secundarios (outlined)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorPrimario,
          side: const BorderSide(color: colorPrimario),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusBoton),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: tamanoBody,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorCard,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: colorBorde),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: colorBorde),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: colorPrimario, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: colorError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusInput),
          borderSide: const BorderSide(color: colorError, width: 1.5),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: tamanoBody,
          color: colorTextoSecundario,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: tamanoBody,
          color: colorTextoSecundario,
        ),
      ),
      // Dividers
      dividerTheme: const DividerThemeData(
        color: colorBorde,
        thickness: 1,
        space: 1,
      ),
      // Cards
      cardTheme: CardThemeData(
        color: colorCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusCard),
        ),
        margin: EdgeInsets.zero,
      ),
    );
  }
}
