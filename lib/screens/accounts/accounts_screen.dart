import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../database/local_repository.dart';
import '../../widgets/sync_toast.dart';
import '../../models/account.dart';
import '../../models/account_payment.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shimmer_box.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/section_header.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  List<Account> _accounts = [];
  bool _loadingList = true;
  String? _listError;

  int? _selectedId;
  Account? _selectedAccount;
  List<AccountPayment> _payments = [];
  bool _loadingDetail = false;

  // Filtros
  String _tipoFilter = 'all'; // 'all' | 'cobrar' | 'pagar'
  String _estadoFilter = 'all'; // 'all' | 'pendiente' | 'parcial' | 'cancelada'

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
      final api = context.read<ApiService>();
      String endpoint = '/api/mobile/accounts';
      final params = <String>[];
      if (_tipoFilter != 'all') params.add('tipo=$_tipoFilter');
      if (_estadoFilter != 'all') params.add('estado=$_estadoFilter');
      if (params.isNotEmpty) endpoint += '?${params.join('&')}';
      final result = await api.get(endpoint);
      if (!mounted) return;
      final accounts = (result as List<dynamic>? ?? [])
          .map((e) => Account.fromJson(e as Map<String, dynamic>))
          .toList();
      // Guardar en local (fire-and-forget)
      context.read<LocalRepository>().upsertAccounts(accounts);
      setState(() {
        _accounts = accounts;
        _loadingList = false;
        // Refresh selected if needed
        if (_selectedId != null) {
          _selectedAccount = _accounts
              .where((a) => a.id == _selectedId)
              .firstOrNull;
        }
      });
    } on ApiOfflineException {
      await _loadAccountsFromLocal();
    } catch (e) {
      await _loadAccountsFromLocal();
    }
  }

  Future<void> _loadAccountsFromLocal() async {
    try {
      final repo = context.read<LocalRepository>();
      final accounts = await repo.getAccountsFiltered(
        tipo: _tipoFilter == 'all' ? null : _tipoFilter,
        estado: _estadoFilter == 'all' ? null : _estadoFilter,
      );
      if (mounted) {
        setState(() {
          _accounts = accounts;
          _loadingList = false;
          if (_selectedId != null) {
            _selectedAccount = _accounts.where((a) => a.id == _selectedId).firstOrNull;
          }
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

  Future<void> _selectAccount(int id) async {
    setState(() {
      _selectedId = id;
      _loadingDetail = true;
      _selectedAccount = _accounts.where((a) => a.id == id).firstOrNull;
    });
    try {
      final api = context.read<ApiService>();
      final result = await api.get('/api/mobile/accounts/$id');
      if (!mounted) return;
      final detail = Account.fromJson(result as Map<String, dynamic>);
      final payList = (result['payments'] as List<dynamic>? ?? [])
          .map((e) => AccountPayment.fromJson(e as Map<String, dynamic>))
          .toList();
      // Guardar en local (fire-and-forget)
      final repo = context.read<LocalRepository>();
      repo.upsertAccount(detail);
      repo.upsertPayments(payList);
      setState(() {
        _selectedAccount = detail;
        _payments = payList;
        _loadingDetail = false;
      });
    } on ApiOfflineException {
      await _loadDetailFromLocal(id);
    } catch (e) {
      await _loadDetailFromLocal(id);
    }
  }

  Future<void> _loadDetailFromLocal(int id) async {
    try {
      final repo = context.read<LocalRepository>();
      final account = await repo.getAccountById(id);
      final payments = await repo.getPaymentsByAccountId(id);
      if (mounted) {
        setState(() {
          if (account != null) _selectedAccount = account;
          _payments = payments;
          _loadingDetail = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingDetail = false);
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
    return Column(
      children: [
        // Filtros tipo
        _buildTypeFilter(),
        const Divider(height: 1),
        // Filtros estado
        _buildStatusFilter(),
        const Divider(height: 1),
        Expanded(
          child: _loadingList
              ? _buildListShimmer()
              : _listError != null
                  ? Center(
                      child: Text(_listError!,
                          style: GoogleFonts.inter(
                              color: AppTheme.colorTextoSecundario)))
                  : _accounts.isEmpty
                      ? EmptyState(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'Sin cuentas',
                          subtitle: 'Crea tu primera cuenta por cobrar o pagar',
                          actionLabel: 'Nueva cuenta',
                          onAction: _showAccountDialog,
                        )
                      : ListView.builder(
                          itemCount: _accounts.length,
                          itemBuilder: (ctx, i) => _AccountTile(
                            account: _accounts[i],
                            selected: _selectedId == _accounts[i].id,
                            onTap: () => _selectAccount(_accounts[i].id),
                            onEdit: () =>
                                _showAccountDialog(editAccount: _accounts[i]),
                            onDelete: () => _confirmDeleteAccount(_accounts[i]),
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
          _TabBtn(
            label: 'Todas',
            selected: _tipoFilter == 'all',
            onTap: () {
              setState(() => _tipoFilter = 'all');
              _loadAccounts();
            },
          ),
          const SizedBox(width: 8),
          _TabBtn(
            label: 'Por cobrar',
            selected: _tipoFilter == 'cobrar',
            color: AppTheme.colorExito,
            onTap: () {
              setState(() => _tipoFilter = 'cobrar');
              _loadAccounts();
            },
          ),
          const SizedBox(width: 8),
          _TabBtn(
            label: 'Por pagar',
            selected: _tipoFilter == 'pagar',
            color: AppTheme.colorError,
            onTap: () {
              setState(() => _tipoFilter = 'pagar');
              _loadAccounts();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _TabBtn(
              label: 'Todos',
              selected: _estadoFilter == 'all',
              onTap: () {
                setState(() => _estadoFilter = 'all');
                _loadAccounts();
              },
            ),
            const SizedBox(width: 6),
            _TabBtn(
              label: 'Pendientes',
              selected: _estadoFilter == 'pendiente',
              color: AppTheme.colorAdvertencia,
              onTap: () {
                setState(() => _estadoFilter = 'pendiente');
                _loadAccounts();
              },
            ),
            const SizedBox(width: 6),
            _TabBtn(
              label: 'Parciales',
              selected: _estadoFilter == 'parcial',
              color: AppTheme.colorPrimario,
              onTap: () {
                setState(() => _estadoFilter = 'parcial');
                _loadAccounts();
              },
            ),
            const SizedBox(width: 6),
            _TabBtn(
              label: 'Liquidadas',
              selected: _estadoFilter == 'cancelada',
              color: AppTheme.colorTextoSecundario,
              onTap: () {
                setState(() => _estadoFilter = 'cancelada');
                _loadAccounts();
              },
            ),
          ],
        ),
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
          ShimmerBox(height: 8),
        ]),
      ),
    );
  }

  // ── Panel derecho ─────────────────────────────────────────────────────────

  Widget _buildRightPanel() {
    if (_selectedId == null) {
      return const EmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: 'Selecciona una cuenta',
        subtitle: 'Haz clic en una cuenta para ver su detalle y abonos',
      );
    }
    final account = _selectedAccount;
    if (account == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAccountHeader(account),
          const SizedBox(height: 24),
          SectionHeader(
            title: 'Historial de abonos',
            actionLabel: account.estado == 'cancelada'
                ? null
                : '+ Registrar abono',
            onAction: account.estado == 'cancelada'
                ? null
                : () => _showPaymentDialog(account),
          ),
          _loadingDetail
              ? const ShimmerBox(height: 100)
              : _payments.isEmpty
                  ? const EmptyState(
                      icon: Icons.payments_outlined,
                      title: 'Sin abonos',
                      subtitle: 'Registra el primer pago',
                    )
                  : _buildPaymentsTable(account),
        ],
      ),
    );
  }

  Widget _buildAccountHeader(Account a) {
    final tipoColor = a.tipo == 'cobrar' ? AppTheme.colorExito : AppTheme.colorError;
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
                  a.contraparte,
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
                  color: tipoColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  a.tipo == 'cobrar' ? 'Por cobrar' : 'Por pagar',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: tipoColor,
                  ),
                ),
              ),
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
          if (a.descripcion != null && a.descripcion!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(a.descripcion!,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario)),
          ],
          const SizedBox(height: 16),
          // Stats financieros
          Row(
            children: [
              _StatCell(
                  label: 'Monto original',
                  value: _fmt(a.montoOriginal),
                  color: AppTheme.colorTexto),
              const SizedBox(width: 24),
              _StatCell(
                  label: 'Total pagado',
                  value: _fmt(a.pagado),
                  color: AppTheme.colorExito),
              const SizedBox(width: 24),
              _StatCell(
                  label: 'Saldo pendiente',
                  value: _fmt(a.saldo),
                  color: a.saldo > 0
                      ? AppTheme.colorError
                      : AppTheme.colorTextoSecundario),
            ],
          ),
          const SizedBox(height: 12),
          // Barra de progreso
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: a.pctPagado,
              minHeight: 8,
              backgroundColor: AppTheme.colorBorde,
              valueColor: AlwaysStoppedAnimation<Color>(
                a.estado == 'cancelada'
                    ? AppTheme.colorExito
                    : a.pctPagado > 0
                        ? AppTheme.colorPrimario
                        : AppTheme.colorBorde,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(a.pctPagado * 100).toStringAsFixed(0)}% liquidado · ${_estadoLabel(a.estado)}',
            style: GoogleFonts.inter(
                fontSize: 11, color: AppTheme.colorTextoSecundario),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentsTable(Account account) {
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
                  flex: 2,
                  child: Text('Fecha',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Monto',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Notas',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.colorTextoSecundario)),
                ),
                const SizedBox(width: 36),
              ],
            ),
          ),
          ..._payments.map((p) => _PaymentRow(
                payment: p,
                onDelete: () => _confirmDeletePayment(account, p),
              )),
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

  String _estadoLabel(String estado) {
    switch (estado) {
      case 'parcial':
        return 'Parcial';
      case 'cancelada':
        return 'Liquidada';
      default:
        return 'Pendiente';
    }
  }

  // ── Diálogos ──────────────────────────────────────────────────────────────

  void _showAccountDialog({Account? editAccount}) {
    showDialog(
      context: context,
      builder: (ctx) => _NewAccountDialog(
        editAccount: editAccount,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadAccounts().then((_) {
            if (_selectedId != null) _selectAccount(_selectedId!);
          });
        },
      ),
    );
  }

  void _showPaymentDialog(Account account) {
    showDialog(
      context: context,
      builder: (ctx) => _NewPaymentDialog(
        account: account,
        onSaved: () {
          Navigator.of(ctx).pop();
          _loadAccounts().then((_) => _selectAccount(account.id));
        },
      ),
    );
  }

  Future<void> _confirmDeleteAccount(Account a) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar "${a.contraparte}"?',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Se eliminarán también todos los abonos. Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
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
        await context.read<ApiService>().delete('/api/mobile/accounts/${a.id}');
        setState(() {
          if (_selectedId == a.id) {
            _selectedId = null;
            _selectedAccount = null;
            _payments = [];
          }
        });
        _loadAccounts();
      } on ApiOfflineException {
        final repo = context.read<LocalRepository>();
        await repo.addPendingOp(
          entityType: 'account',
          operation: 'delete',
          entityId: a.id,
          endpoint: '/api/mobile/accounts/${a.id}',
        );
        repo.deleteAccount(a.id);
        setState(() {
          _accounts.removeWhere((x) => x.id == a.id);
          if (_selectedId == a.id) {
            _selectedId = null;
            _selectedAccount = null;
            _payments = [];
          }
        });
        SyncToast.show(context, 'Eliminado localmente. Se sincronizará al reconectar.');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar la cuenta.')),
          );
        }
      }
    }
  }

  Future<void> _confirmDeletePayment(Account account, AccountPayment p) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('¿Eliminar abono de \$${p.monto.toStringAsFixed(2)}?',
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
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.colorError),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      try {
        await context.read<ApiService>().delete(
            '/api/mobile/accounts/${account.id}/payments/${p.id}');
        _loadAccounts().then((_) => _selectAccount(account.id));
      } on ApiOfflineException {
        final repo = context.read<LocalRepository>();
        await repo.addPendingOp(
          entityType: 'payment',
          operation: 'delete',
          entityId: p.id,
          endpoint: '/api/mobile/accounts/${account.id}/payments/${p.id}',
        );
        repo.deletePayment(p.id);
        setState(() => _payments.removeWhere((x) => x.id == p.id));
        SyncToast.show(context, 'Eliminado localmente. Se sincronizará al reconectar.');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No se pudo eliminar el abono.')),
          );
        }
      }
    }
  }
}

