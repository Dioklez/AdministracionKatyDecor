import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/supplier_service.dart';
import '../../services/supplier_product_service.dart';
import '../../models/supplier_model.dart';
import '../../models/supplier_product_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<Supplier> _suppliers = [];
  bool _loadingList = true;
  String? _listError;

  String? _selectedId;
  List<SupplierProduct> _products = [];
  bool _loadingProducts = false;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadSuppliers() async {
    setState(() {
      _loadingList = true;
      _listError = null;
    });
    try {
      final suppliers = await SupplierService().getAll();
      if (!mounted) return;
      setState(() {
        _suppliers = suppliers;
        _loadingList = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _listError = 'No se pudo cargar los proveedores.';
          _loadingList = false;
        });
      }
    }
  }

  void _selectSupplier(String id) {
    setState(() {
      _selectedId = id;
      _products = [];
    });
    _loadProducts(id);
  }

  Future<void> _loadProducts(String supplierId) async {
    setState(() => _loadingProducts = true);
    try {
      final products =
          await SupplierProductService().getBySupplier(supplierId);
      if (mounted) {
        setState(() {
          _products = products;
          _loadingProducts = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingProducts = false);
    }
  }

  Supplier? get _selectedSupplier =>
      _selectedId == null
          ? null
          : _suppliers.where((s) => s.id == _selectedId).firstOrNull;

  List<Supplier> get _filtered {
    if (_searchQuery.isEmpty) return _suppliers;
    final q = _searchQuery.toLowerCase();
    return _suppliers
        .where((s) =>
            s.name.toLowerCase().contains(q) ||
            (s.contactName?.toLowerCase().contains(q) ?? false) ||
            (s.phone?.contains(q) ?? false) ||
            (s.email?.toLowerCase().contains(q) ?? false))
        .toList();
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
                  'Proveedores',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showSupplierDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nuevo proveedor'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 320, child: _buildLeftPanel()),
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
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar proveedor...',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => setState(() => _searchQuery = v),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: _loadingList
              ? _buildListShimmer()
              : _listError != null
                  ? Center(
                      child: Text(_listError!,
                          style: GoogleFonts.inter(
                              color: AppTheme.colorTextoSecundario)))
                  : filtered.isEmpty
                      ? EmptyState(
                          icon: Icons.store_outlined,
                          title: _searchQuery.isEmpty
                              ? 'Sin proveedores'
                              : 'Sin resultados',
                          subtitle: _searchQuery.isEmpty
                              ? 'Crea tu primer proveedor'
                              : 'Intenta con otro término',
                          actionLabel:
                              _searchQuery.isEmpty ? 'Nuevo proveedor' : null,
                          onAction:
                              _searchQuery.isEmpty ? _showSupplierDialog : null,
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (context, i) => _SupplierTile(
                            supplier: filtered[i],
                            selected: _selectedId == filtered[i].id,
                            onTap: () => _selectSupplier(filtered[i].id),
                            onEdit: () => _showSupplierDialog(
                                editSupplier: filtered[i]),
                            onDelete: () =>
                                _confirmDeleteSupplier(filtered[i]),
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, i) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: 180, height: 14),
            SizedBox(height: 6),
            ShimmerBox(width: 120, height: 11),
          ],
        ),
      ),
    );
  }

  // ── Panel derecho ─────────────────────────────────────────────────────────

  Widget _buildRightPanel() {
    if (_selectedId == null) {
      return const EmptyState(
        icon: Icons.store_outlined,
        title: 'Selecciona un proveedor',
        subtitle: 'Haz clic en un proveedor para ver su detalle',
      );
    }
    final s = _selectedSupplier;
    if (s == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: _buildSupplierDetail(s),
    );
  }

  Widget _buildSupplierDetail(Supplier s) {
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
          Row(
            children: [
              Expanded(
                child: Text(
                  s.name,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.colorTexto,
                  ),
                ),
              ),
              if (!s.isActive)
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.colorTextoSecundario.withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Inactivo',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
                ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    size: 18, color: AppTheme.colorTextoSecundario),
                onSelected: (v) {
                  if (v == 'edit') _showSupplierDialog(editSupplier: s);
                  if (v == 'delete') _confirmDeleteSupplier(s);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              if (s.contactName != null)
                _InfoChip(
                    icon: Icons.person_outline, label: s.contactName!),
              if (s.phone != null)
                _InfoChip(icon: Icons.phone_outlined, label: s.phone!),
              if (s.email != null)
                _InfoChip(icon: Icons.email_outlined, label: s.email!),
              if (s.address != null)
                _InfoChip(
                    icon: Icons.location_on_outlined, label: s.address!),
            ],
          ),
          if (s.notes != null && s.notes!.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              s.notes!,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppTheme.colorTextoSecundario),
            ),
          ],
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Productos',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorTexto,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 14),
                label: const Text('Agregar'),
                onPressed: () => _showProductDialog(supplierId: s.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_loadingProducts)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else if (_products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Sin productos registrados.',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final p = _products[i];
                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                  title: Text(
                    p.name,
                    style: GoogleFonts.inter(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    [
                      if (p.sku != null) 'SKU: ${p.sku}',
                      if (p.unit != null) p.unit!,
                    ].join(' · '),
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppTheme.colorTextoSecundario),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$${p.price.toStringAsFixed(2)}',
                        style: GoogleFonts.inter(
                            fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            size: 16, color: AppTheme.colorTextoSecundario),
                        onSelected: (v) {
                          if (v == 'edit') {
                            _showProductDialog(
                                supplierId: s.id, editProduct: p);
                          }
                          if (v == 'delete') _confirmDeleteProduct(p);
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Editar')),
                          PopupMenuItem(
                              value: 'delete', child: Text('Eliminar')),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  // ── Diálogos ──────────────────────────────────────────────────────────────

  void _showProductDialog(
      {required String supplierId, SupplierProduct? editProduct}) {
    showDialog(
      context: context,
      builder: (ctx) => _SupplierProductDialog(
        supplierId: supplierId,
        editProduct: editProduct,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadProducts(supplierId);
        },
      ),
    );
  }

  Future<void> _confirmDeleteProduct(SupplierProduct p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${p.name}"?',
            style:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await SupplierProductService().delete(p.id);
        if (mounted) _loadProducts(p.supplierId);
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el producto.')),
          );
        }
      }
    }
  }

  void _showSupplierDialog({Supplier? editSupplier}) {
    showDialog(
      context: context,
      builder: (ctx) => _SupplierDialog(
        editSupplier: editSupplier,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadSuppliers();
        },
      ),
    );
  }

  Future<void> _confirmDeleteSupplier(Supplier s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${s.name}"?',
            style:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await SupplierService().delete(s.id);
        if (mounted) {
          setState(() {
            if (_selectedId == s.id) _selectedId = null;
          });
          _loadSuppliers();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se pudo eliminar el proveedor.')),
          );
        }
      }
    }
  }
}

