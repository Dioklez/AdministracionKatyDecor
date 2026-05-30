import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../database/local_repository.dart';
import '../../models/transaction.dart';
import '../../models/chart_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/shimmer_box.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Transaction> _transactions = [];
  List<MonthlyChartData> _chartData = [];
  int _activeProjects = 0;
  bool _loading = true;
  String? _error;

  DateTime? _dateFrom;
  DateTime? _dateTo;

  // Controladores de texto para los campos de fecha
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final api = context.read<ApiService>();

      // Construir query de transacciones con filtro de fechas opcional
      String txnEndpoint = '/api/mobile/transactions';
      final params = <String>[];
      if (_dateFrom != null) {
        params.add('date_from=${_dateFrom!.toIso8601String().substring(0, 10)}');
      }
      if (_dateTo != null) {
        params.add('date_to=${_dateTo!.toIso8601String().substring(0, 10)}');
      }
      if (params.isNotEmpty) txnEndpoint += '?${params.join('&')}';

      final results = await Future.wait([
        api.get(txnEndpoint),
        api.get('/api/mobile/projects?status=active'),
        api.get('/api/graficas/ingreso-egreso'),
      ]);

      if (mounted) {
        final txnList = (results[0] as List<dynamic>? ?? [])
            .map((e) => Transaction.fromJson(e as Map<String, dynamic>))
            .toList();

        final projectList = (results[1] as List<dynamic>? ?? []);

        // Guardar en local (fire-and-forget)
        final repo = context.read<LocalRepository>();
        repo.upsertTransactions(txnList);
        repo.setCacheEntry('graficas/ingreso-egreso', jsonEncode(results[2]));

        setState(() {
          _transactions = txnList;
          _activeProjects = projectList.length;
          _chartData = MonthlyChartData.fromApiResponse(results[2]);
          _loading = false;
        });
      }
    } on ApiOfflineException {
      await _loadFromLocal();
    } catch (e) {
      await _loadFromLocal();
    }
  }

  Future<void> _loadFromLocal() async {
    try {
      final repo = context.read<LocalRepository>();
      final from = _dateFrom?.toIso8601String().substring(0, 10);
      final to = _dateTo?.toIso8601String().substring(0, 10);
      final txnList = await repo.getTransactionsByDateRange(from, to);
      final activeProjects = await repo.getProjectsByStatus('active');
      final cachedChart = await repo.getCacheEntry('graficas/ingreso-egreso');
      List<MonthlyChartData> chartData = [];
      if (cachedChart != null) {
        try {
          chartData = MonthlyChartData.fromApiResponse(jsonDecode(cachedChart));
        } catch (_) {}
      }
      if (mounted) {
        setState(() {
          _transactions = txnList;
          _activeProjects = activeProjects.length;
          _chartData = chartData;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Sin datos disponibles.';
          _loading = false;
        });
      }
    }
  }

  void _clearFilter() {
    setState(() {
      _dateFrom = null;
      _dateTo = null;
      _fromController.clear();
      _toController.clear();
    });
    _loadData();
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final initial = isFrom
        ? (_dateFrom ?? DateTime.now())
        : (_dateTo ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom) {
          _dateFrom = picked;
          _fromController.text = _formatDateDisplay(picked);
        } else {
          _dateTo = picked;
          _toController.text = _formatDateDisplay(picked);
        }
      });
    }
  }

  // ── Cómputos client-side ───────────────────────────────────────────────────

  double get _totalIncome =>
      _transactions.where((t) => t.isIncome).fold(0.0, (s, t) => s + t.amountMxn);

  double get _totalExpense =>
      _transactions.where((t) => !t.isIncome).fold(0.0, (s, t) => s + t.amountMxn);

  double get _balance => _totalIncome - _totalExpense;

  List<Transaction> get _recentTransactions {
    final sorted = List<Transaction>.from(_transactions)
      ..sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
    return sorted.take(10).toList();
  }

  String get _subtitleLabel {
    if (_dateFrom == null && _dateTo == null) return 'Todo el historial';
    if (_dateFrom != null && _dateTo != null) {
      return '${_formatDateDisplay(_dateFrom!)} – ${_formatDateDisplay(_dateTo!)}';
    }
    if (_dateFrom != null) return 'Desde ${_formatDateDisplay(_dateFrom!)}';
    return 'Hasta ${_formatDateDisplay(_dateTo!)}';
  }

  // ── Helpers de formato ─────────────────────────────────────────────────────

  String _formatDateDisplay(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _formatMxn(double value) {
    final abs = value.abs();
    String formatted;
    if (abs >= 1000000) {
      formatted = '\$${(abs / 1000000).toStringAsFixed(1)}M';
    } else if (abs >= 1000) {
      formatted = '\$${_addThousandsSep(abs.toStringAsFixed(0))}';
    } else {
      formatted = '\$${abs.toStringAsFixed(0)}';
    }
    return value < 0 ? '-$formatted' : formatted;
  }

  String _addThousandsSep(String s) {
    final result = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) result.write(',');
      result.write(s[i]);
    }
    return result.toString();
  }

  String _formatMxnShort(double v) {
    if (v >= 1000000) return '\$${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\$${(v / 1000).toStringAsFixed(0)}k';
    return '\$${v.toStringAsFixed(0)}';
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.colorFondo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 12),
            child: Row(
              children: [
                Text(
                  'Dashboard',
                  style: GoogleFonts.inter(
                    fontSize: AppTheme.tamanoTituloPagina,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.colorTexto,
                  ),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: _loading ? null : _loadData,
                  icon: const Icon(Icons.refresh_outlined, size: 16),
                  label: const Text('Actualizar'),
                ),
              ],
            ),
          ),

          // ── Selector de rango de fechas ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 12),
            child: _buildDateRangeRow(),
          ),

          const Divider(height: 1),

          // ── Cuerpo scrollable ─────────────────────────────────────────────
          Expanded(
            child: _error != null
                ? _buildError()
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _loading ? _buildStatCardsShimmer() : _buildStatCards(),
                        const SizedBox(height: 28),
                        LayoutBuilder(builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 760;
                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: _loading
                                      ? _buildTableShimmer()
                                      : _buildTransactionsTable(),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 4,
                                  child: _loading
                                      ? _buildChartShimmer()
                                      : _buildChart(),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                _loading
                                    ? _buildTableShimmer()
                                    : _buildTransactionsTable(),
                                const SizedBox(height: 20),
                                _loading ? _buildChartShimmer() : _buildChart(),
                              ],
                            );
                          }
                        }),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ── Selector de fechas ────────────────────────────────────────────────────

  Widget _buildDateRangeRow() {
    final hasFilter = _dateFrom != null || _dateTo != null;
    return Row(
      children: [
        const Icon(Icons.date_range_outlined, size: 16, color: AppTheme.colorTextoSecundario),
        const SizedBox(width: 8),
        SizedBox(
          width: 140,
          height: 36,
          child: TextFormField(
            controller: _fromController,
            readOnly: true,
            onTap: () => _pickDate(isFrom: true),
            decoration: InputDecoration(
              hintText: 'Desde',
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                borderSide: const BorderSide(color: AppTheme.colorBorde),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                borderSide: const BorderSide(color: AppTheme.colorBorde),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                borderSide: const BorderSide(color: AppTheme.colorPrimario, width: 1.5),
              ),
              fillColor: AppTheme.colorCard,
              filled: true,
            ),
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.colorTexto),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 140,
          height: 36,
          child: TextFormField(
            controller: _toController,
            readOnly: true,
            onTap: () => _pickDate(isFrom: false),
            decoration: InputDecoration(
              hintText: 'Hasta',
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                borderSide: const BorderSide(color: AppTheme.colorBorde),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                borderSide: const BorderSide(color: AppTheme.colorBorde),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusInput),
                borderSide: const BorderSide(color: AppTheme.colorPrimario, width: 1.5),
              ),
              fillColor: AppTheme.colorCard,
              filled: true,
            ),
            style: GoogleFonts.inter(fontSize: 13, color: AppTheme.colorTexto),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 36,
          child: ElevatedButton(
            onPressed: _loading ? null : _loadData,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: const Text('Aplicar'),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: _loading ? null : _clearFilter,
          style: TextButton.styleFrom(
            foregroundColor: AppTheme.colorTextoSecundario,
            padding: const EdgeInsets.symmetric(horizontal: 10),
          ),
          child: const Text('Todo el historial'),
        ),
        if (hasFilter) ...[
          const SizedBox(width: 8),
          Chip(
            label: Text(
              _subtitleLabel,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppTheme.colorPrimario,
              ),
            ),
            backgroundColor: AppTheme.colorPrimario.withAlpha(20),
            deleteIcon: const Icon(Icons.close, size: 14),
            deleteIconColor: AppTheme.colorPrimario,
            onDeleted: _clearFilter,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ],
    );
  }

  // ── Stat cards ────────────────────────────────────────────────────────────

  Widget _buildStatCards() {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Total ingresos',
            value: _formatMxn(_totalIncome),
            icon: Icons.arrow_downward_outlined,
            valueColor: AppTheme.colorExito,
            subtitle: _subtitleLabel,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Total egresos',
            value: _formatMxn(_totalExpense),
            icon: Icons.arrow_upward_outlined,
            valueColor: AppTheme.colorError,
            subtitle: _subtitleLabel,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Balance',
            value: _formatMxn(_balance),
            icon: Icons.account_balance_wallet_outlined,
            valueColor: _balance >= 0 ? AppTheme.colorExito : AppTheme.colorError,
            subtitle: _subtitleLabel,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: StatCard(
            title: 'Proyectos activos',
            value: _activeProjects.toString(),
            icon: Icons.folder_outlined,
            valueColor: AppTheme.colorTexto,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCardsShimmer() {
    return const Row(
      children: [
        Expanded(child: StatCardShimmer()),
        SizedBox(width: 16),
        Expanded(child: StatCardShimmer()),
        SizedBox(width: 16),
        Expanded(child: StatCardShimmer()),
        SizedBox(width: 16),
        Expanded(child: StatCardShimmer()),
      ],
    );
  }

  // ── Tabla de transacciones recientes ──────────────────────────────────────

  Widget _buildTransactionsTable() {
    final txns = _recentTransactions;
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'Transacciones recientes',
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.colorTexto,
              ),
            ),
          ),
          const Divider(height: 1),
          if (txns.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Sin transacciones en el periodo seleccionado',
                  style: GoogleFonts.inter(color: AppTheme.colorTextoSecundario),
                ),
              ),
            )
          else
            ...txns.map((t) => _DashboardTransactionRow(transaction: t)),
        ],
      ),
    );
  }

  Widget _buildTableShimmer() {
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
          const ShimmerBox(width: 200, height: 18),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          for (int i = 0; i < 6; i++) ...[
            const Row(
              children: [
                ShimmerBox(width: 28, height: 28, borderRadius: 14),
                SizedBox(width: 10),
                Expanded(child: ShimmerBox(height: 14)),
                SizedBox(width: 16),
                ShimmerBox(width: 80, height: 14),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  // ── Gráfica ───────────────────────────────────────────────────────────────

  Widget _buildChart() {
    if (_chartData.isEmpty) {
      return Container(
        height: 240,
        decoration: BoxDecoration(
          color: AppTheme.colorCard,
          borderRadius: BorderRadius.circular(AppTheme.radiusCard),
          boxShadow: AppTheme.sombraCard,
        ),
        child: Center(
          child: Text(
            'Sin datos de gráfica',
            style: GoogleFonts.inter(color: AppTheme.colorTextoSecundario),
          ),
        ),
      );
    }

    final maxVal = _chartData.fold<double>(0, (prev, d) {
      final m = d.income > d.expense ? d.income : d.expense;
      return m > prev ? m : prev;
    });
    final chartMax = maxVal * 1.2 == 0 ? 1000.0 : maxVal * 1.2;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingresos vs Egresos',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.colorTexto,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Últimos 6 meses',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppTheme.colorTextoSecundario,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _LegendDot(color: AppTheme.colorExito, label: 'Ingresos'),
              const SizedBox(width: 16),
              _LegendDot(color: AppTheme.colorError, label: 'Egresos'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                maxY: chartMax,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: chartMax / 4,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: AppTheme.colorBorde,
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 48,
                      getTitlesWidget: (value, _) => Text(
                        _formatMxnShort(value),
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppTheme.colorTextoSecundario,
                        ),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final i = value.toInt();
                        if (i < 0 || i >= _chartData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            _chartData[i].label,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.colorTextoSecundario,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(_chartData.length, (i) {
                  final d = _chartData[i];
                  return BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: d.income,
                        color: AppTheme.colorExito,
                        width: 10,
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                      BarChartRodData(
                        toY: d.expense,
                        color: AppTheme.colorError,
                        width: 10,
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(4)),
                      ),
                    ],
                  );
                }),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => AppTheme.colorTexto.withAlpha(230),
                    tooltipPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final label = rodIndex == 0 ? 'Ingresos' : 'Egresos';
                      return BarTooltipItem(
                        '$label\n${_formatMxn(rod.toY)}',
                        GoogleFonts.inter(fontSize: 11, color: Colors.white),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartShimmer() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.colorCard,
        borderRadius: BorderRadius.circular(AppTheme.radiusCard),
        boxShadow: AppTheme.sombraCard,
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(width: 180, height: 18),
          SizedBox(height: 8),
          ShimmerBox(width: 120, height: 12),
          SizedBox(height: 20),
          Expanded(child: ShimmerBox(height: double.infinity)),
        ],
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
          Text(
            _error!,
            style: GoogleFonts.inter(color: AppTheme.colorTextoSecundario),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: _loadData, child: const Text('Reintentar')),
        ],
      ),
    );
  }
}