// ── Tab button reutilizable ───────────────────────────────────────────────────

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
    final tipoColor = a.tipo == 'cobrar' ? AppTheme.colorExito : AppTheme.colorError;

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
                color: widget.selected ? AppTheme.colorPrimario : Colors.transparent,
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
                            a.contraparte,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: tipoColor.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            a.tipo == 'cobrar' ? 'Cobrar' : 'Pagar',
                            style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: tipoColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: a.pctPagado,
                        minHeight: 4,
                        backgroundColor: AppTheme.colorBorde,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          a.estado == 'cancelada'
                              ? AppTheme.colorExito
                              : AppTheme.colorPrimario,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saldo: ${_fmt(a.saldo)}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: a.saldo > 0
                            ? AppTheme.colorError
                            : AppTheme.colorTextoSecundario,
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

// ── Fila de abono ─────────────────────────────────────────────────────────────

class _PaymentRow extends StatelessWidget {
  final AccountPayment payment;
  final VoidCallback onDelete;

  const _PaymentRow({required this.payment, required this.onDelete});

  String _formatDate(String? iso) {
    if (iso == null || iso.length < 10) return '—';
    final parts = iso.substring(0, 10).split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    return iso;
  }

  @override
  Widget build(BuildContext context) {
    final p = payment;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(_formatDate(p.fecha),
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppTheme.colorTextoSecundario)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '\$${p.monto.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.colorExito),
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(p.notas ?? '—',
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppTheme.colorTextoSecundario),
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          SizedBox(
            width: 36,
            child: IconButton(
              icon: const Icon(Icons.delete_outline, size: 16),
              color: AppTheme.colorError,
              onPressed: onDelete,
              tooltip: 'Eliminar abono',
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat cell ─────────────────────────────────────────────────────────────────

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCell(
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

class _NewAccountDialog extends StatefulWidget {
  final VoidCallback onSaved;
  final Account? editAccount;

  const _NewAccountDialog({required this.onSaved, this.editAccount});

  @override
  State<_NewAccountDialog> createState() => _NewAccountDialogState();
}

class _NewAccountDialogState extends State<_NewAccountDialog> {
  final _formKey = GlobalKey<FormState>();
  final _contraparteController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _montoController = TextEditingController();
  final _notasController = TextEditingController();
  String _tipo = 'cobrar';
  DateTime _fecha = DateTime.now();
  bool _saving = false;
  String? _error;

  bool get _isEditing => widget.editAccount != null;

  @override
  void initState() {
    super.initState();
    final a = widget.editAccount;
    if (a != null) {
      _tipo = a.tipo;
      _contraparteController.text = a.contraparte;
      _descripcionController.text = a.descripcion ?? '';
      _montoController.text = a.montoOriginal.toStringAsFixed(2);
      _notasController.text = a.notas ?? '';
      if (a.fecha != null) {
        try {
          _fecha = DateTime.parse(a.fecha!);
        } catch (_) {}
      }
    }
  }

  @override
  void dispose() {
    _contraparteController.dispose();
    _descripcionController.dispose();
    _montoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) setState(() => _fecha = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final body = <String, dynamic>{
      'tipo': _tipo,
      'contraparte': _contraparteController.text.trim(),
      'descripcion': _descripcionController.text.trim().isEmpty
          ? null
          : _descripcionController.text.trim(),
      'monto_original': double.parse(_montoController.text),
      'fecha': _fecha.toIso8601String().substring(0, 10),
      'notas': _notasController.text.trim().isEmpty
          ? null
          : _notasController.text.trim(),
    };
    try {
      final api = context.read<ApiService>();
      if (_isEditing) {
        await api.put('/api/mobile/accounts/${widget.editAccount!.id}', body);
      } else {
        await api.post('/api/mobile/accounts', body);
      }
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      if (!mounted) return;
      final repo = context.read<LocalRepository>();
      final monto = double.parse(_montoController.text);
      if (_isEditing) {
        final ea = widget.editAccount!;
        await repo.addPendingOp(
          entityType: 'account',
          operation: 'update',
          entityId: ea.id,
          endpoint: '/api/mobile/accounts/${ea.id}',
          payload: jsonEncode(body),
        );
        repo.upsertAccount(Account(
          id: ea.id,
          tipo: _tipo,
          contraparte: _contraparteController.text.trim(),
          descripcion: body['descripcion'] as String?,
          montoOriginal: monto,
          pagado: ea.pagado,
          saldo: monto - ea.pagado,
          estado: ea.estado,
          fecha: _fecha.toIso8601String().substring(0, 10),
          notas: body['notas'] as String?,
        ));
      } else {
        final tempId = -DateTime.now().millisecondsSinceEpoch;
        await repo.addPendingOp(
          entityType: 'account',
          operation: 'create',
          tempId: tempId,
          endpoint: '/api/mobile/accounts',
          payload: jsonEncode(body),
        );
        repo.upsertAccount(Account(
          id: tempId,
          tipo: _tipo,
          contraparte: _contraparteController.text.trim(),
          descripcion: body['descripcion'] as String?,
          montoOriginal: monto,
          pagado: 0,
          saldo: monto,
          estado: 'pendiente',
          fecha: _fecha.toIso8601String().substring(0, 10),
          notas: body['notas'] as String?,
        ));
      }
      SyncToast.show(context, 'Guardado localmente. Se sincronizará al reconectar.');
      widget.onSaved();
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
                // Tipo toggle
                Row(
                  children: [
                    Text('Tipo: ',
                        style: GoogleFonts.inter(
                            fontSize: 13, color: AppTheme.colorTextoSecundario)),
                    const SizedBox(width: 8),
                    _TypeToggle(
                      value: _tipo,
                      onChanged: (v) => setState(() => _tipo = v),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _contraparteController,
                  decoration: const InputDecoration(
                      labelText: 'Contraparte (cliente / proveedor) *'),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _descripcionController,
                  decoration:
                      const InputDecoration(labelText: 'Concepto / descripción'),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _montoController,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'Monto total (MXN) *'),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Requerido';
                    if (double.tryParse(v) == null) return 'Número inválido';
                    if (double.parse(v) <= 0) return 'Debe ser mayor a 0';
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: _pickDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(labelText: 'Fecha'),
                    child: Text(_formatDate(_fecha),
                        style: GoogleFonts.inter(fontSize: 14)),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _notasController,
                  decoration: const InputDecoration(labelText: 'Notas (opcional)'),
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
              : Text(_isEditing ? 'Guardar cambios' : 'Crear cuenta'),
        ),
      ],
    );
  }
}

// ── Toggle cobrar/pagar ───────────────────────────────────────────────────────

class _TypeToggle extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _TypeToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ToggleBtn(
          label: 'Por cobrar',
          selected: value == 'cobrar',
          color: AppTheme.colorExito,
          onTap: () => onChanged('cobrar'),
        ),
        const SizedBox(width: 6),
        _ToggleBtn(
          label: 'Por pagar',
          selected: value == 'pagar',
          color: AppTheme.colorError,
          onTap: () => onChanged('pagar'),
        ),
      ],
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ToggleBtn(
      {required this.label,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? color : AppTheme.colorBorde,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? color : AppTheme.colorTextoSecundario,
          ),
        ),
      ),
    );
  }
}

