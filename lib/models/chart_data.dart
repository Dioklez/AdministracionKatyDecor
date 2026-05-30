class MonthlyChartData {
  final String label; // Ej: "Ene", "Feb"
  final double income;
  final double expense;

  MonthlyChartData({
    required this.label,
    required this.income,
    required this.expense,
  });

  static final List<String> _meses = [
    'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
    'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic',
  ];

  /// Parsea la respuesta de /api/graficas/ingreso-egreso.
  /// El endpoint devuelve una lista de objetos con campos variables.
  /// Intentamos adaptar los formatos más comunes.
  static List<MonthlyChartData> fromApiResponse(dynamic response) {
    if (response == null) return _emptyLast6Months();

    // Si es una lista de objetos mensuales
    if (response is List) {
      return response.map((item) {
        final m = item as Map<String, dynamic>;
        final mes = _extractMes(m);
        final income = _toDouble(m['ingresos'] ?? m['income'] ?? m['ingreso'] ?? 0);
        final expense = _toDouble(m['egresos'] ?? m['expense'] ?? m['egreso'] ?? 0);
        return MonthlyChartData(label: mes, income: income, expense: expense);
      }).toList();
    }

    // Si es un mapa con claves separadas
    if (response is Map<String, dynamic>) {
      final meses = response['meses'] as List<dynamic>?;
      final ingresos = response['ingresos'] as List<dynamic>?;
      final egresos = response['egresos'] as List<dynamic>?;
      if (meses != null && ingresos != null && egresos != null) {
        return List.generate(meses.length, (i) {
          return MonthlyChartData(
            label: meses[i].toString(),
            income: _toDouble(ingresos[i]),
            expense: _toDouble(egresos[i]),
          );
        });
      }
    }

    return _emptyLast6Months();
  }

  static String _extractMes(Map<String, dynamic> m) {
    // Intenta extraer el nombre del mes de varios campos posibles
    if (m.containsKey('mes_nombre')) return m['mes_nombre'].toString();
    if (m.containsKey('month_name')) return m['month_name'].toString();
    if (m.containsKey('mes')) {
      final v = m['mes'];
      if (v is int && v >= 1 && v <= 12) return _meses[v - 1];
      return v.toString();
    }
    if (m.containsKey('month')) {
      final v = m['month'];
      if (v is int && v >= 1 && v <= 12) return _meses[v - 1];
      return v.toString();
    }
    return '';
  }

  static List<MonthlyChartData> _emptyLast6Months() {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final month = now.month - 5 + i;
      final adjusted = ((month - 1) % 12 + 12) % 12;
      return MonthlyChartData(
        label: _meses[adjusted],
        income: 0,
        expense: 0,
      );
    });
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
