import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/connectivity_service.dart';
import '../../theme/app_theme.dart';
import '../login/login_screen.dart';

class SidebarItem {
  final IconData icon;
  final String label;
  final int index;

  const SidebarItem({
    required this.icon,
    required this.label,
    required this.index,
  });
}

class SidebarSection {
  final String title;
  final List<SidebarItem> items;

  const SidebarSection({required this.title, required this.items});
}

const List<SidebarSection> _sections = [
  SidebarSection(
    title: 'GENERAL',
    items: [
      SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard', index: 0),
      SidebarItem(icon: Icons.swap_vert, label: 'Transacciones', index: 1),
      SidebarItem(icon: Icons.folder_outlined, label: 'Proyectos', index: 2),
      SidebarItem(icon: Icons.assignment_outlined, label: 'Bitácora', index: 3),
      SidebarItem(icon: Icons.label_outlined, label: 'Categorías', index: 12),
    ],
  ),
  SidebarSection(
    title: 'REPORTES',
    items: [
      SidebarItem(icon: Icons.bar_chart_outlined, label: 'Reportes', index: 4),
    ],
  ),
  SidebarSection(
    title: 'DOCUMENTOS',
    items: [
      SidebarItem(icon: Icons.description_outlined, label: 'Cotizaciones', index: 5),
      SidebarItem(icon: Icons.store_outlined, label: 'Proveedores', index: 6),
      SidebarItem(icon: Icons.inventory_outlined, label: 'Inventario', index: 7),
      SidebarItem(icon: Icons.account_balance_outlined, label: 'Cuentas', index: 8),
      SidebarItem(icon: Icons.savings_outlined, label: 'Presupuestos', index: 9),
      SidebarItem(icon: Icons.receipt_long_outlined, label: 'Remisiones', index: 10),
    ],
  ),
];

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelectIndex;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onSelectIndex,
  });

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isOnline = context.watch<ConnectivityService>().isOnline;

    return Container(
      width: 220,
      decoration: const BoxDecoration(
        color: AppTheme.colorSidebar,
        border: Border(
          right: BorderSide(color: AppTheme.colorBorde, width: 1),
        ),
      ),
      child: Column(
        children: [
          // ── Logo / Marca ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppTheme.colorPrimario,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'K',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KatyDecor',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colorTexto,
                      ),
                    ),
                    Text(
                      'Admin',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.colorTextoSecundario,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 8),

          // ── Secciones ──────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              children: [
                for (final section in _sections) ...[
                  _SectionLabel(title: section.title),
                  const SizedBox(height: 2),
                  for (final item in section.items)
                    _SidebarItemTile(
                      item: item,
                      isSelected: selectedIndex == item.index,
                      onTap: () => onSelectIndex(item.index),
                    ),
                  const SizedBox(height: 8),
                ],
              ],
            ),
          ),

          // ── Usuario + estado + logout ───────────────────────────────────
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    // Avatar
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.colorPrimario.withAlpha(26),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (auth.username?.isNotEmpty == true)
                              ? auth.username![0].toUpperCase()
                              : 'U',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.colorPrimario,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auth.username ?? 'Usuario',
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.colorTexto,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: BoxDecoration(
                                  color: isOnline
                                      ? AppTheme.colorExito
                                      : AppTheme.colorError,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                isOnline ? 'En línea' : 'Sin conexión',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: AppTheme.colorTextoSecundario,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Logout
                    IconButton(
                      icon: const Icon(
                        Icons.logout_outlined,
                        size: 18,
                        color: AppTheme.colorTextoSecundario,
                      ),
                      tooltip: 'Cerrar sesión',
                      onPressed: () async {
                        await context.read<AuthService>().logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (_) => const LoginScreen()),
                            (_) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Label de sección ──────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String title;

  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: AppTheme.tamanoLabelSeccion,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppTheme.colorTextoSecundario,
        ),
      ),
    );
  }
}

// ── Item del sidebar ──────────────────────────────────────────────────────────

class _SidebarItemTile extends StatefulWidget {
  final SidebarItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItemTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarItemTile> createState() => _SidebarItemTileState();
}

class _SidebarItemTileState extends State<_SidebarItemTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isSelected;
    final showHighlight = isActive || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(vertical: 1),
          height: 36,
          decoration: BoxDecoration(
            color: showHighlight ? AppTheme.colorHover : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.radiusSidebarItem),
            border: isActive
                ? const Border(
                    left: BorderSide(color: AppTheme.colorPrimario, width: 3),
                  )
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(isActive ? 9 : 12, 0, 12, 0),
            child: Row(
              children: [
                Icon(
                  widget.item.icon,
                  size: 17,
                  color: isActive
                      ? AppTheme.colorPrimario
                      : AppTheme.colorTextoSecundario,
                ),
                const SizedBox(width: 10),
                Text(
                  widget.item.label,
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoItemSidebar,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? AppTheme.colorPrimario
                        : AppTheme.colorTexto,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