// ── Tile de proveedor ─────────────────────────────────────────────────────────

class _SupplierTile extends StatefulWidget {
  final Supplier supplier;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _SupplierTile({
    required this.supplier,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_SupplierTile> createState() => _SupplierTileState();
}

class _SupplierTileState extends State<_SupplierTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.supplier;
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
                : _hovered
                    ? AppTheme.colorHover
                    : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: widget.selected
                    ? AppTheme.colorPrimario
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            s.name,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.selected
                                  ? AppTheme.colorPrimario
                                  : AppTheme.colorTexto,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!s.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.colorTextoSecundario.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Inactivo',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppTheme.colorTextoSecundario),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (s.contactName != null) s.contactName,
                        if (s.phone != null) s.phone,
                      ].whereType<String>().join(' · '),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.colorTextoSecundario,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    size: 16, color: AppTheme.colorTextoSecundario),
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

// ── Info chip ─────────────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppTheme.colorTextoSecundario),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 12, color: AppTheme.colorTextoSecundario)),
      ],
    );
  }
}

// ── Dialog: Nuevo / Editar producto de proveedor ─────────────────────────────

class _SupplierProductDialog extends StatefulWidget {
  final String supplierId;
  final SupplierProduct? editProduct;
  final VoidCallback onSaved;

