class Budget {
  final int budgetId;
  final int categoryId;
  final String categoryName;
  final String scopeType;
  final double limit;
  final double spent;
  final double remaining;
  final double pct;
  final String alertLevel; // 'ok' | 'warning' | 'danger'
  final int alertThresholdPct;

  Budget({
    required this.budgetId,
    required this.categoryId,
    required this.categoryName,
    required this.scopeType,
    required this.limit,
    required this.spent,
    required this.remaining,
    required this.pct,
    required this.alertLevel,
    required this.alertThresholdPct,
  });

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
        budgetId: json['budget_id'] as int,
        categoryId: json['category_id'] as int,
        categoryName: json['category_name'] as String,
        scopeType: json['scope_type'] as String,
        limit: (json['limit'] as num).toDouble(),
        spent: (json['spent'] as num).toDouble(),
        remaining: (json['remaining'] as num).toDouble(),
        pct: (json['pct'] as num).toDouble(),
        alertLevel: json['alert_level'] as String,
        alertThresholdPct: (json['alert_threshold_pct'] as num).toInt(),
      );
}
