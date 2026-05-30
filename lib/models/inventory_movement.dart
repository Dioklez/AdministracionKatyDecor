class InventoryMovement {
  final int id;
  final int itemId;
  final String tipo; // 'entrada' | 'salida' | 'ajuste'
  final double cantidad;
  final double? precioUnitario;
  final String? referencia;
  final String? fecha;
  final String? createdAt;

  InventoryMovement({
    required this.id,
    required this.itemId,
    required this.tipo,
    required this.cantidad,
    this.precioUnitario,
    this.referencia,
    this.fecha,
    this.createdAt,
  });

  factory InventoryMovement.fromJson(Map<String, dynamic> json) =>
      InventoryMovement(
        id: json['id'] as int,
        itemId: json['item_id'] as int,
        tipo: json['tipo'] as String,
        cantidad: (json['cantidad'] as num).toDouble(),
        precioUnitario: json['precio_unitario'] != null
            ? (json['precio_unitario'] as num).toDouble()
            : null,
        referencia: json['referencia'] as String?,
        fecha: json['fecha'] as String?,
        createdAt: json['created_at'] as String?,
      );
}
