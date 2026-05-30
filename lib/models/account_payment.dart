class AccountPayment {
  final int id;
  final int accountId;
  final double monto;
  final String? fecha;
  final String? notas;
  final String? createdAt;

  AccountPayment({
    required this.id,
    required this.accountId,
    required this.monto,
    this.fecha,
    this.notas,
    this.createdAt,
  });

  factory AccountPayment.fromJson(Map<String, dynamic> json) => AccountPayment(
        id: json['id'] as int,
        accountId: json['account_id'] as int,
        monto: (json['monto'] as num).toDouble(),
        fecha: json['fecha'] as String?,
        notas: json['notas'] as String?,
        createdAt: json['created_at'] as String?,
      );
}
