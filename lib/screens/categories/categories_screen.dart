import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/category_service.dart';
import '../../models/category_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> _categories = [];
  bool _loadingList = true;
  String? _listError;
  String? _selectedId;

  String _typeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() { _loadingList = true; _listError = null; });
    try {
      final cats = await CategoryService().getAll();
      if (!mounted) return;
      setState(() { _categories = cats; _loadingList = false; });
    } catch (_) {
      if (mounted) setState(() { _listError = 'No se pudieron cargar las categorías.'; _loadingList = false; });
    }
  }

  List<Category> get _filtered {
    if (_typeFilter == 'all') return _categories;
    return _categories.where((c) => c.type == _typeFilter).toList();
  }

  Category? get _selected =>
      _selectedId == null ? null : _categories.where((c) => c.id == _selectedId).firstOrNull;

  Color _parseColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
    } catch (_) {}
    return AppTheme.colorPrimario;
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'ingreso': return 'Ingreso';
      case 'egreso': return 'Egreso';
      default: return 'Ambos';
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'ingreso': return AppTheme.colorExito;
      case 'egreso': return AppTheme.colorError;
      default: return AppTheme.colorPrimario;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorFondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
            child: Row(
              children: [
                Text(
                  'Categorías',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nueva categoría'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 300, child: _buildLeftPanel()),
                const VerticalDivider(width: 1),
                Expanded(child: _buildRightPanel()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Panel izquierdo ───────────────────────────────────────────────────────

  Widget _buildLeftPanel() {
    final filtered = _filtered;
    return Column(
      children: [
        _buildTypeFilter(),
        const Divider(height: 1),
        Expanded(
          child: _loadingList
              ? _buildShimmer()
              : _listError != null
                  ? Center(child: Text(_listError!, style: GoogleFonts.inter(color: AppTheme.colorTextoSecundario)))
                  : filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.label_outlined,
                          title: 'Sin categorías',
                          subtitle: 'Crea tu primera categoría',
                          actionLabel: 'Nueva categoría',
                          onAction: _showDialog,
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (_, i) => _CategoryTile(
                            category: filtered[i],
                            selected: _selectedId == filtered[i].id,
                            parseColor: _parseColor,
                            typeLabel: _typeLabel,
                            typeColor: _typeColor,
                            onTap: () => setState(() => _selectedId = filtered[i].id),
                            onEdit: () => _showDialog(edit: filtered[i]),
                            onDelete: () => _confirmDelete(filtered[i]),
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _TabBtn(label: 'Todas', selected: _typeFilter == 'all', onTap: () => setState(() => _typeFilter = 'all')),
          const SizedBox(width: 6),
          _TabBtn(label: 'Ingreso', selected: _typeFilter == 'ingreso', color: AppTheme.colorExito, onTap: () => setState(() => _typeFilter = 'ingreso')),
          const SizedBox(width: 6),
          _TabBtn(label: 'Egreso', selected: _typeFilter == 'egreso', color: AppTheme.colorError, onTap: () => setState(() => _typeFilter = 'egreso')),
          const SizedBox(width: 6),
          _TabBtn(label: 'Ambos', selected: _typeFilter == 'ambos', onTap: () => setState(() => _typeFilter = 'ambos')),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, i) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(children: [
          ShimmerBox(width: 12, height: 12, borderRadius: 6),
          SizedBox(width: 10),
          Expanded(child: ShimmerBox(height: 13)),
          SizedBox(width: 10),
          ShimmerBox(width: 52, height: 18, borderRadius: 9),
        ]),
      ),
    );
  }

  // ── Panel derecho ─────────────────────────────────────────────────────────

  Widget _buildRightPanel() {
    final cat = _selected;
    if (cat == null) {
      return const EmptyState(
        icon: Icons.label_outlined,
        title: 'Selecciona una categoría',
        subtitle: 'Haz clic en una categoría para ver su detalle',
      );
    }

    final color = _parseColor(cat.color);
    final typeColor = _typeColor(cat.type);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.colorCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          boxShadow: AppTheme.sombraCard,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    cat.name,
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, color: AppTheme.colorTexto),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _typeLabel(cat.type),
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: typeColor),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, size: 18, color: AppTheme.colorTextoSecundario),
                  onSelected: (v) {
                    if (v == 'edit') _showDialog(edit: cat);
                    if (v == 'delete') _confirmDelete(cat);
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar')),
                    PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (cat.color.isNotEmpty) ...[
              Text('Color', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.colorTextoSecundario)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppTheme.colorBorde),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    cat.color.isNotEmpty ? cat.color : '—',
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppTheme.colorTexto),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Acciones ──────────────────────────────────────────────────────────────

  void _showDialog({Category? edit}) {
    showDialog(
      context: context,
      builder: (ctx) => _CategoryDialog(
        editCategory: edit,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadCategories();
        },
      ),
    );
  }

  Future<void> _confirmDelete(Category cat) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${cat.name}"?',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Esta acción no se puede deshacer.', style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await CategoryService().delete(cat.id);
        if (mounted) {
          setState(() { if (_selectedId == cat.id) _selectedId = null; });
          _loadCategories();
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar la categoría.')),
          );
        }
      }
    }
  }
}

