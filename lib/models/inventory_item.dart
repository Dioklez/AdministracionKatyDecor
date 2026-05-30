class InventoryItem {
  final int id;
  final String? codigo;
  final String nombre;
  final String? descripcion;
  final String tipo; // 'venta' | 'material'
  final String? categoria;
  final String unidad;
  final double stockActual;
  final double? stockMinimo;
  final double precioUnitario;
  final int? proveedorId;
  final bool activo;
  final String? notas;
  final double valorTotal;

  InventoryItem({
    required this.id,
    this.codigo,
    required this.nombre,
    this.descripcion,
    required this.tipo,
    this.categoria,
    required this.unidad,
    required this.stockActual,
    this.stockMinimo,
    required this.precioUnitario,
    this.proveedorId,
    required this.activo,
    this.notas,
    required this.valorTotal,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) => InventoryItem(
        id: json['id'] as int,
        codigo: json['codigo'] as String?,
        nombre: json['nombre'] as String,
        descripcion: json['descripcion'] as String?,
        tipo: json['tipo'] as String,
        categoria: json['categoria'] as String?,
        unidad: json['unidad'] as String? ?? 'pieza',
        stockActual: (json['stock_actual'] as num).toDouble(),
        stockMinimo: json['stock_minimo'] != null
            ? (json['stock_minimo'] as num).toDouble()
            : null,
        precioUnitario: (json['precio_unitario'] as num).toDouble(),
        proveedorId: json['proveedor_id'] as int?,
        activo: json['activo'] as bool? ?? true,
        notas: json['notas'] as String?,
        valorTotal: (json['valor_total'] as num?)?.toDouble() ??
            ((json['stock_actual'] as num).toDouble() *
                (json['precio_unitario'] as num).toDouble()),
      );

  bool get isBajoStock =>
      stockMinimo != null && stockActual <= stockMinimo!;
}
