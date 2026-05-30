class DashboardStats {
  final double incomeMtd;
  final double expenseMtd;
  final double balance;
  final int activeProjects;
  final List<RecentTransaction> recentTransactions;
  final int month;
  final int year;

  DashboardStats({
    required this.incomeMtd,
    required this.expenseMtd,
    required this.balance,
    required this.activeProjects,
    required this.recentTransactions,
    required this.month,
    required this.year,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    final txns = (json['recent_transactions'] as List<dynamic>? ?? [])
        .map((e) => RecentTransaction.fromJson(e as Map<String, dynamic>))
        .toList();

    return DashboardStats(
      incomeMtd: _toDouble(json['income_mtd']),
      expenseMtd: _toDouble(json['expense_mtd']),
      balance: _toDouble(json['balance']),
      activeProjects: (json['active_projects'] as num?)?.toInt() ?? 0,
      recentTransactions: txns,
      month: (json['month'] as num?)?.toInt() ?? DateTime.now().month,
      year: (json['year'] as num?)?.toInt() ?? DateTime.now().year,
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}

class RecentTransaction {
  final int id;
  final String type; // 'income' | 'expense'
  final String description;
  final double amountMxn;
  final String transactionDate;
  final String? categoryName;
  final String? projectName;

  RecentTransaction({
    required this.id,
    required this.type,
    required this.description,
    required this.amountMxn,
    required this.transactionDate,
    this.categoryName,
    this.projectName,
  });

  bool get isIncome => type == 'income';

  factory RecentTransaction.fromJson(Map<String, dynamic> json) {
    return RecentTransaction(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String? ?? 'expense',
      description: json['description'] as String? ?? '',
      amountMxn: DashboardStats._toDouble(json['amount_mxn']),
      transactionDate: json['transaction_date'] as String? ?? '',
      categoryName: json['category_name'] as String?,
      projectName: json['project_name'] as String?,
    );
  }
}
