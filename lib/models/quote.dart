class Quote {
  final int id;
  final int projectId;
  final String? description;
  final double amountMxn;
  final String currency;
  final String status; // 'pendiente' | 'aprobada' | 'rechazada'
  final String createdAt;

  Quote({
    required this.id,
    required this.projectId,
    this.description,
    required this.amountMxn,
    required this.currency,
    required this.status,
    required this.createdAt,
  });

  String get statusLabel {
    switch (status) {
      case 'pendiente':
        return 'Pendiente';
      case 'aprobada':
        return 'Aprobada';
      case 'rechazada':
        return 'Rechazada';
      default:
        return status;
    }
  }

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: (json['id'] as num).toInt(),
      projectId: (json['project_id'] as num).toInt(),
      description: json['description'] as String?,
      amountMxn: _toDouble(json['amount_mxn']),
      currency: json['currency'] as String? ?? 'MXN',
      status: json['status'] as String? ?? 'pendiente',
      createdAt: json['created_at'] as String? ?? '',
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
