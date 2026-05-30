import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../database/local_repository.dart';
import '../../widgets/sync_toast.dart';
import '../../models/supplier.dart';
import '../../models/supplier_product.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<Supplier> _suppliers = [];
  bool _loadingList = true;
  String? _listError;

  int? _selectedId;
  List<SupplierProduct> _products = [];
  bool _loadingDetail = false;

  final _searchController = TextEditingController();

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

  Future<void> _loadSuppliers({String q = ''}) async {
    setState(() {
      _loadingList = true;
      _listError = null;
    });
    try {
      final api = context.read<ApiService>();
      final endpoint = q.isEmpty
          ? '/api/mobile/suppliers'
          : '/api/mobile/suppliers?q=${Uri.encodeQueryComponent(q)}';
      final result = await api.get(endpoint);
      if (!mounted) return;
      final suppliers = (result as List<dynamic>? ?? [])
          .map((e) => Supplier.fromJson(e as Map<String, dynamic>))
          .toList();
      // Guardar en local (fire-and-forget, solo cuando sin filtro de búsqueda)
      if (q.isEmpty) context.read<LocalRepository>().upsertSuppliers(suppliers);
      setState(() {
        _suppliers = suppliers;
        _loadingList = false;
      });
    } on ApiOfflineException {
      await _loadSuppliersFromLocal(q);
    } catch (e) {
      await _loadSuppliersFromLocal(q);
    }
  }

  Future<void> _loadSuppliersFromLocal(String q) async {
    try {
      final repo = context.read<LocalRepository>();
      final suppliers = q.isEmpty
          ? await repo.getAllSuppliers()
          : await repo.searchSuppliers(q);
      if (mounted) {
        setState(() {
          _suppliers = suppliers;
          _loadingList = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _listError = 'Sin datos disponibles.';
          _loadingList = false;
        });
      }
    }
  }

  Future<void> _selectSupplier(int id) async {
    setState(() {
      _selectedId = id;
      _loadingDetail = true;
      _products = [];
    });
    try {
      final api = context.read<ApiService>();
      final result = await api.get('/api/mobile/suppliers/$id/products');
      if (!mounted) return;
      final products = (result as List<dynamic>? ?? [])
          .map((e) => SupplierProduct.fromJson(e as Map<String, dynamic>))
          .toList();
      // Guardar en local (fire-and-forget)
      context.read<LocalRepository>().upsertSupplierProducts(id, products);
      setState(() {
        _products = products;
        _loadingDetail = false;
      });
    } on ApiOfflineException {
      await _loadProductsFromLocal(id);
    } catch (e) {
      await _loadProductsFromLocal(id);
    }
  }

  Future<void> _loadProductsFromLocal(int supplierId) async {
    try {
      final products = await context
          .read<LocalRepository>()
          .getProductsBySupplierId(supplierId);
      if (mounted) setState(() {
        _products = products;
        _loadingDetail = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingDetail = false);
    }
  }

  Supplier? get _selectedSupplier => _selectedId == null
      ? null
      : _suppliers.where((s) => s.id == _selectedId).firstOrNull;

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
                SizedBox(
                  width: 320,
                  child: _buildLeftPanel(),
                ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar proveedor...',
              prefixIcon: const Icon(Icons.search, size: 18),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 16),
                      onPressed: () {
                        _searchController.clear();
                        _loadSuppliers();
                      },
                    )
                  : null,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onChanged: (v) => _loadSuppliers(q: v),
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
                  : _suppliers.isEmpty
                      ? const EmptyState(
                          icon: Icons.store_outlined,
                          title: 'Sin proveedores',
                          subtitle: 'Crea tu primer proveedor',
                        )
                      : ListView.builder(
                          itemCount: _suppliers.length,
                          itemBuilder: (context, i) => _SupplierTile(
                            supplier: _suppliers[i],
                            selected: _selectedId == _suppliers[i].id,
                            onTap: () => _selectSupplier(_suppliers[i].id),
                            onEdit: () =>
                                _showSupplierDialog(editSupplier: _suppliers[i]),
                            onDelete: () => _confirmDeleteSupplier(_suppliers[i]),
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
        subtitle: 'Haz clic en un proveedor para ver su detalle y catálogo',
      );
    }

    final s = _selectedSupplier;
    if (s == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSupplierHeader(s),
          const SizedBox(height: 24),

          SectionHeader(
            title: 'Catálogo de productos',
            actionLabel: '+ Agregar producto',
            onAction: () => _showProductDialog(s.id),
          ),
          _loadingDetail
              ? const ShimmerBox(height: 120)
              : _products.isEmpty
                  ? const EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'Sin productos',
                      subtitle:
                          'Agrega productos al catálogo de este proveedor',
                    )
                  : _buildProductsTable(s.id),
        ],
      ),
    );
  }

  Widget _buildSupplierHeader(Supplier s) {
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
                  s.razonSocial,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.colorTexto,
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
          if (s.rfc != null) ...[
            const SizedBox(height: 4),
            Text('RFC: ${s.rfc}',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario)),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            children: [
              if (s.actividad != null)
                _InfoChip(icon: Icons.work_outline, label: s.actividad!),
              if (s.contacto != null)
                _InfoChip(icon: Icons.person_outline, label: s.contacto!),
              if (s.telefono != null)
                _InfoChip(icon: Icons.phone_outlined, label: s.telefono!),
              if (s.email != null)
                _InfoChip(icon: Icons.email_outlined, label: s.email!),
              if (s.ciudad != null)
                _InfoChip(icon: Icons.location_on_outlined, label: s.ciudad!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductsTable(int supplierId) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text('Producto',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Unidad',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Precio',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          ..._products.map((p) => _ProductRow(
                product: p,
                onEdit: () => _showProductDialog(supplierId, editProduct: p),
                onDelete: () => _confirmDeleteProduct(supplierId, p),
              )),
        ],
      ),
    );
  }

  // ── Diálogos ──────────────────────────────────────────────────────────────

  void _showSupplierDialog({Supplier? editSupplier}) {
    showDialog(
      context: context,
      builder: (ctx) => _NewSupplierDialog(
        editSupplier: editSupplier,
        onSaved: (newId) {
          Navigator.of(ctx).pop();
          _loadSuppliers().then((_) {
            final id = editSupplier?.id ?? newId;
            if (id != null) _selectSupplier(id);
          });
        },
      ),
    );
  }

  void _showProductDialog(int supplierId, {SupplierProduct? editProduct}) {
    showDialog(
      context: context,
      builder: (ctx) => _NewProductDialog(
        supplierId: supplierId,
        editProduct: editProduct,
        onSaved: () {
          Navigator.of(ctx).pop();
          _selectSupplier(supplierId);
        },
      ),
    );
  }

  Future<void> _confirmDeleteSupplier(Supplier s) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${s.razonSocial}"?',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Se eliminarán también todos sus productos. Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        final api = context.read<ApiService>();
        await api.delete('/api/mobile/suppliers/${s.id}');
        setState(() {
          _selectedId = null;
          _products = [];
        });
        _loadSuppliers();
      } on ApiOfflineException {
        final repo = context.read<LocalRepository>();
        await repo.addPendingOp(
          entityType: 'supplier',
          operation: 'delete',
          entityId: s.id,
          endpoint: '/api/mobile/suppliers/${s.id}',
        );
        repo.deleteSupplier(s.id);
        setState(() {
          _suppliers.removeWhere((x) => x.id == s.id);
          _selectedId = null;
          _products = [];
        });
        SyncToast.show(context, 'Eliminado localmente. Se sincronizará al reconectar.');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el proveedor.')),
          );
        }
      }
    }
  }

  Future<void> _confirmDeleteProduct(int supplierId, SupplierProduct p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${p.nombre}"?',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        final api = context.read<ApiService>();
        await api.delete('/api/mobile/suppliers/$supplierId/products/${p.id}');
        _selectSupplier(supplierId);
      } on ApiOfflineException {
        final repo = context.read<LocalRepository>();
        await repo.addPendingOp(
          entityType: 'supplier_product',
          operation: 'delete',
          entityId: p.id,
          endpoint: '/api/mobile/suppliers/$supplierId/products/${p.id}',
        );
        repo.deleteSupplierProduct(p.id);
        setState(() => _products.removeWhere((x) => x.id == p.id));
        SyncToast.show(context, 'Eliminado localmente. Se sincronizará al reconectar.');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el producto.')),
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
                    Text(
                      widget.supplier.razonSocial,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.selected
                            ? AppTheme.colorPrimario
                            : AppTheme.colorTexto,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (widget.supplier.rfc != null) ...[
                          Text(
                            widget.supplier.rfc!,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.colorTextoSecundario,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('·',
                              style: TextStyle(
                                  color: AppTheme.colorTextoSecundario)),
                          const SizedBox(width: 6),
                        ],
                        if (widget.supplier.actividad != null)
                          Expanded(
                            child: Text(
                              widget.supplier.actividad!,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppTheme.colorTextoSecundario,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
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

// ── Fila de producto ──────────────────────────────────────────────────────────

class _ProductRow extends StatelessWidget {
  final SupplierProduct product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductRow({
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = product;
    final precioStr = p.precio != null
        ? '\$${p.precio!.toStringAsFixed(2)} ${p.moneda}'
        : '—';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.nombre,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: AppTheme.colorTexto)),
                if (p.notas != null)
                  Text(p.notas!,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.colorTextoSecundario)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(p.unidad ?? '—',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario)),
          ),
          Expanded(
            flex: 2,
            child: Text(precioStr,
                textAlign: TextAlign.right,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTexto)),
          ),
          SizedBox(
            width: 40,
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert,
                  size: 16, color: AppTheme.colorTextoSecundario),
              onSelected: (v) {
                if (v == 'edit') onEdit();
                if (v == 'delete') onDelete();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(value: 'delete', child: Text('Eliminar')),
              ],
            ),
          ),
        ],
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

