import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/project_service.dart';
import '../../models/project_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import 'project_detail_screen.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  final _service = ProjectService();
  List<Project> _projects = [];
  bool _loading = true;
  String? _error;
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final projects = await _service.getAll();
      if (!mounted) return;
      setState(() {
        _projects = projects;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar los proyectos.';
          _loading = false;
        });
      }
    }
  }

  List<Project> get _filteredProjects {
    if (_statusFilter == 'all') return _projects;
    return _projects.where((p) => p.status == _statusFilter).toList();
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
                  'Proyectos',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _statusFilter,
                  underline: const SizedBox(),
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppTheme.colorTextoSecundario),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Todos')),
                    DropdownMenuItem(value: 'activo', child: Text('Activos')),
                    DropdownMenuItem(value: 'pausado', child: Text('Pausados')),
                    DropdownMenuItem(
                        value: 'completado', child: Text('Completados')),
                    DropdownMenuItem(
                        value: 'cancelado', child: Text('Cancelados')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _statusFilter = v);
                  },
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showProjectDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nuevo proyecto'),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Expanded(
            child: _error != null
                ? _buildError()
                : _loading
                    ? _buildShimmer()
                    : _buildGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final projects = _filteredProjects;
    if (projects.isEmpty) {
      return EmptyState(
        icon: Icons.folder_outlined,
        title: 'Sin proyectos',
        subtitle: _statusFilter == 'all'
            ? 'Crea tu primer proyecto para comenzar'
            : 'No hay proyectos con este estado',
        actionLabel: _statusFilter == 'all' ? 'Nuevo proyecto' : null,
        onAction: _statusFilter == 'all' ? _showProjectDialog : null,
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      int crossCount;
      if (constraints.maxWidth > 1100) {
        crossCount = 3;
      } else if (constraints.maxWidth > 700) {
        crossCount = 2;
      } else {
        crossCount = 1;
      }

      return GridView.builder(
        padding: const EdgeInsets.all(28),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final p = projects[index];
          return _ProjectCard(
            project: p,
            onTap: () => _openProjectDetail(p),
            onEdit: () => _showProjectDialog(editProject: p),
            onDelete: () => _confirmDelete(p),
          );
        },
      );
    });
  }

  Widget _buildShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(28),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
      ),
      itemCount: 6,
      itemBuilder: (context, idx) => const ShimmerBox(height: double.infinity),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_outlined,
              size: 48, color: AppTheme.colorTextoSecundario),
          const SizedBox(height: 12),
          Text(_error!,
              style: GoogleFonts.inter(color: AppTheme.colorTextoSecundario)),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: _loadData, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  void _openProjectDetail(Project project) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProjectDetailScreen(project: project),
      ),
    );
  }

  void _showProjectDialog({Project? editProject}) {
    showDialog(
      context: context,
      builder: (ctx) => _ProjectDialog(
        editProject: editProject,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadData();
        },
      ),
    );
  }

  Future<void> _confirmDelete(Project p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${p.name}"?',
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
            style:
                ElevatedButton.styleFrom(backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await _service.delete(p.id);
        _loadData();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('No se pudo eliminar el proyecto.')),
          );
        }
      }
    }
  }
}

// ── Card de proyecto ──────────────────────────────────────────────────────────

class _ProjectCard extends StatefulWidget {
  final Project project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectCard({
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  String _formatMxn(double v) {
    final abs = v.abs();
    if (abs >= 1000000) return '\$${(abs / 1000000).toStringAsFixed(1)}M';
    if (abs >= 1000) {
      final s = abs.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '\$$buf';
    }
    return '\$${abs.toStringAsFixed(0)}';
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'activo':
        return AppTheme.colorExito;
      case 'pausado':
        return AppTheme.colorAdvertencia;
      case 'completado':
        return AppTheme.colorTextoSecundario;
      case 'cancelado':
        return AppTheme.colorError;
      default:
        return AppTheme.colorTextoSecundario;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final projectColor = p.displayColor;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.colorHover : AppTheme.colorCard,
            borderRadius: BorderRadius.circular(AppTheme.radiusCard),
            boxShadow: _hovered ? AppTheme.sombraMedia : AppTheme.sombraCard,
          ),
          child: Row(
            children: [
              // Barra lateral de color
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: projectColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusCard),
                    bottomLeft: Radius.circular(AppTheme.radiusCard),
                  ),
                ),
              ),

