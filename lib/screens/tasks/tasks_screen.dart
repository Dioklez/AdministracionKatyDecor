import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../database/local_repository.dart';
import '../../services/task_service.dart';
import '../../services/project_service.dart';
import '../../models/task_model.dart';
import '../../models/project_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/project_badge.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late TaskService _taskService;
  List<Task> _allTasks = [];
  List<Project> _projects = [];
  bool _loading = true;
  String? _error;

  String _completionFilter = 'all';
  String _projectFilter = 'all';

  @override
  void initState() {
    super.initState();
    final repo = context.read<LocalRepository>();
    _taskService = TaskService(repo: repo);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = context.read<LocalRepository>();
      final futures = <Future>[
        _taskService.getAll(),
        if (_projects.isEmpty) ProjectService(repo: repo).getAll(),
      ];
      final results = await Future.wait(futures);
      if (!mounted) return;
      final taskList = results[0] as List<Task>;
      if (results.length > 1) {
        _projects = results[1] as List<Project>;
      }
      setState(() {
        _allTasks = taskList;
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo cargar la bitácora.';
          _loading = false;
        });
      }
    }
  }

  Project? _projectById(String? id) =>
      id == null ? null : _projects.where((p) => p.id == id).firstOrNull;

  List<Task> get _filteredTasks {
    return _allTasks.where((t) {
      final matchesCompletion = _completionFilter == 'all'
          ? true
          : _completionFilter == 'pending'
              ? !t.isCompleted
              : t.isCompleted;
      final matchesProject = _projectFilter == 'all' || t.projectId == _projectFilter;
      return matchesCompletion && matchesProject;
    }).toList();
  }

  Map<String, List<Task>> get _groupedTasks {
    final tasks = List<Task>.from(_filteredTasks);
    // Sort: tasks with dueDate sorted desc, then tasks without dueDate
    tasks.sort((a, b) {
      final aDate = a.dueDate ?? '';
      final bDate = b.dueDate ?? '';
      if (aDate.isEmpty && bDate.isEmpty) return b.created.compareTo(a.created);
      if (aDate.isEmpty) return 1;
      if (bDate.isEmpty) return -1;
      return bDate.compareTo(aDate);
    });
    final map = <String, List<Task>>{};
    for (final t in tasks) {
      final key = t.dueDate ?? t.created.toIso8601String().substring(0, 10);
      map.putIfAbsent(key, () => []).add(t);
    }
    return map;
  }

  String _formatDateHeader(String isoDate) {
    if (isoDate.length >= 10) {
      final parts = isoDate.substring(0, 10).split('-');
      if (parts.length == 3) {
        const months = [
          '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
          'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
        ];
        final month = int.tryParse(parts[1]) ?? 0;
        return '${parts[2]} de ${months[month]} de ${parts[0]}';
      }
    }
    return isoDate;
  }

  Future<void> _toggleTask(Task task) async {
    try {
      await _taskService.update(task.id, {
        'status': task.isCompleted ? 'pendiente' : 'completado',
      });
      await _loadData();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo actualizar la tarea.')),
        );
      }
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar tarea?',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text(
          task.title,
          style: GoogleFonts.inter(fontSize: 13),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
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
        await _taskService.delete(task.id);
        await _loadData();
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar la tarea.')),
          );
        }
      }
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
                  'Bitácora',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showTaskDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nueva tarea'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 8),
            child: _buildFilters(),
          ),

          const Divider(height: 1),

          Expanded(
            child: _error != null
                ? _buildError()
                : _loading
                    ? _buildShimmer()
                    : _buildGroupedList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(
            label: 'Todas',
            selected: _completionFilter == 'all',
            onTap: () => setState(() => _completionFilter = 'all'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Pendientes',
            selected: _completionFilter == 'pending',
            color: AppTheme.colorAdvertencia,
            onTap: () => setState(() => _completionFilter = 'pending'),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Completadas',
            selected: _completionFilter == 'done',
            color: AppTheme.colorExito,
            onTap: () => setState(() => _completionFilter = 'done'),
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 20, color: AppTheme.colorBorde),
          const SizedBox(width: 16),
          _FilterChip(
            label: 'Todos',
            selected: _projectFilter == 'all',
            onTap: () => setState(() => _projectFilter = 'all'),
          ),
          ..._projects.map((p) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _FilterChip(
                label: p.name,
                selected: _projectFilter == p.id,
                color: p.displayColor,
                onTap: () => setState(() => _projectFilter = p.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGroupedList() {
    final grouped = _groupedTasks;
    if (grouped.isEmpty) {
      return EmptyState(
        icon: Icons.assignment_outlined,
        title: 'Sin tareas',
        subtitle: _completionFilter == 'pending'
            ? 'No hay tareas pendientes'
            : _completionFilter == 'done'
                ? 'No hay tareas completadas'
                : 'Registra la primera actividad del día',
        actionLabel: 'Nueva tarea',
        onAction: _showTaskDialog,
      );
    }

    final dates = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
      itemCount: dates.length,
      itemBuilder: (context, i) {
        final date = dates[i];
        final tasks = grouped[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8, top: i == 0 ? 0 : 20),
              child: Row(
                children: [
                  Text(
                    _formatDateHeader(date),
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(height: 1, color: AppTheme.colorBorde),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.colorBorde,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tasks.length}',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.colorTextoSecundario),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppTheme.colorCard,
                borderRadius: BorderRadius.circular(AppTheme.radiusCard),
                boxShadow: AppTheme.sombraCard,
              ),
              child: Column(
                children: tasks
                    .map((t) => _TaskRow(
                          task: t,
                          project: _projectById(t.projectId),
                          onToggle: () => _toggleTask(t),
                          onEdit: () => _showTaskDialog(editTask: t),
                          onDelete: () => _deleteTask(t),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(28),
      itemCount: 4,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ShimmerBox(width: 160, height: 13),
            SizedBox(height: 8),
            ShimmerBox(height: 80),
          ],
        ),
      ),
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
              style:
                  GoogleFonts.inter(color: AppTheme.colorTextoSecundario)),
          const SizedBox(height: 16),
          OutlinedButton(
              onPressed: _loadData, child: const Text('Reintentar')),
        ],
      ),
    );
  }

  void _showTaskDialog({Task? editTask}) {
    showDialog(
      context: context,
      builder: (ctx) => _TaskDialog(
        projects: _projects,
        editTask: editTask,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadData();
        },
      ),
    );
  }
}

// ── Filter chip ───────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.colorPrimario;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.withAlpha(30) : AppTheme.colorCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppTheme.colorBorde,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (color != null) ...[
              Container(
                  width: 8,
                  height: 8,
                  decoration:
                      BoxDecoration(color: c, shape: BoxShape.circle)),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? c : AppTheme.colorTextoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fila de tarea ─────────────────────────────────────────────────────────────

class _TaskRow extends StatelessWidget {
  final Task task;
  final Project? project;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskRow({
    required this.task,
    this.project,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = task;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: t.isCompleted,
              onChanged: (_) => onToggle(),
              activeColor: AppTheme.colorExito,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: t.isCompleted
                        ? AppTheme.colorTextoSecundario
                        : AppTheme.colorTexto,
                    decoration: t.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                if (t.notes != null && t.notes!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    t.notes!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (project != null) ...[
                      ProjectBadge(
                        projectName: project!.name,
                        colorHex: project!.color,
                      ),
                      const SizedBox(width: 6),
                    ],
                    _PriorityBadge(priority: t.priority),
                  ],
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert,
                size: 18, color: AppTheme.colorTextoSecundario),
            onSelected: (v) {
              if (v == 'edit') onEdit();
              if (v == 'delete') onDelete();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'edit', child: Text('Editar')),
              PopupMenuItem(value: 'delete', child: Text('Eliminar')),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Badge de prioridad ────────────────────────────────────────────────────────

class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (priority) {
      case 'alta':
        color = AppTheme.colorError;
        label = 'Alta';
      case 'baja':
        color = AppTheme.colorTextoSecundario;
        label = 'Baja';
      default:
        color = AppTheme.colorAdvertencia;
        label = 'Media';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}

// ── Dialog: Nueva / Editar tarea ──────────────────────────────────────────────

class _TaskDialog extends StatefulWidget {
  final List<Project> projects;
  final VoidCallback onSaved;
  final Task? editTask;

  const _TaskDialog({
    required this.projects,
    required this.onSaved,
    this.editTask,
  });

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime? _dueDate;
  String? _selectedProjectId;
  String _priority = 'media';
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editTask != null;

  @override
  void initState() {
    super.initState();
    final t = widget.editTask;
    if (t != null) {
      _titleController.text = t.title;
      _notesController.text = t.notes ?? '';
      _selectedProjectId = t.projectId;
      _priority = t.priority;
      if (t.dueDate != null) {
        try {
          _dueDate = DateTime.parse(t.dueDate!);
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatDisplay(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) setState(() => _dueDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'title': _titleController.text.trim(),
      if (_selectedProjectId != null) 'projectId': _selectedProjectId,
      'priority': _priority,
      if (_dueDate != null) 'dueDate': _dueDate!.toIso8601String().substring(0, 10),
      if (_notesController.text.trim().isNotEmpty)
        'notes': _notesController.text.trim(),
    };
    try {
      final service = TaskService();
      if (_isEditing) {
        await service.update(widget.editTask!.id, body);
      } else {
        body['status'] = 'pendiente';
        await service.create(body);
      }
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo guardar la tarea.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar tarea' : 'Nueva tarea',
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
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Título *'),
                  maxLines: 2,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Fecha límite (opcional)'),
                    child: Text(
                      _dueDate != null ? _formatDisplay(_dueDate!) : 'Sin fecha',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _dueDate != null
                            ? AppTheme.colorTexto
                            : AppTheme.colorTextoSecundario,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String?>(
                  value: _selectedProjectId,
                  items: [
                    const DropdownMenuItem<String?>(
                        value: null, child: Text('Ninguno')),
                    ...widget.projects.map((p) =>
                        DropdownMenuItem<String?>(
                            value: p.id, child: Text(p.name))),
                  ],
                  onChanged: (v) => setState(() => _selectedProjectId = v),
                  decoration:
                      const InputDecoration(labelText: 'Proyecto (opcional)'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _priority,
                  items: const [
                    DropdownMenuItem(value: 'baja', child: Text('Baja')),
                    DropdownMenuItem(value: 'media', child: Text('Media')),
                    DropdownMenuItem(value: 'alta', child: Text('Alta')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _priority = v);
                  },
                  decoration: const InputDecoration(labelText: 'Prioridad'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notesController,
                  decoration:
                      const InputDecoration(labelText: 'Notas (opcional)'),
                  maxLines: 2,
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
              : Text(_isEditing ? 'Guardar cambios' : 'Guardar'),
        ),
      ],
    );
  }
}