// ── Dialog: Nuevo / Editar proveedor ─────────────────────────────────────────

class _NewSupplierDialog extends StatefulWidget {
  final void Function(int? newId) onSaved;
  final Supplier? editSupplier;

  const _NewSupplierDialog({required this.onSaved, this.editSupplier});

  @override
  State<_NewSupplierDialog> createState() => _NewSupplierDialogState();
}

class _NewSupplierDialogState extends State<_NewSupplierDialog> {
  final _formKey = GlobalKey<FormState>();
  final _razonController = TextEditingController();
  final _rfcController = TextEditingController();
  final _actividadController = TextEditingController();
  final _contactoController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editSupplier != null;

  @override
  void initState() {
    super.initState();
    final s = widget.editSupplier;
    if (s != null) {
      _razonController.text = s.razonSocial;
      _rfcController.text = s.rfc ?? '';
      _actividadController.text = s.actividad ?? '';
      _contactoController.text = s.contacto ?? '';
      _ciudadController.text = s.ciudad ?? '';
      _telefonoController.text = s.telefono ?? '';
      _emailController.text = s.email ?? '';
    }
  }

  @override
  void dispose() {
    _razonController.dispose();
    _rfcController.dispose();
    _actividadController.dispose();
    _contactoController.dispose();
    _ciudadController.dispose();
    _telefonoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'razon_social': _razonController.text.trim(),
      if (_rfcController.text.isNotEmpty) 'rfc': _rfcController.text.trim(),
      if (_actividadController.text.isNotEmpty)
        'actividad': _actividadController.text.trim(),
      if (_contactoController.text.isNotEmpty)
        'contacto': _contactoController.text.trim(),
      if (_ciudadController.text.isNotEmpty)
        'ciudad': _ciudadController.text.trim(),
      if (_telefonoController.text.isNotEmpty)
        'telefono': _telefonoController.text.trim(),
      if (_emailController.text.isNotEmpty)
        'email': _emailController.text.trim(),
    };
    try {
      final api = context.read<ApiService>();
      if (_isEditing) {
        await api.put('/api/mobile/suppliers/${widget.editSupplier!.id}', body);
        if (mounted) widget.onSaved(null);
      } else {
        final result = await api.post('/api/mobile/suppliers', body);
        if (mounted) {
          final newId = (result as Map<String, dynamic>?)?['id'] as int?;
          widget.onSaved(newId);
        }
      }
    } on ApiOfflineException {
      if (!mounted) return;
      final repo = context.read<LocalRepository>();
      if (_isEditing) {
        final id = widget.editSupplier!.id;
        await repo.addPendingOp(
          entityType: 'supplier',
          operation: 'update',
          entityId: id,
          endpoint: '/api/mobile/suppliers/$id',
          payload: jsonEncode(body),
        );
        repo.upsertSupplier(Supplier(
          id: id,
          razonSocial: _razonController.text.trim(),
          rfc: _rfcController.text.isEmpty ? null : _rfcController.text.trim(),
          actividad: _actividadController.text.isEmpty ? null : _actividadController.text.trim(),
          contacto: _contactoController.text.isEmpty ? null : _contactoController.text.trim(),
          ciudad: _ciudadController.text.isEmpty ? null : _ciudadController.text.trim(),
          telefono: _telefonoController.text.isEmpty ? null : _telefonoController.text.trim(),
          email: _emailController.text.isEmpty ? null : _emailController.text.trim(),
        ));
        SyncToast.show(context, 'Guardado localmente. Se sincronizará al reconectar.');
        widget.onSaved(null);
      } else {
        final tempId = -DateTime.now().millisecondsSinceEpoch;
        await repo.addPendingOp(
          entityType: 'supplier',
          operation: 'create',
          tempId: tempId,
          endpoint: '/api/mobile/suppliers',
          payload: jsonEncode(body),
        );
        repo.upsertSupplier(Supplier(
          id: tempId,
          razonSocial: _razonController.text.trim(),
          rfc: _rfcController.text.isEmpty ? null : _rfcController.text.trim(),
          actividad: _actividadController.text.isEmpty ? null : _actividadController.text.trim(),
          contacto: _contactoController.text.isEmpty ? null : _contactoController.text.trim(),
          ciudad: _ciudadController.text.isEmpty ? null : _ciudadController.text.trim(),
          telefono: _telefonoController.text.isEmpty ? null : _telefonoController.text.trim(),
          email: _emailController.text.isEmpty ? null : _emailController.text.trim(),
        ));
        SyncToast.show(context, 'Guardado localmente. Se sincronizará al reconectar.');
        widget.onSaved(tempId);
      }
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
                  controller: _razonController,
                  decoration:
                      const InputDecoration(labelText: 'Razón social *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _rfcController,
                        decoration: const InputDecoration(labelText: 'RFC'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _actividadController,
                        decoration:
                            const InputDecoration(labelText: 'Actividad'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _contactoController,
                        decoration:
                            const InputDecoration(labelText: 'Contacto'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _telefonoController,
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
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _ciudadController,
                        decoration:
                            const InputDecoration(labelText: 'Ciudad'),
                      ),
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

// ── Dialog: Nuevo / Editar producto ──────────────────────────────────────────

class _NewProductDialog extends StatefulWidget {
  final int supplierId;
  final VoidCallback onSaved;
  final SupplierProduct? editProduct;

  const _NewProductDialog({
    required this.supplierId,
    required this.onSaved,
    this.editProduct,
  });

  @override
  State<_NewProductDialog> createState() => _NewProductDialogState();
}

class _NewProductDialogState extends State<_NewProductDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _unidadController = TextEditingController();
  final _precioController = TextEditingController();
  String _moneda = 'MXN';
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editProduct != null;

  @override
  void initState() {
    super.initState();
    final p = widget.editProduct;
    if (p != null) {
      _nombreController.text = p.nombre;
      _unidadController.text = p.unidad ?? '';
      _precioController.text = p.precio?.toStringAsFixed(2) ?? '';
      _moneda = p.moneda;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _unidadController.dispose();
    _precioController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final precio = double.tryParse(_precioController.text);
    final body = {
      'nombre': _nombreController.text.trim(),
      if (_unidadController.text.isNotEmpty)
        'unidad': _unidadController.text.trim(),
      'precio': precio,
      'moneda': _moneda,
    };
    try {
      final api = context.read<ApiService>();
      if (_isEditing) {
        await api.put(
            '/api/mobile/suppliers/${widget.supplierId}/products/${widget.editProduct!.id}',
            body);
      } else {
        await api.post(
            '/api/mobile/suppliers/${widget.supplierId}/products', body);
      }
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      if (!mounted) return;
      final repo = context.read<LocalRepository>();
      if (_isEditing) {
        final pid = widget.editProduct!.id;
        await repo.addPendingOp(
          entityType: 'supplier_product',
          operation: 'update',
          entityId: pid,
          endpoint: '/api/mobile/suppliers/${widget.supplierId}/products/$pid',
          payload: jsonEncode(body),
        );
        repo.upsertSupplierProduct(widget.supplierId, SupplierProduct(
          id: pid,
          nombre: _nombreController.text.trim(),
          unidad: _unidadController.text.isEmpty ? null : _unidadController.text.trim(),
          precio: precio,
          moneda: _moneda,
        ));
      } else {
        final tempId = -DateTime.now().millisecondsSinceEpoch;
        await repo.addPendingOp(
          entityType: 'supplier_product',
          operation: 'create',
          tempId: tempId,
          endpoint: '/api/mobile/suppliers/${widget.supplierId}/products',
          payload: jsonEncode(body),
        );
        repo.upsertSupplierProduct(widget.supplierId, SupplierProduct(
          id: tempId,
          nombre: _nombreController.text.trim(),
          unidad: _unidadController.text.isEmpty ? null : _unidadController.text.trim(),
          precio: precio,
          moneda: _moneda,
        ));
      }
      SyncToast.show(context, 'Guardado localmente. Se sincronizará al reconectar.');
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo agregar el producto.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar producto' : 'Agregar producto',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration:
                    const InputDecoration(labelText: 'Nombre del producto *'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Requerido' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _unidadController,
                decoration: const InputDecoration(
                    labelText: 'Unidad (pieza, kg, m², ...)'),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _precioController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Precio (opcional)'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      initialValue: _moneda,
                      items: const [
                        DropdownMenuItem(value: 'MXN', child: Text('MXN')),
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                      ],
                      onChanged: (v) =>
                          setState(() => _moneda = v ?? 'MXN'),
                      decoration: const InputDecoration(labelText: 'Moneda'),
                    ),
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
              : Text(_isEditing ? 'Guardar cambios' : 'Agregar'),
        ),
      ],
    );
  }
}