// ── Fila de transacción en dashboard ──────────────────────────────────────────

class _DashboardTransactionRow extends StatelessWidget {
  final Transaction transaction;

  const _DashboardTransactionRow({required this.transaction});

  String _formatDate(String date) {
    if (date.length >= 10) {
      final parts = date.substring(0, 10).split('-');
      if (parts.length == 3) return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return date;
  }

  @override
  Widget build(BuildContext context) {
    final t = transaction;
    final isIncome = t.isIncome;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.colorBorde)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color:
                  (isIncome ? AppTheme.colorExito : AppTheme.colorError).withAlpha(26),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome
                  ? Icons.arrow_downward_outlined
                  : Icons.arrow_upward_outlined,
              size: 14,
              color: isIncome ? AppTheme.colorExito : AppTheme.colorError,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.description.isNotEmpty
                      ? t.description
                      : (t.categoryName ?? 'Sin descripción'),
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.colorTexto,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (t.categoryName != null)
                  Text(
                    t.categoryName!,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.colorTextoSecundario,
                    ),
                  ),
              ],
            ),
          ),
          if (t.projectName != null) ...[
            const SizedBox(width: 8),
            _ProjectPill(name: t.projectName!, colorHex: t.projectColor),
          ],
          const SizedBox(width: 12),
          Text(
            _formatDate(t.transactionDate),
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppTheme.colorTextoSecundario,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${isIncome ? '+' : '-'}\$${t.amountMxn.toStringAsFixed(0)}',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isIncome ? AppTheme.colorExito : AppTheme.colorError,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectPill extends StatelessWidget {
  final String name;
  final String? colorHex;

  const _ProjectPill({required this.name, this.colorHex});

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
    final c = _parseColor();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.withAlpha(30),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        name,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w500, color: c),
      ),
    );
  }
}

// ── Leyenda gráfica ───────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.colorTextoSecundario,
          ),
        ),
      ],
    );
  }
}