// ── Tab button ────────────────────────────────────────────────────────────────

class _TabBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _TabBtn({required this.label, required this.selected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.colorPrimario;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? c.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? c : AppTheme.colorBorde, width: selected ? 1.5 : 1),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? c : AppTheme.colorTextoSecundario,
          ),
        ),
      ),
    );
  }
}

// ── Tile de categoría ─────────────────────────────────────────────────────────

class _CategoryTile extends StatefulWidget {
  final Category category;
  final bool selected;
  final Color Function(String) parseColor;
  final String Function(String) typeLabel;
  final Color Function(String) typeColor;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryTile({
    required this.category,
    required this.selected,
    required this.parseColor,
    required this.typeLabel,
    required this.typeColor,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final dotColor = widget.parseColor(cat.color);
    final tc = widget.typeColor(cat.type);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.fromLTRB(16, 10, 4, 10),
          decoration: BoxDecoration(
            color: widget.selected
                ? AppTheme.colorPrimario.withAlpha(20)
                : _hovered ? AppTheme.colorHover : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: widget.selected ? AppTheme.colorPrimario : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  cat.name,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: widget.selected ? AppTheme.colorPrimario : AppTheme.colorTexto,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: tc.withAlpha(20),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.typeLabel(cat.type),
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: tc),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, size: 16, color: AppTheme.colorTextoSecundario),
                onSelected: (v) {
                  if (v == 'edit') widget.onEdit();
                  if (v == 'delete') widget.onDelete();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Dialog crear / editar ─────────────────────────────────────────────────────

class _CategoryDialog extends StatefulWidget {
  final Category? editCategory;
  final VoidCallback onSaved;

  const _CategoryDialog({this.editCategory, required this.onSaved});

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _colorController;
  String _type = 'egreso';
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editCategory != null;

  @override
  void initState() {
    super.initState();
    final c = widget.editCategory;
    _nameController = TextEditingController(text: c?.name ?? '');
    _colorController = TextEditingController(text: c?.color ?? '');
    if (c != null) {
      _type = ['ingreso', 'egreso', 'ambos'].contains(c.type) ? c.type : 'egreso';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _saving = true; _error = null; });
    try {
      final svc = CategoryService();
      if (_isEditing) {
        await svc.update(widget.editCategory!.id, {
          'name': _nameController.text.trim(),
          'type': _type,
          'color': _colorController.text.trim(),
        });
      } else {
        await svc.create(
          _nameController.text.trim(),
          _type,
          _colorController.text.trim(),
        );
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) setState(() { _error = 'No se pudo guardar la categoría.'; _saving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar categoría' : 'Nueva categoría',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 380,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Tipo *'),
                  items: const [
                    DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                    DropdownMenuItem(value: 'egreso', child: Text('Egreso')),
                    DropdownMenuItem(value: 'ambos', child: Text('Ambos')),
                  ],
                  onChanged: (v) { if (v != null) setState(() => _type = v); },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _colorController,
                  decoration: const InputDecoration(
                    labelText: 'Color (opcional)',
                    hintText: '#FF5733',
                    prefixIcon: Icon(Icons.palette_outlined, size: 18),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!, style: GoogleFonts.inter(color: AppTheme.colorError, fontSize: 13)),
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
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Text(_isEditing ? 'Guardar cambios' : 'Crear categoría'),
        ),
      ],
    );
  }
}
