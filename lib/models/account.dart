class Account {
  final int id;
  final String tipo; // 'cobrar' | 'pagar'
  final String contraparte;
  final String? descripcion;
  final double montoOriginal;
  final double pagado;
  final double saldo;
  final String estado; // 'pendiente' | 'parcial' | 'cancelada'
  final String? fecha;
  final String? notas;
  final String? createdAt;

  Account({
    required this.id,
    required this.tipo,
    required this.contraparte,
    this.descripcion,
    required this.montoOriginal,
    required this.pagado,
    required this.saldo,
    required this.estado,
    this.fecha,
    this.notas,
    this.createdAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        id: json['id'] as int,
        tipo: json['tipo'] as String,
        contraparte: json['contraparte'] as String,
        descripcion: json['descripcion'] as String?,
        montoOriginal: (json['monto_original'] as num).toDouble(),
        pagado: (json['pagado'] as num).toDouble(),
        saldo: (json['saldo'] as num).toDouble(),
        estado: json['estado'] as String,
        fecha: json['fecha'] as String?,
        notas: json['notas'] as String?,
        createdAt: json['created_at'] as String?,
      );

  double get pctPagado =>
      montoOriginal > 0 ? (pagado / montoOriginal).clamp(0.0, 1.0) : 0.0;
}