  const _SupplierProductDialog({
    required this.supplierId,
    this.editProduct,
    required this.onSaved,
  });

  @override
  State<_SupplierProductDialog> createState() =>
      _SupplierProductDialogState();
}

class _SupplierProductDialogState extends State<_SupplierProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _unitController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isActive = true;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.editProduct;
    if (p != null) {
      _nameController.text = p.name;
      _skuController.text = p.sku ?? '';
      _unitController.text = p.unit ?? '';
      _priceController.text = p.price > 0 ? p.price.toString() : '';
      _descriptionController.text = p.description ?? '';
      _isActive = p.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final data = {
      'supplierId': widget.supplierId,
      'name': _nameController.text.trim(),
      'sku': _skuController.text.trim(),
      'unit': _unitController.text.trim(),
      'price': price,
      'description': _descriptionController.text.trim(),
      'isActive': _isActive,
    };
    try {
      if (_isEditing) {
        await SupplierProductService().update(widget.editProduct!.id, data);
      } else {
        await SupplierProductService().create(data);
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear el producto.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar producto' : 'Nuevo producto',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _skuController,
                        decoration: const InputDecoration(labelText: 'SKU'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _unitController,
                        decoration:
                            const InputDecoration(labelText: 'Unidad'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  decoration:
                      const InputDecoration(labelText: 'Precio (MXN)'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration:
                      const InputDecoration(labelText: 'Descripción (opcional)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Activo',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppTheme.colorTexto)),
                    const Spacer(),
                    Switch(
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                      activeThumbColor: AppTheme.colorPrimario,
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!,
                      style: GoogleFonts.inter(
                          color: AppTheme.colorError, fontSize: 13)),
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
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text(_isEditing ? 'Guardar cambios' : 'Crear producto'),
        ),
      ],
    );
  }
}

// ── Dialog: Nuevo / Editar proveedor ─────────────────────────────────────────

class _SupplierDialog extends StatefulWidget {
  final VoidCallback onSaved;
  final Supplier? editSupplier;

  const _SupplierDialog({required this.onSaved, this.editSupplier});

  @override
  State<_SupplierDialog> createState() => _SupplierDialogState();
}

class _SupplierDialogState extends State<_SupplierDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isActive = true;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editSupplier != null;

  @override
  void initState() {
    super.initState();
    final s = widget.editSupplier;
    if (s != null) {
      _nameController.text = s.name;
      _contactNameController.text = s.contactName ?? '';
      _phoneController.text = s.phone ?? '';
      _emailController.text = s.email ?? '';
      _addressController.text = s.address ?? '';
      _notesController.text = s.notes ?? '';
      _isActive = s.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final data = {
      'name': _nameController.text.trim(),
      'contactName': _contactNameController.text.trim(),
      'phone': _phoneController.text.trim(),
      'email': _emailController.text.trim(),
      'address': _addressController.text.trim(),
      'notes': _notesController.text.trim(),
      'isActive': _isActive,
    };
    try {
      if (_isEditing) {
        await SupplierService().update(widget.editSupplier!.id, data);
      } else {
        await SupplierService().create(data);
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear el proveedor.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar proveedor' : 'Nuevo proveedor',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _contactNameController,
                        decoration:
                            const InputDecoration(labelText: 'Contacto'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration:
                            const InputDecoration(labelText: 'Teléfono'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _emailController,
                        decoration:
                            const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _addressController,
                        decoration:
                            const InputDecoration(labelText: 'Dirección'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notesController,
                  decoration:
                      const InputDecoration(labelText: 'Notas (opcional)'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Activo',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppTheme.colorTexto)),
                    const Spacer(),
                    Switch(
                      value: _isActive,
                      onChanged: (v) => setState(() => _isActive = v),
                      activeThumbColor: AppTheme.colorPrimario,
                    ),
                  ],
                ),
                if (_error != null) ...[
                  const SizedBox(height: 10),
                  Text(_error!,
                      style: GoogleFonts.inter(
                          color: AppTheme.colorError, fontSize: 13)),
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
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white))
              : Text(_isEditing ? 'Guardar cambios' : 'Crear proveedor'),
        ),
      ],
    );
  }
}
