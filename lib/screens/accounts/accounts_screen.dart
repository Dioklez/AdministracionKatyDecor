import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../database/local_repository.dart';
import '../../services/account_service.dart';
import '../../services/connectivity_service.dart';
import '../../services/offline_queue_service.dart';
import '../../services/account_payment_service.dart';
import '../../models/account_model.dart';
import '../../models/account_payment_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> _accounts = [];
  bool _loadingList = true;
  String? _listError;

  String? _selectedId;
  Account? _selectedAccount;

  // Pagos de la cuenta seleccionada
  List<AccountPayment> _payments = [];
  bool _loadingPayments = false;

  // Filtros (aplicados localmente)
  String _typeFilter = 'all';
  String _activeFilter = 'all'; // 'all' | 'active' | 'inactive'

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    setState(() {
      _loadingList = true;
      _listError = null;
    });
    try {
      final repo = context.read<LocalRepository>();
      final accounts = await AccountService(repo: repo).getAll();
      if (!mounted) return;
      setState(() {
        _accounts = accounts;
        _loadingList = false;
        if (_selectedId != null) {
          _selectedAccount =
              _accounts.where((a) => a.id == _selectedId).firstOrNull;
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _listError = 'No se pudo cargar las cuentas.';
          _loadingList = false;
        });
      }
    }
  }

  void _selectAccount(String id) {
    setState(() {
      _selectedId = id;
      _selectedAccount = _accounts.where((a) => a.id == id).firstOrNull;
      _payments = [];
    });
    _loadPayments(id);
  }

  Future<void> _loadPayments(String accountId) async {
    print('_loadPayments llamado para: $accountId');
    setState(() => _loadingPayments = true);
    try {
      final payments = await AccountPaymentService(repo: context.read<LocalRepository>()).getByAccount(accountId);
      print('Pagos encontrados: ${payments.length}');
      if (!mounted) return;
      setState(() {
        _payments = payments;
        _loadingPayments = false;
      });
    } catch (e) {
      print('_loadPayments error: $e');
      if (mounted) setState(() => _loadingPayments = false);
    }
  }

  List<Account> get _filtered {
    return _accounts.where((a) {
      if (_typeFilter != 'all' && a.type != _typeFilter) return false;
      if (_activeFilter == 'active' && !a.isActive) return false;
      if (_activeFilter == 'inactive' && a.isActive) return false;
      return true;
    }).toList();
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
                  'Cuentas',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () => _showAccountDialog(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Nueva cuenta'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 340, child: _buildLeftPanel()),
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
        _buildActiveFilter(),
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
                          icon: Icons.account_balance_outlined,
                          title: 'Sin cuentas',
                          subtitle: 'Crea tu primera cuenta bancaria',
                          actionLabel: 'Nueva cuenta',
                          onAction: _showAccountDialog,
                        )
                      : ListView.builder(
                          itemCount: filtered.length,
                          itemBuilder: (ctx, i) => _AccountTile(
                            account: filtered[i],
                            selected: _selectedId == filtered[i].id,
                            onTap: () => _selectAccount(filtered[i].id),
                            onEdit: () =>
                                _showAccountDialog(editAccount: filtered[i]),
                            onDelete: () => _confirmDeleteAccount(filtered[i]),
                          ),
                        ),
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    // Tipos únicos presentes en las cuentas
    final types = _accounts.map((a) => a.type).toSet().toList()..sort();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TabBtn(
              label: 'Todas',
              selected: _typeFilter == 'all',
              onTap: () => setState(() => _typeFilter = 'all'),
            ),
            ...types.map((t) => Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _TabBtn(
                    label: t,
                    selected: _typeFilter == t,
                    onTap: () => setState(() => _typeFilter = t),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          _TabBtn(
            label: 'Todas',
            selected: _activeFilter == 'all',
            onTap: () => setState(() => _activeFilter = 'all'),
          ),
          const SizedBox(width: 6),
          _TabBtn(
            label: 'Activas',
            selected: _activeFilter == 'active',
            color: AppTheme.colorExito,
            onTap: () => setState(() => _activeFilter = 'active'),
          ),
          const SizedBox(width: 6),
          _TabBtn(
            label: 'Inactivas',
            selected: _activeFilter == 'inactive',
            color: AppTheme.colorTextoSecundario,
            onTap: () => setState(() => _activeFilter = 'inactive'),
          ),
        ],
      ),
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, i) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ShimmerBox(width: 160, height: 13),
          SizedBox(height: 6),
          ShimmerBox(height: 10),
        ]),
      ),
    );
  }

  // ── Panel derecho ─────────────────────────────────────────────────────────

  Widget _buildRightPanel() {
    if (_selectedId == null) {
      return const EmptyState(
        icon: Icons.account_balance_outlined,
        title: 'Selecciona una cuenta',
        subtitle: 'Haz clic en una cuenta para ver su detalle',
      );
    }
    final account = _selectedAccount;
    if (account == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountDetail(account),
          const SizedBox(height: 24),
          _buildPaymentsSection(account),
        ],
      ),
    );
  }

  Widget _buildPaymentsSection(Account account) {
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
              Text(
                'Pagos / Abonos',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorTexto,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () => _showPaymentDialog(account: account),
                icon: const Icon(Icons.add, size: 15),
                label: const Text('Nuevo pago'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_loadingPayments)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else if (_payments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Sin pagos registrados para esta cuenta.',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario),
              ),
            )
          else
            ...(_payments.map((p) => _PaymentTile(
                  payment: p,
                  onEdit: () =>
                      _showPaymentDialog(account: account, editPayment: p),
                  onDelete: () => _confirmDeletePayment(p),
                ))),
        ],
      ),
    );
  }

  Widget _buildAccountDetail(Account a) {
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
                  a.name,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.colorTexto,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (a.isActive ? AppTheme.colorExito : AppTheme.colorTextoSecundario).withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.isActive ? 'Activa' : 'Inactiva',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: a.isActive ? AppTheme.colorExito : AppTheme.colorTextoSecundario,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert,
                    size: 18, color: AppTheme.colorTextoSecundario),
                onSelected: (v) {
                  if (v == 'edit') _showAccountDialog(editAccount: a);
                  if (v == 'delete') _confirmDeleteAccount(a);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            a.type,
            style: GoogleFonts.inter(
                fontSize: 13, color: AppTheme.colorTextoSecundario),
          ),
          const SizedBox(height: 20),
          // Stat cards
          Row(
            children: [
              _InfoCell(label: 'Saldo', value: _fmt(a.balance), color: AppTheme.colorPrimario),
              const SizedBox(width: 32),
              if (a.bankName != null)
                _InfoCell(label: 'Banco', value: a.bankName!, color: AppTheme.colorTexto),
              if (a.bankName != null) const SizedBox(width: 32),
              if (a.accountNumber != null)
                _InfoCell(label: 'Número de cuenta', value: a.accountNumber!, color: AppTheme.colorTexto),
            ],
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _fmt(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) {
      final s = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '\$$buf';
    }
    return '\$${v.toStringAsFixed(2)}';
  }

  // ── Diálogos ──────────────────────────────────────────────────────────────

  void _showAccountDialog({Account? editAccount}) {
    showDialog(
      context: context,
      builder: (ctx) => _AccountDialog(
        editAccount: editAccount,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadAccounts();
        },
      ),
    );
  }

  Future<void> _confirmDeleteAccount(Account a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${a.name}"?',
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
        final connectivity = context.read<ConnectivityService>();
        final repo = context.read<LocalRepository>();
        final queue = context.read<OfflineQueueService>();
        Future<void> deleteOffline() async {
          await repo.deleteAccount(a.id);
          await queue.enqueue(entityType: 'accounts', operation: 'delete',
              endpoint: 'accounts', entityId: a.id, payload: {});
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
        }
        if (connectivity.isOnline) {
          try { await AccountService(repo: repo).delete(a.id); }
          catch (_) { await deleteOffline(); }
        } else { await deleteOffline(); }
        if (mounted) {
          setState(() {
            if (_selectedId == a.id) {
              _selectedId = null;
              _selectedAccount = null;
            }
          });
          _loadAccounts();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar la cuenta.')),
          );
        }
      }
    }
  }

  void _showPaymentDialog({
    required Account account,
    AccountPayment? editPayment,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => _PaymentDialog(
        account: account,
        editPayment: editPayment,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadPayments(account.id);
        },
      ),
    );
  }

  Future<void> _confirmDeletePayment(AccountPayment p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar pago?',
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w600)),
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
        await AccountPaymentService().delete(p.id);
        if (mounted && _selectedId != null) _loadPayments(_selectedId!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el pago.')),
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

  const _TabBtn({
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? c.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? c : AppTheme.colorBorde,
            width: selected ? 1.5 : 1,
          ),
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

// ── Tile de cuenta ────────────────────────────────────────────────────────────

class _AccountTile extends StatefulWidget {
  final Account account;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AccountTile({
    required this.account,
    required this.selected,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends State<_AccountTile> {
  bool _hovered = false;

  String _fmt(double v) {
    if (v >= 1000) {
      final s = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '\$$buf';
    }
    return '\$${v.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.account;

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
                            a.name,
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
                        if (!a.isActive)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppTheme.colorTextoSecundario.withAlpha(25),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Inactiva',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppTheme.colorTextoSecundario),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      a.bankName != null
                          ? '${a.type} · ${a.bankName}'
                          : a.type,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.colorTextoSecundario,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Saldo: ${_fmt(a.balance)}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.colorPrimario,
                      ),
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

// ── Info cell ─────────────────────────────────────────────────────────────────

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoCell(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.inter(
                fontSize: 11, color: AppTheme.colorTextoSecundario)),
        Text(value,
            style: GoogleFonts.inter(
                fontSize: 16, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

// ── Dialog: Nueva / Editar cuenta ─────────────────────────────────────────────

class _AccountDialog extends StatefulWidget {
  final VoidCallback onSaved;
  final Account? editAccount;

  const _AccountDialog({required this.onSaved, this.editAccount});

  @override
  State<_AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends State<_AccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String _type = 'efectivo';
  final _balanceController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  bool _isActive = true;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editAccount != null;

  @override
  void initState() {
    super.initState();
    final a = widget.editAccount;
    if (a != null) {
      _nameController.text = a.name;
      _type = ['efectivo', 'banco', 'tarjeta', 'otro'].contains(a.type)
          ? a.type
          : 'efectivo';
      _balanceController.text = a.balance.toStringAsFixed(2);
      _bankNameController.text = a.bankName ?? '';
      _accountNumberController.text = a.accountNumber ?? '';
      _isActive = a.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final amount = double.parse(_balanceController.text);
    final data = <String, dynamic>{
      'name': _nameController.text.trim(),
      'type': _type,
      'balance': amount,
      'bank_name': _bankNameController.text.trim(),
      'account_number': _accountNumberController.text.trim(),
      'is_active': _isActive,
      // initial_balance solo se guarda al crear — nunca se sobreescribe al editar
      if (!_isEditing) 'initial_balance': amount,
    };
    try {
      final connectivity = context.read<ConnectivityService>();
      final repo = context.read<LocalRepository>();
      final queue = context.read<OfflineQueueService>();

      if (_isEditing) {
        final id = widget.editAccount!.id;
        Future<void> upsertOffline() async {
          await repo.upsertAccount(Account(
            id: id,
            name: data['name'] as String,
            type: data['type'] as String,
            balance: (data['balance'] as num).toDouble(),
            initialBalance: widget.editAccount!.initialBalance,
            bankName: (data['bank_name'] as String).isNotEmpty
                ? data['bank_name'] as String : null,
            accountNumber: (data['account_number'] as String).isNotEmpty
                ? data['account_number'] as String : null,
            isActive: data['is_active'] as bool,
            created: widget.editAccount!.created,
            updated: DateTime.now(),
          ));
          await queue.enqueue(entityType: 'accounts', operation: 'update',
              endpoint: 'accounts', entityId: id, payload: data);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
        }
        if (connectivity.isOnline) {
          try { await AccountService(repo: repo).update(id, data); }
          catch (_) { await upsertOffline(); }
        } else { await upsertOffline(); }
        if (mounted) widget.onSaved();
        return;
      }

      // CREATE PATH
      if (!connectivity.isOnline) {
        final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
        await repo.upsertAccount(Account(
          id: tempId,
          name: data['name'] as String,
          type: data['type'] as String,
          balance: (data['balance'] as num).toDouble(),
          initialBalance: (data['initial_balance'] as num).toDouble(),
          bankName: (data['bank_name'] as String).isNotEmpty
              ? data['bank_name'] as String : null,
          accountNumber: (data['account_number'] as String).isNotEmpty
              ? data['account_number'] as String : null,
          isActive: data['is_active'] as bool,
          created: DateTime.now(),
          updated: DateTime.now(),
        ));
        await queue.enqueue(entityType: 'accounts', operation: 'create',
            endpoint: 'accounts', payload: {...data, '_tempId': tempId});
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardado localmente. Se sincronizará al reconectar.')));
          widget.onSaved();
        }
        return;
      }
      await AccountService(repo: repo).create(data);
      if (mounted) widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo crear la cuenta.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar cuenta' : 'Nueva cuenta',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:
                      const InputDecoration(labelText: 'Nombre de la cuenta *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _type,
                  items: const [
                    DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                    DropdownMenuItem(value: 'banco', child: Text('Banco')),
                    DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
                    DropdownMenuItem(value: 'otro', child: Text('Otro')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _type = v);
                  },
                  decoration: const InputDecoration(labelText: 'Tipo *'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _balanceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Saldo (MXN) *'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (double.tryParse(v) == null) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bankNameController,
                  decoration:
                      const InputDecoration(labelText: 'Banco (opcional)'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: const InputDecoration(
                      labelText: 'Número de cuenta (opcional)'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text('Activa',
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
              : Text(_isEditing ? 'Guardar cambios' : 'Crear cuenta'),
        ),
      ],
    );
  }
}

// ── Tile de pago ──────────────────────────────────────────────────────────────

class _PaymentTile extends StatelessWidget {
  final AccountPayment payment;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PaymentTile({
    required this.payment,
    required this.onEdit,
    required this.onDelete,
  });

  Color _statusColor(String status) {
    switch (status) {
      case 'pagado':
        return AppTheme.colorExito;
      case 'vencido':
        return AppTheme.colorError;
      default:
        return AppTheme.colorAdvertencia;
    }
  }

  String _fmtDate(String? iso) {
    if (iso == null || iso.length < 10) return '';
    final p = iso.substring(0, 10).split('-');
    if (p.length == 3) return '${p[2]}/${p[1]}/${p[0]}';
    return iso;
  }

  String _fmtMoney(double v) {
    if (v >= 1000) {
      final s = v.toStringAsFixed(0);
      final buf = StringBuffer();
      for (int i = 0; i < s.length; i++) {
        if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
        buf.write(s[i]);
      }
      return '\$$buf';
    }
    return '\$${v.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final p = payment;
    final statusColor = _statusColor(p.status);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.colorFondo,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.colorBorde),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.description?.isNotEmpty == true
                        ? p.description!
                        : p.typeLabel,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.colorTexto),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        p.typeLabel,
                        style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.colorTextoSecundario),
                      ),
                      if (p.date != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          _fmtDate(p.date),
                          style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.colorTextoSecundario),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withAlpha(25),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                p.statusLabel,
                style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: statusColor),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _fmtMoney(p.amount),
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.colorTexto),
            ),
            PopupMenuButton<String>(
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
          ],
        ),
      ),
    );
  }
}

// ── Dialog: Nuevo / Editar pago ───────────────────────────────────────────────

class _PaymentDialog extends StatefulWidget {
  final Account account;
  final AccountPayment? editPayment;
  final VoidCallback onSaved;

  const _PaymentDialog({
    required this.account,
    this.editPayment,
    required this.onSaved,
  });

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descCtrl;
  late TextEditingController _amountCtrl;
  late TextEditingController _notesCtrl;
  String _type = 'pago';
  String _status = 'pendiente';
  DateTime? _date;
  DateTime? _dueDate;
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editPayment != null;

  @override
  void initState() {
    super.initState();
    final p = widget.editPayment;
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _amountCtrl = TextEditingController(
        text: p != null ? p.amount.toStringAsFixed(2) : '');
    _notesCtrl = TextEditingController(text: p?.notes ?? '');
    _type = p?.type ?? 'pago';
    _status = p?.status ?? 'pendiente';
    _date = p?.date != null ? DateTime.tryParse(p!.date!) : null;
    _dueDate = p?.dueDate != null ? DateTime.tryParse(p!.dueDate!) : null;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _amountCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate(bool isDue) async {
    final initial = isDue ? (_dueDate ?? DateTime.now()) : (_date ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isDue) {
          _dueDate = picked;
        } else {
          _date = picked;
        }
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'account': widget.account.id,
      'description': _descCtrl.text.trim(),
      'amount': double.tryParse(_amountCtrl.text) ?? 0.0,
      'type': _type,
      'date': _date?.toIso8601String().substring(0, 10) ?? '',
      'status': _status,
      'due_date': _dueDate?.toIso8601String().substring(0, 10) ?? '',
      'notes': _notesCtrl.text.trim(),
    };
    try {
      final svc = AccountPaymentService();
      if (_isEditing) {
        await svc.update(widget.editPayment!.id, body);
      } else {
        await svc.create(body);
      }
      print('Pago creado exitosamente, llamando _loadPayments');
      if (mounted) widget.onSaved();
    } catch (e) {
      print('AccountPaymentService.create error: $e');
      if (mounted) {
        setState(() {
          _error = _isEditing
              ? 'No se pudo guardar los cambios.'
              : 'No se pudo registrar el pago.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _isEditing ? 'Editar pago' : 'Nuevo pago — ${widget.account.name}',
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _descCtrl,
                  decoration:
                      const InputDecoration(labelText: 'Descripción (opcional)'),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _amountCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                            labelText: 'Monto *', prefixText: '\$ '),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Requerido';
                          if (double.tryParse(v) == null) return 'Inválido';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _type,
                        items: const [
                          DropdownMenuItem(value: 'pago', child: Text('Pago')),
                          DropdownMenuItem(
                              value: 'cobro', child: Text('Cobro')),
                          DropdownMenuItem(
                              value: 'abono', child: Text('Abono')),
                        ],
                        onChanged: (v) {
                          if (v != null) setState(() => _type = v);
                        },
                        decoration: const InputDecoration(labelText: 'Tipo'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(false),
                        child: InputDecorator(
                          decoration: const InputDecoration(labelText: 'Fecha'),
                          child: Text(
                            _date != null ? _formatDate(_date!) : 'Sin fecha',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () => _pickDate(true),
                        child: InputDecorator(
                          decoration:
                              const InputDecoration(labelText: 'Fecha límite'),
                          child: Text(
                            _dueDate != null
                                ? _formatDate(_dueDate!)
                                : 'Sin fecha',
                            style: GoogleFonts.inter(fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _status,
                  items: const [
                    DropdownMenuItem(
                        value: 'pendiente', child: Text('Pendiente')),
                    DropdownMenuItem(value: 'pagado', child: Text('Pagado')),
                    DropdownMenuItem(value: 'vencido', child: Text('Vencido')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _status = v);
                  },
                  decoration: const InputDecoration(labelText: 'Estado'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  decoration:
                      const InputDecoration(labelText: 'Notas (opcional)'),
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
              : Text(_isEditing ? 'Guardar cambios' : 'Registrar pago'),
        ),
      ],
    );
  }
}