              // Contenido
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre + status badge + menú
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p.name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.colorTexto,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color:
                                  _statusColor(p.status).withAlpha(25),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              p.statusLabel,
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: _statusColor(p.status),
                              ),
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert,
                                size: 18,
                                color: AppTheme.colorTextoSecundario),
                            onSelected: (v) {
                              if (v == 'edit') widget.onEdit();
                              if (v == 'delete') widget.onDelete();
                            },
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                  value: 'edit', child: Text('Editar')),
                              PopupMenuItem(
                                  value: 'delete', child: Text('Eliminar')),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Cliente
                      Text(
                        p.clientName,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.colorTextoSecundario,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      const Spacer(),

                      // Financieros
                      Row(
                        children: [
                          _MiniStat(
                            label: 'Ingresos',
                            value: _formatMxn(p.totalIncome),
                            color: AppTheme.colorExito,
                          ),
                          const SizedBox(width: 16),
                          _MiniStat(
                            label: 'Egresos',
                            value: _formatMxn(p.totalExpense),
                            color: AppTheme.colorError,
                          ),
                          const SizedBox(width: 16),
                          _MiniStat(
                            label: 'Balance',
                            value: _formatMxn(p.balance),
                            color: p.balance >= 0
                                ? AppTheme.colorExito
                                : AppTheme.colorError,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Dialog: Nuevo / Editar proyecto ──────────────────────────────────────────

class _ProjectDialog extends StatefulWidget {
  final VoidCallback onSaved;
  final Project? editProject;

  const _ProjectDialog({required this.onSaved, this.editProject});

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clientController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  String _status = 'activo';
  String _color = '#C9A96E';
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editProject != null;

  static const _colorOptions = [
    '#C9A96E',
    '#5C8A6F',
    '#B85C5C',
    '#5C7AB8',
    '#8B6914',
    '#6E5CA9',
    '#3D7A8A',
    '#A97B5C',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.editProject;
    if (p != null) {
      _nameController.text = p.name;
      _clientController.text = p.clientName;
      _phoneController.text = p.clientPhone ?? '';
      _descController.text = p.description ?? '';
      _notesController.text = p.notes ?? '';
      _status = p.status;
      _color = p.color ?? '#C9A96E';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _clientController.dispose();
    _phoneController.dispose();
    _descController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'name': _nameController.text.trim(),
      'client_name': _clientController.text.trim(),
      if (_phoneController.text.trim().isNotEmpty)
        'client_phone': _phoneController.text.trim(),
      if (_descController.text.trim().isNotEmpty)
        'description': _descController.text.trim(),
      if (_notesController.text.trim().isNotEmpty)
        'notes': _notesController.text.trim(),
      'status': _status,
      'color': _color,
    };
    try {
      final service = ProjectService();
      if (_isEditing) {
        await service.update(widget.editProject!.id, body);
      } else {
        await service.create(body);
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear el proyecto.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar proyecto' : 'Nuevo proyecto',
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
                  decoration:
                      const InputDecoration(labelText: 'Nombre del proyecto'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _clientController,
                  decoration: const InputDecoration(labelText: 'Cliente'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneController,
                  decoration:
                      const InputDecoration(labelText: 'Teléfono (opcional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                      labelText: 'Descripción (opcional)'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Notas (opcional)'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: const [
                    DropdownMenuItem(value: 'activo', child: Text('Activo')),
                    DropdownMenuItem(value: 'pausado', child: Text('Pausado')),
                    DropdownMenuItem(
                        value: 'completado', child: Text('Completado')),
                    DropdownMenuItem(
                        value: 'cancelado', child: Text('Cancelado')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Color',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _colorOptions.map((hex) {
                    Color c;
                    try {
                      c = Color(
                          int.parse('FF${hex.substring(1)}', radix: 16));
                    } catch (_) {
                      c = AppTheme.colorPrimario;
                    }
                    final selected = _color == hex;
                    return GestureDetector(
                      onTap: () => setState(() => _color = hex),
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: c,
                          shape: BoxShape.circle,
                          border: selected
                              ? Border.all(
                                  color: AppTheme.colorTexto, width: 2)
                              : null,
                        ),
                        child: selected
                            ? const Icon(Icons.check,
                                size: 14, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 12),
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
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(_isEditing ? 'Guardar cambios' : 'Crear proyecto'),
        ),
      ],
    );
  }
}