// ── Dialog: Registrar abono ───────────────────────────────────────────────────

class _NewPaymentDialog extends StatefulWidget {
  final Account account;
  final VoidCallback onSaved;

  const _NewPaymentDialog({required this.account, required this.onSaved});

  @override
  State<_NewPaymentDialog> createState() => _NewPaymentDialogState();
}

class _NewPaymentDialogState extends State<_NewPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  final _notasController = TextEditingController();
  DateTime _fecha = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _montoController.dispose();
    _notasController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) setState(() => _fecha = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    final payBody = {
      'monto': double.parse(_montoController.text),
      'fecha': _fecha.toIso8601String().substring(0, 10),
      'notas': _notasController.text.trim().isEmpty
          ? null
          : _notasController.text.trim(),
    };
    try {
      final api = context.read<ApiService>();
      await api.post('/api/mobile/accounts/${widget.account.id}/payments', payBody);
      if (mounted) widget.onSaved();
    } on ApiOfflineException {
      if (!mounted) return;
      final repo = context.read<LocalRepository>();
      final tempId = -DateTime.now().millisecondsSinceEpoch;
      await repo.addPendingOp(
        entityType: 'payment',
        operation: 'create',
        tempId: tempId,
        endpoint: '/api/mobile/accounts/${widget.account.id}/payments',
        payload: jsonEncode(payBody),
      );
      repo.upsertPayments([
        AccountPayment(
          id: tempId,
          accountId: widget.account.id,
          monto: double.parse(_montoController.text),
          fecha: _fecha.toIso8601String().substring(0, 10),
          notas: payBody['notas'] as String?,
        ),
      ]);
      SyncToast.show(context, 'Abono guardado localmente. Se sincronizará al reconectar.');
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'No se pudo registrar el abono.';
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.account;
    return AlertDialog(
      title: Text('Registrar abono',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Saldo pendiente: \$${a.saldo.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.colorTextoSecundario),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto del abono *'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Requerido';
                  final d = double.tryParse(v);
                  if (d == null) return 'Número inválido';
                  if (d <= 0) return 'Debe ser mayor a 0';
                  if (d > a.saldo) return 'Excede el saldo (\$${a.saldo.toStringAsFixed(2)})';
                  return null;
                },
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Fecha'),
                  child: Text(_formatDate(_fecha),
                      style: GoogleFonts.inter(fontSize: 14)),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _notasController,
                decoration: const InputDecoration(labelText: 'Notas (opcional)'),
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
              : const Text('Registrar abono'),
        ),
      ],
    );
  }
}
