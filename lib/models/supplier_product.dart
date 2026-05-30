class SupplierProduct {
  final int id;
  final String nombre;
  final String? unidad;
  final double? precio;
  final String moneda;
  final String? notas;

  SupplierProduct({
    required this.id,
    required this.nombre,
    this.unidad,
    this.precio,
    required this.moneda,
    this.notas,
  });

  factory SupplierProduct.fromJson(Map<String, dynamic> json) {
    return SupplierProduct(
      id: (json['id'] as num).toInt(),
      nombre: json['nombre'] as String? ?? '',
      unidad: json['unidad'] as String?,
      precio: json['precio'] != null ? (json['precio'] as num).toDouble() : null,
      moneda: json['moneda'] as String? ?? 'MXN',
      notas: json['notas'] as String?,
    );
  }
}
