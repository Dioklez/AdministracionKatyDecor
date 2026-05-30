class Transaction {
  final int id;
  final String type; // 'income' | 'expense'
  final String scopeType; // 'general' | 'project'
  final int? scopeId;
  final int? categoryId;
  final String? categoryName;
  final String? projectName;
  final String? projectColor;
  final String description;
  final double amount;
  final String currency;
  final double exchangeRate;
  final double amountMxn;
  final String transactionDate;
  final String? etapa;
  final String? notes;
  final String createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.scopeType,
    this.scopeId,
    this.categoryId,
    this.categoryName,
    this.projectName,
    this.projectColor,
    required this.description,
    required this.amount,
    required this.currency,
    required this.exchangeRate,
    required this.amountMxn,
    required this.transactionDate,
    this.etapa,
    this.notes,
    required this.createdAt,
  });

  bool get isIncome => type == 'income';
  bool get isProjectScoped => scopeType == 'project';

  // Derived project id from scopeId when scope is 'project'
  int? get projectId => isProjectScoped ? scopeId : null;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String? ?? 'expense',
      scopeType: json['scope_type'] as String? ?? 'general',
      scopeId: (json['scope_id'] as num?)?.toInt(),
      categoryId: (json['category_id'] as num?)?.toInt(),
      categoryName: json['category_name'] as String?,
      projectName: json['project_name'] as String?,
      projectColor: json['project_color'] as String?,
      description: json['description'] as String? ?? '',
      amount: _toDouble(json['amount']),
      currency: json['currency'] as String? ?? 'MXN',
      exchangeRate: _toDouble(json['exchange_rate']) == 0 ? 1.0 : _toDouble(json['exchange_rate']),
      amountMxn: _toDouble(json['amount_mxn']),
      transactionDate: json['transaction_date'] as String? ?? '',
      etapa: json['etapa'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'scope_type': scopeType,
      if (scopeId != null) 'scope_id': scopeId,
      if (categoryId != null) 'category_id': categoryId,
      'description': description,
      'amount': amount,
      'currency': currency,
      'exchange_rate': exchangeRate,
      'amount_mxn': amountMxn,
      'transaction_date': transactionDate,
      if (etapa != null) 'etapa': etapa,
      if (notes != null) 'notes': notes,
    };
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
