// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _codigoMeta = const VerificationMeta('codigo');
  @override
  late final GeneratedColumn<String> codigo = GeneratedColumn<String>(
    'codigo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nombreMeta = const VerificationMeta('nombre');
  @override
  late final GeneratedColumn<String> nombre = GeneratedColumn<String>(
    'nombre',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descripcionMeta = const VerificationMeta(
    'descripcion',
  );
  @override
  late final GeneratedColumn<String> descripcion = GeneratedColumn<String>(
    'descripcion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoriaMeta = const VerificationMeta(
    'categoria',
  );
  @override
  late final GeneratedColumn<String> categoria = GeneratedColumn<String>(
    'categoria',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
    'unidad',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pieza'),
  );
  static const VerificationMeta _stockActualMeta = const VerificationMeta(
    'stockActual',
  );
  @override
  late final GeneratedColumn<double> stockActual = GeneratedColumn<double>(
    'stock_actual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _stockMinimoMeta = const VerificationMeta(
    'stockMinimo',
  );
  @override
  late final GeneratedColumn<double> stockMinimo = GeneratedColumn<double>(
    'stock_minimo',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _proveedorIdMeta = const VerificationMeta(
    'proveedorId',
  );
  @override
  late final GeneratedColumn<int> proveedorId = GeneratedColumn<int>(
    'proveedor_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activoMeta = const VerificationMeta('activo');
  @override
  late final GeneratedColumn<bool> activo = GeneratedColumn<bool>(
    'activo',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("activo" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notasMeta = const VerificationMeta('notas');
  @override
  late final GeneratedColumn<String> notas = GeneratedColumn<String>(
    'notas',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valorTotalMeta = const VerificationMeta(
    'valorTotal',
  );
  @override
  late final GeneratedColumn<double> valorTotal = GeneratedColumn<double>(
    'valor_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    codigo,
    nombre,
    descripcion,
    tipo,
    categoria,
    unidad,
    stockActual,
    stockMinimo,
    precioUnitario,
    proveedorId,
    activo,
    notas,
    valorTotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('codigo')) {
      context.handle(
        _codigoMeta,
        codigo.isAcceptableOrUnknown(data['codigo']!, _codigoMeta),
      );
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('categoria')) {
      context.handle(
        _categoriaMeta,
        categoria.isAcceptableOrUnknown(data['categoria']!, _categoriaMeta),
      );
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    }
    if (data.containsKey('stock_actual')) {
      context.handle(
        _stockActualMeta,
        stockActual.isAcceptableOrUnknown(
          data['stock_actual']!,
          _stockActualMeta,
        ),
      );
    }
    if (data.containsKey('stock_minimo')) {
      context.handle(
        _stockMinimoMeta,
        stockMinimo.isAcceptableOrUnknown(
          data['stock_minimo']!,
          _stockMinimoMeta,
        ),
      );
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    }
    if (data.containsKey('proveedor_id')) {
      context.handle(
        _proveedorIdMeta,
        proveedorId.isAcceptableOrUnknown(
          data['proveedor_id']!,
          _proveedorIdMeta,
        ),
      );
    }
    if (data.containsKey('activo')) {
      context.handle(
        _activoMeta,
        activo.isAcceptableOrUnknown(data['activo']!, _activoMeta),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    if (data.containsKey('valor_total')) {
      context.handle(
        _valorTotalMeta,
        valorTotal.isAcceptableOrUnknown(data['valor_total']!, _valorTotalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      codigo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}codigo'],
      ),
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      ),
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      categoria: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}categoria'],
      ),
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      )!,
      stockActual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_actual'],
      )!,
      stockMinimo: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_minimo'],
      ),
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      )!,
      proveedorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proveedor_id'],
      ),
      activo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}activo'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
      valorTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}valor_total'],
      )!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }
}

class InventoryItemRow extends DataClass
    implements Insertable<InventoryItemRow> {
  final int id;
  final String? codigo;
  final String nombre;
  final String? descripcion;
  final String tipo;
  final String? categoria;
  final String unidad;
  final double stockActual;
  final double? stockMinimo;
  final double precioUnitario;
  final int? proveedorId;
  final bool activo;
  final String? notas;
  final double valorTotal;
  const InventoryItemRow({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || codigo != null) {
      map['codigo'] = Variable<String>(codigo);
    }
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || descripcion != null) {
      map['descripcion'] = Variable<String>(descripcion);
    }
    map['tipo'] = Variable<String>(tipo);
    if (!nullToAbsent || categoria != null) {
      map['categoria'] = Variable<String>(categoria);
    }
    map['unidad'] = Variable<String>(unidad);
    map['stock_actual'] = Variable<double>(stockActual);
    if (!nullToAbsent || stockMinimo != null) {
      map['stock_minimo'] = Variable<double>(stockMinimo);
    }
    map['precio_unitario'] = Variable<double>(precioUnitario);
    if (!nullToAbsent || proveedorId != null) {
      map['proveedor_id'] = Variable<int>(proveedorId);
    }
    map['activo'] = Variable<bool>(activo);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    map['valor_total'] = Variable<double>(valorTotal);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      codigo: codigo == null && nullToAbsent
          ? const Value.absent()
          : Value(codigo),
      nombre: Value(nombre),
      descripcion: descripcion == null && nullToAbsent
          ? const Value.absent()
          : Value(descripcion),
      tipo: Value(tipo),
      categoria: categoria == null && nullToAbsent
          ? const Value.absent()
          : Value(categoria),
      unidad: Value(unidad),
      stockActual: Value(stockActual),
      stockMinimo: stockMinimo == null && nullToAbsent
          ? const Value.absent()
          : Value(stockMinimo),
      precioUnitario: Value(precioUnitario),
      proveedorId: proveedorId == null && nullToAbsent
          ? const Value.absent()
          : Value(proveedorId),
      activo: Value(activo),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
      valorTotal: Value(valorTotal),
    );
  }

  factory InventoryItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItemRow(
      id: serializer.fromJson<int>(json['id']),
      codigo: serializer.fromJson<String?>(json['codigo']),
      nombre: serializer.fromJson<String>(json['nombre']),
      descripcion: serializer.fromJson<String?>(json['descripcion']),
      tipo: serializer.fromJson<String>(json['tipo']),
      categoria: serializer.fromJson<String?>(json['categoria']),
      unidad: serializer.fromJson<String>(json['unidad']),
      stockActual: serializer.fromJson<double>(json['stockActual']),
      stockMinimo: serializer.fromJson<double?>(json['stockMinimo']),
      precioUnitario: serializer.fromJson<double>(json['precioUnitario']),
      proveedorId: serializer.fromJson<int?>(json['proveedorId']),
      activo: serializer.fromJson<bool>(json['activo']),
      notas: serializer.fromJson<String?>(json['notas']),
      valorTotal: serializer.fromJson<double>(json['valorTotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'codigo': serializer.toJson<String?>(codigo),
      'nombre': serializer.toJson<String>(nombre),
      'descripcion': serializer.toJson<String?>(descripcion),
      'tipo': serializer.toJson<String>(tipo),
      'categoria': serializer.toJson<String?>(categoria),
      'unidad': serializer.toJson<String>(unidad),
      'stockActual': serializer.toJson<double>(stockActual),
      'stockMinimo': serializer.toJson<double?>(stockMinimo),
      'precioUnitario': serializer.toJson<double>(precioUnitario),
      'proveedorId': serializer.toJson<int?>(proveedorId),
      'activo': serializer.toJson<bool>(activo),
      'notas': serializer.toJson<String?>(notas),
      'valorTotal': serializer.toJson<double>(valorTotal),
    };
  }

  InventoryItemRow copyWith({
    int? id,
    Value<String?> codigo = const Value.absent(),
    String? nombre,
    Value<String?> descripcion = const Value.absent(),
    String? tipo,
    Value<String?> categoria = const Value.absent(),
    String? unidad,
    double? stockActual,
    Value<double?> stockMinimo = const Value.absent(),
    double? precioUnitario,
    Value<int?> proveedorId = const Value.absent(),
    bool? activo,
    Value<String?> notas = const Value.absent(),
    double? valorTotal,
  }) => InventoryItemRow(
    id: id ?? this.id,
    codigo: codigo.present ? codigo.value : this.codigo,
    nombre: nombre ?? this.nombre,
    descripcion: descripcion.present ? descripcion.value : this.descripcion,
    tipo: tipo ?? this.tipo,
    categoria: categoria.present ? categoria.value : this.categoria,
    unidad: unidad ?? this.unidad,
    stockActual: stockActual ?? this.stockActual,
    stockMinimo: stockMinimo.present ? stockMinimo.value : this.stockMinimo,
    precioUnitario: precioUnitario ?? this.precioUnitario,
    proveedorId: proveedorId.present ? proveedorId.value : this.proveedorId,
    activo: activo ?? this.activo,
    notas: notas.present ? notas.value : this.notas,
    valorTotal: valorTotal ?? this.valorTotal,
  );
  InventoryItemRow copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItemRow(
      id: data.id.present ? data.id.value : this.id,
      codigo: data.codigo.present ? data.codigo.value : this.codigo,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      categoria: data.categoria.present ? data.categoria.value : this.categoria,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      stockActual: data.stockActual.present
          ? data.stockActual.value
          : this.stockActual,
      stockMinimo: data.stockMinimo.present
          ? data.stockMinimo.value
          : this.stockMinimo,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      proveedorId: data.proveedorId.present
          ? data.proveedorId.value
          : this.proveedorId,
      activo: data.activo.present ? data.activo.value : this.activo,
      notas: data.notas.present ? data.notas.value : this.notas,
      valorTotal: data.valorTotal.present
          ? data.valorTotal.value
          : this.valorTotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemRow(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('categoria: $categoria, ')
          ..write('unidad: $unidad, ')
          ..write('stockActual: $stockActual, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('activo: $activo, ')
          ..write('notas: $notas, ')
          ..write('valorTotal: $valorTotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    codigo,
    nombre,
    descripcion,
    tipo,
    categoria,
    unidad,
    stockActual,
    stockMinimo,
    precioUnitario,
    proveedorId,
    activo,
    notas,
    valorTotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItemRow &&
          other.id == this.id &&
          other.codigo == this.codigo &&
          other.nombre == this.nombre &&
          other.descripcion == this.descripcion &&
          other.tipo == this.tipo &&
          other.categoria == this.categoria &&
          other.unidad == this.unidad &&
          other.stockActual == this.stockActual &&
          other.stockMinimo == this.stockMinimo &&
          other.precioUnitario == this.precioUnitario &&
          other.proveedorId == this.proveedorId &&
          other.activo == this.activo &&
          other.notas == this.notas &&
          other.valorTotal == this.valorTotal);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItemRow> {
  final Value<int> id;
  final Value<String?> codigo;
  final Value<String> nombre;
  final Value<String?> descripcion;
  final Value<String> tipo;
  final Value<String?> categoria;
  final Value<String> unidad;
  final Value<double> stockActual;
  final Value<double?> stockMinimo;
  final Value<double> precioUnitario;
  final Value<int?> proveedorId;
  final Value<bool> activo;
  final Value<String?> notas;
  final Value<double> valorTotal;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    this.nombre = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.tipo = const Value.absent(),
    this.categoria = const Value.absent(),
    this.unidad = const Value.absent(),
    this.stockActual = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.activo = const Value.absent(),
    this.notas = const Value.absent(),
    this.valorTotal = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    this.id = const Value.absent(),
    this.codigo = const Value.absent(),
    required String nombre,
    this.descripcion = const Value.absent(),
    required String tipo,
    this.categoria = const Value.absent(),
    this.unidad = const Value.absent(),
    this.stockActual = const Value.absent(),
    this.stockMinimo = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.proveedorId = const Value.absent(),
    this.activo = const Value.absent(),
    this.notas = const Value.absent(),
    this.valorTotal = const Value.absent(),
  }) : nombre = Value(nombre),
       tipo = Value(tipo);
  static Insertable<InventoryItemRow> custom({
    Expression<int>? id,
    Expression<String>? codigo,
    Expression<String>? nombre,
    Expression<String>? descripcion,
    Expression<String>? tipo,
    Expression<String>? categoria,
    Expression<String>? unidad,
    Expression<double>? stockActual,
    Expression<double>? stockMinimo,
    Expression<double>? precioUnitario,
    Expression<int>? proveedorId,
    Expression<bool>? activo,
    Expression<String>? notas,
    Expression<double>? valorTotal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (codigo != null) 'codigo': codigo,
      if (nombre != null) 'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (tipo != null) 'tipo': tipo,
      if (categoria != null) 'categoria': categoria,
      if (unidad != null) 'unidad': unidad,
      if (stockActual != null) 'stock_actual': stockActual,
      if (stockMinimo != null) 'stock_minimo': stockMinimo,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (proveedorId != null) 'proveedor_id': proveedorId,
      if (activo != null) 'activo': activo,
      if (notas != null) 'notas': notas,
      if (valorTotal != null) 'valor_total': valorTotal,
    });
  }

  InventoryItemsCompanion copyWith({
    Value<int>? id,
    Value<String?>? codigo,
    Value<String>? nombre,
    Value<String?>? descripcion,
    Value<String>? tipo,
    Value<String?>? categoria,
    Value<String>? unidad,
    Value<double>? stockActual,
    Value<double?>? stockMinimo,
    Value<double>? precioUnitario,
    Value<int?>? proveedorId,
    Value<bool>? activo,
    Value<String?>? notas,
    Value<double>? valorTotal,
  }) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      codigo: codigo ?? this.codigo,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      tipo: tipo ?? this.tipo,
      categoria: categoria ?? this.categoria,
      unidad: unidad ?? this.unidad,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      proveedorId: proveedorId ?? this.proveedorId,
      activo: activo ?? this.activo,
      notas: notas ?? this.notas,
      valorTotal: valorTotal ?? this.valorTotal,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (codigo.present) {
      map['codigo'] = Variable<String>(codigo.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (categoria.present) {
      map['categoria'] = Variable<String>(categoria.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (stockActual.present) {
      map['stock_actual'] = Variable<double>(stockActual.value);
    }
    if (stockMinimo.present) {
      map['stock_minimo'] = Variable<double>(stockMinimo.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (proveedorId.present) {
      map['proveedor_id'] = Variable<int>(proveedorId.value);
    }
    if (activo.present) {
      map['activo'] = Variable<bool>(activo.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    if (valorTotal.present) {
      map['valor_total'] = Variable<double>(valorTotal.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('codigo: $codigo, ')
          ..write('nombre: $nombre, ')
          ..write('descripcion: $descripcion, ')
          ..write('tipo: $tipo, ')
          ..write('categoria: $categoria, ')
          ..write('unidad: $unidad, ')
          ..write('stockActual: $stockActual, ')
          ..write('stockMinimo: $stockMinimo, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('proveedorId: $proveedorId, ')
          ..write('activo: $activo, ')
          ..write('notas: $notas, ')
          ..write('valorTotal: $valorTotal')
          ..write(')'))
        .toString();
  }
}

class $InventoryMovementsTable extends InventoryMovements
    with TableInfo<$InventoryMovementsTable, InventoryMovementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipoMeta = const VerificationMeta('tipo');
  @override
  late final GeneratedColumn<String> tipo = GeneratedColumn<String>(
    'tipo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cantidadMeta = const VerificationMeta(
    'cantidad',
  );
  @override
  late final GeneratedColumn<double> cantidad = GeneratedColumn<double>(
    'cantidad',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _precioUnitarioMeta = const VerificationMeta(
    'precioUnitario',
  );
  @override
  late final GeneratedColumn<double> precioUnitario = GeneratedColumn<double>(
    'precio_unitario',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _referenciaMeta = const VerificationMeta(
    'referencia',
  );
  @override
  late final GeneratedColumn<String> referencia = GeneratedColumn<String>(
    'referencia',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    tipo,
    cantidad,
    precioUnitario,
    referencia,
    fecha,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryMovementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('tipo')) {
      context.handle(
        _tipoMeta,
        tipo.isAcceptableOrUnknown(data['tipo']!, _tipoMeta),
      );
    } else if (isInserting) {
      context.missing(_tipoMeta);
    }
    if (data.containsKey('cantidad')) {
      context.handle(
        _cantidadMeta,
        cantidad.isAcceptableOrUnknown(data['cantidad']!, _cantidadMeta),
      );
    } else if (isInserting) {
      context.missing(_cantidadMeta);
    }
    if (data.containsKey('precio_unitario')) {
      context.handle(
        _precioUnitarioMeta,
        precioUnitario.isAcceptableOrUnknown(
          data['precio_unitario']!,
          _precioUnitarioMeta,
        ),
      );
    }
    if (data.containsKey('referencia')) {
      context.handle(
        _referenciaMeta,
        referencia.isAcceptableOrUnknown(data['referencia']!, _referenciaMeta),
      );
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryMovementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryMovementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_id'],
      )!,
      tipo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipo'],
      )!,
      cantidad: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cantidad'],
      )!,
      precioUnitario: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio_unitario'],
      ),
      referencia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}referencia'],
      ),
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $InventoryMovementsTable createAlias(String alias) {
    return $InventoryMovementsTable(attachedDatabase, alias);
  }
}

class InventoryMovementRow extends DataClass
    implements Insertable<InventoryMovementRow> {
  final int id;
  final int itemId;
  final String tipo;
  final double cantidad;
  final double? precioUnitario;
  final String? referencia;
  final String? fecha;
  final String? createdAt;
  const InventoryMovementRow({
    required this.id,
    required this.itemId,
    required this.tipo,
    required this.cantidad,
    this.precioUnitario,
    this.referencia,
    this.fecha,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['tipo'] = Variable<String>(tipo);
    map['cantidad'] = Variable<double>(cantidad);
    if (!nullToAbsent || precioUnitario != null) {
      map['precio_unitario'] = Variable<double>(precioUnitario);
    }
    if (!nullToAbsent || referencia != null) {
      map['referencia'] = Variable<String>(referencia);
    }
    if (!nullToAbsent || fecha != null) {
      map['fecha'] = Variable<String>(fecha);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<String>(createdAt);
    }
    return map;
  }

  InventoryMovementsCompanion toCompanion(bool nullToAbsent) {
    return InventoryMovementsCompanion(
      id: Value(id),
      itemId: Value(itemId),
      tipo: Value(tipo),
      cantidad: Value(cantidad),
      precioUnitario: precioUnitario == null && nullToAbsent
          ? const Value.absent()
          : Value(precioUnitario),
      referencia: referencia == null && nullToAbsent
          ? const Value.absent()
          : Value(referencia),
      fecha: fecha == null && nullToAbsent
          ? const Value.absent()
          : Value(fecha),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory InventoryMovementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryMovementRow(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      tipo: serializer.fromJson<String>(json['tipo']),
      cantidad: serializer.fromJson<double>(json['cantidad']),
      precioUnitario: serializer.fromJson<double?>(json['precioUnitario']),
      referencia: serializer.fromJson<String?>(json['referencia']),
      fecha: serializer.fromJson<String?>(json['fecha']),
      createdAt: serializer.fromJson<String?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'tipo': serializer.toJson<String>(tipo),
      'cantidad': serializer.toJson<double>(cantidad),
      'precioUnitario': serializer.toJson<double?>(precioUnitario),
      'referencia': serializer.toJson<String?>(referencia),
      'fecha': serializer.toJson<String?>(fecha),
      'createdAt': serializer.toJson<String?>(createdAt),
    };
  }

  InventoryMovementRow copyWith({
    int? id,
    int? itemId,
    String? tipo,
    double? cantidad,
    Value<double?> precioUnitario = const Value.absent(),
    Value<String?> referencia = const Value.absent(),
    Value<String?> fecha = const Value.absent(),
    Value<String?> createdAt = const Value.absent(),
  }) => InventoryMovementRow(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    tipo: tipo ?? this.tipo,
    cantidad: cantidad ?? this.cantidad,
    precioUnitario: precioUnitario.present
        ? precioUnitario.value
        : this.precioUnitario,
    referencia: referencia.present ? referencia.value : this.referencia,
    fecha: fecha.present ? fecha.value : this.fecha,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  InventoryMovementRow copyWithCompanion(InventoryMovementsCompanion data) {
    return InventoryMovementRow(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      tipo: data.tipo.present ? data.tipo.value : this.tipo,
      cantidad: data.cantidad.present ? data.cantidad.value : this.cantidad,
      precioUnitario: data.precioUnitario.present
          ? data.precioUnitario.value
          : this.precioUnitario,
      referencia: data.referencia.present
          ? data.referencia.value
          : this.referencia,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovementRow(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('referencia: $referencia, ')
          ..write('fecha: $fecha, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemId,
    tipo,
    cantidad,
    precioUnitario,
    referencia,
    fecha,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryMovementRow &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.tipo == this.tipo &&
          other.cantidad == this.cantidad &&
          other.precioUnitario == this.precioUnitario &&
          other.referencia == this.referencia &&
          other.fecha == this.fecha &&
          other.createdAt == this.createdAt);
}

class InventoryMovementsCompanion
    extends UpdateCompanion<InventoryMovementRow> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<String> tipo;
  final Value<double> cantidad;
  final Value<double?> precioUnitario;
  final Value<String?> referencia;
  final Value<String?> fecha;
  final Value<String?> createdAt;
  const InventoryMovementsCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.tipo = const Value.absent(),
    this.cantidad = const Value.absent(),
    this.precioUnitario = const Value.absent(),
    this.referencia = const Value.absent(),
    this.fecha = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  InventoryMovementsCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required String tipo,
    required double cantidad,
    this.precioUnitario = const Value.absent(),
    this.referencia = const Value.absent(),
    this.fecha = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : itemId = Value(itemId),
       tipo = Value(tipo),
       cantidad = Value(cantidad);
  static Insertable<InventoryMovementRow> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<String>? tipo,
    Expression<double>? cantidad,
    Expression<double>? precioUnitario,
    Expression<String>? referencia,
    Expression<String>? fecha,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (tipo != null) 'tipo': tipo,
      if (cantidad != null) 'cantidad': cantidad,
      if (precioUnitario != null) 'precio_unitario': precioUnitario,
      if (referencia != null) 'referencia': referencia,
      if (fecha != null) 'fecha': fecha,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  InventoryMovementsCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<String>? tipo,
    Value<double>? cantidad,
    Value<double?>? precioUnitario,
    Value<String?>? referencia,
    Value<String?>? fecha,
    Value<String?>? createdAt,
  }) {
    return InventoryMovementsCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      tipo: tipo ?? this.tipo,
      cantidad: cantidad ?? this.cantidad,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      referencia: referencia ?? this.referencia,
      fecha: fecha ?? this.fecha,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (tipo.present) {
      map['tipo'] = Variable<String>(tipo.value);
    }
    if (cantidad.present) {
      map['cantidad'] = Variable<double>(cantidad.value);
    }
    if (precioUnitario.present) {
      map['precio_unitario'] = Variable<double>(precioUnitario.value);
    }
    if (referencia.present) {
      map['referencia'] = Variable<String>(referencia.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryMovementsCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('tipo: $tipo, ')
          ..write('cantidad: $cantidad, ')
          ..write('precioUnitario: $precioUnitario, ')
          ..write('referencia: $referencia, ')
          ..write('fecha: $fecha, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PendingOpsTable extends PendingOps
    with TableInfo<$PendingOpsTable, PendingOp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOpsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tempIdMeta = const VerificationMeta('tempId');
  @override
  late final GeneratedColumn<int> tempId = GeneratedColumn<int>(
    'temp_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endpointMeta = const VerificationMeta(
    'endpoint',
  );
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
    'endpoint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _retriesMeta = const VerificationMeta(
    'retries',
  );
  @override
  late final GeneratedColumn<int> retries = GeneratedColumn<int>(
    'retries',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    operation,
    entityId,
    tempId,
    endpoint,
    payload,
    createdAt,
    retries,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_ops';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    }
    if (data.containsKey('temp_id')) {
      context.handle(
        _tempIdMeta,
        tempId.isAcceptableOrUnknown(data['temp_id']!, _tempIdMeta),
      );
    }
    if (data.containsKey('endpoint')) {
      context.handle(
        _endpointMeta,
        endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta),
      );
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('retries')) {
      context.handle(
        _retriesMeta,
        retries.isAcceptableOrUnknown(data['retries']!, _retriesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingOp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOp(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      ),
      tempId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}temp_id'],
      ),
      endpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}endpoint'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      retries: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retries'],
      )!,
    );
  }

  @override
  $PendingOpsTable createAlias(String alias) {
    return $PendingOpsTable(attachedDatabase, alias);
  }
}

class PendingOp extends DataClass implements Insertable<PendingOp> {
  final int id;
  final String entityType;
  final String operation;
  final int? entityId;
  final int? tempId;
  final String endpoint;
  final String? payload;
  final DateTime createdAt;
  final int retries;
  const PendingOp({
    required this.id,
    required this.entityType,
    required this.operation,
    this.entityId,
    this.tempId,
    required this.endpoint,
    this.payload,
    required this.createdAt,
    required this.retries,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || entityId != null) {
      map['entity_id'] = Variable<int>(entityId);
    }
    if (!nullToAbsent || tempId != null) {
      map['temp_id'] = Variable<int>(tempId);
    }
    map['endpoint'] = Variable<String>(endpoint);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['retries'] = Variable<int>(retries);
    return map;
  }

  PendingOpsCompanion toCompanion(bool nullToAbsent) {
    return PendingOpsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      operation: Value(operation),
      entityId: entityId == null && nullToAbsent
          ? const Value.absent()
          : Value(entityId),
      tempId: tempId == null && nullToAbsent
          ? const Value.absent()
          : Value(tempId),
      endpoint: Value(endpoint),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      createdAt: Value(createdAt),
      retries: Value(retries),
    );
  }

  factory PendingOp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOp(
      id: serializer.fromJson<int>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      operation: serializer.fromJson<String>(json['operation']),
      entityId: serializer.fromJson<int?>(json['entityId']),
      tempId: serializer.fromJson<int?>(json['tempId']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      retries: serializer.fromJson<int>(json['retries']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'entityType': serializer.toJson<String>(entityType),
      'operation': serializer.toJson<String>(operation),
      'entityId': serializer.toJson<int?>(entityId),
      'tempId': serializer.toJson<int?>(tempId),
      'endpoint': serializer.toJson<String>(endpoint),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'retries': serializer.toJson<int>(retries),
    };
  }

  PendingOp copyWith({
    int? id,
    String? entityType,
    String? operation,
    Value<int?> entityId = const Value.absent(),
    Value<int?> tempId = const Value.absent(),
    String? endpoint,
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
    int? retries,
  }) => PendingOp(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    operation: operation ?? this.operation,
    entityId: entityId.present ? entityId.value : this.entityId,
    tempId: tempId.present ? tempId.value : this.tempId,
    endpoint: endpoint ?? this.endpoint,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
    retries: retries ?? this.retries,
  );
  PendingOp copyWithCompanion(PendingOpsCompanion data) {
    return PendingOp(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      operation: data.operation.present ? data.operation.value : this.operation,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      tempId: data.tempId.present ? data.tempId.value : this.tempId,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      retries: data.retries.present ? data.retries.value : this.retries,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOp(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('entityId: $entityId, ')
          ..write('tempId: $tempId, ')
          ..write('endpoint: $endpoint, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retries: $retries')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    operation,
    entityId,
    tempId,
    endpoint,
    payload,
    createdAt,
    retries,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOp &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.operation == this.operation &&
          other.entityId == this.entityId &&
          other.tempId == this.tempId &&
          other.endpoint == this.endpoint &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.retries == this.retries);
}

class PendingOpsCompanion extends UpdateCompanion<PendingOp> {
  final Value<int> id;
  final Value<String> entityType;
  final Value<String> operation;
  final Value<int?> entityId;
  final Value<int?> tempId;
  final Value<String> endpoint;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  final Value<int> retries;
  const PendingOpsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.operation = const Value.absent(),
    this.entityId = const Value.absent(),
    this.tempId = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retries = const Value.absent(),
  });
  PendingOpsCompanion.insert({
    this.id = const Value.absent(),
    required String entityType,
    required String operation,
    this.entityId = const Value.absent(),
    this.tempId = const Value.absent(),
    required String endpoint,
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.retries = const Value.absent(),
  }) : entityType = Value(entityType),
       operation = Value(operation),
       endpoint = Value(endpoint);
  static Insertable<PendingOp> custom({
    Expression<int>? id,
    Expression<String>? entityType,
    Expression<String>? operation,
    Expression<int>? entityId,
    Expression<int>? tempId,
    Expression<String>? endpoint,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? retries,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (operation != null) 'operation': operation,
      if (entityId != null) 'entity_id': entityId,
      if (tempId != null) 'temp_id': tempId,
      if (endpoint != null) 'endpoint': endpoint,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (retries != null) 'retries': retries,
    });
  }

  PendingOpsCompanion copyWith({
    Value<int>? id,
    Value<String>? entityType,
    Value<String>? operation,
    Value<int?>? entityId,
    Value<int?>? tempId,
    Value<String>? endpoint,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
    Value<int>? retries,
  }) {
    return PendingOpsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      operation: operation ?? this.operation,
      entityId: entityId ?? this.entityId,
      tempId: tempId ?? this.tempId,
      endpoint: endpoint ?? this.endpoint,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retries: retries ?? this.retries,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (tempId.present) {
      map['temp_id'] = Variable<int>(tempId.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (retries.present) {
      map['retries'] = Variable<int>(retries.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOpsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('operation: $operation, ')
          ..write('entityId: $entityId, ')
          ..write('tempId: $tempId, ')
          ..write('endpoint: $endpoint, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('retries: $retries')
          ..write(')'))
        .toString();
  }
}

class $CacheEntriesTable extends CacheEntries
    with TableInfo<$CacheEntriesTable, CacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cacheKey, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  CacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheEntry(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CacheEntriesTable createAlias(String alias) {
    return $CacheEntriesTable(attachedDatabase, alias);
  }
}

class CacheEntry extends DataClass implements Insertable<CacheEntry> {
  final String cacheKey;
  final String value;
  final DateTime updatedAt;
  const CacheEntry({
    required this.cacheKey,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CacheEntriesCompanion(
      cacheKey: Value(cacheKey),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory CacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheEntry(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CacheEntry copyWith({String? cacheKey, String? value, DateTime? updatedAt}) =>
      CacheEntry(
        cacheKey: cacheKey ?? this.cacheKey,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CacheEntry copyWithCompanion(CacheEntriesCompanion data) {
    return CacheEntry(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntry(')
          ..write('cacheKey: $cacheKey, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheEntry &&
          other.cacheKey == this.cacheKey &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class CacheEntriesCompanion extends UpdateCompanion<CacheEntry> {
  final Value<String> cacheKey;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CacheEntriesCompanion({
    this.cacheKey = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheEntriesCompanion.insert({
    required String cacheKey,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<CacheEntry> custom({
    Expression<String>? cacheKey,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheEntriesCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CacheEntriesCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntriesCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $InventoryMovementsTable inventoryMovements =
      $InventoryMovementsTable(this);
  late final $PendingOpsTable pendingOps = $PendingOpsTable(this);
  late final $CacheEntriesTable cacheEntries = $CacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    inventoryItems,
    inventoryMovements,
    pendingOps,
    cacheEntries,
  ];
}

typedef $$InventoryItemsTableCreateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      Value<String?> codigo,
      required String nombre,
      Value<String?> descripcion,
      required String tipo,
      Value<String?> categoria,
      Value<String> unidad,
      Value<double> stockActual,
      Value<double?> stockMinimo,
      Value<double> precioUnitario,
      Value<int?> proveedorId,
      Value<bool> activo,
      Value<String?> notas,
      Value<double> valorTotal,
    });
typedef $$InventoryItemsTableUpdateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      Value<String?> codigo,
      Value<String> nombre,
      Value<String?> descripcion,
      Value<String> tipo,
      Value<String?> categoria,
      Value<String> unidad,
      Value<double> stockActual,
      Value<double?> stockMinimo,
      Value<double> precioUnitario,
      Value<int?> proveedorId,
      Value<bool> activo,
      Value<String?> notas,
      Value<double> valorTotal,
    });

class $$InventoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockActual => $composableBuilder(
    column: $table.stockActual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codigo => $composableBuilder(
    column: $table.codigo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoria => $composableBuilder(
    column: $table.categoria,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockActual => $composableBuilder(
    column: $table.stockActual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get activo => $composableBuilder(
    column: $table.activo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get codigo =>
      $composableBuilder(column: $table.codigo, builder: (column) => column);

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<String> get categoria =>
      $composableBuilder(column: $table.categoria, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<double> get stockActual => $composableBuilder(
    column: $table.stockActual,
    builder: (column) => column,
  );

  GeneratedColumn<double> get stockMinimo => $composableBuilder(
    column: $table.stockMinimo,
    builder: (column) => column,
  );

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proveedorId => $composableBuilder(
    column: $table.proveedorId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get activo =>
      $composableBuilder(column: $table.activo, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);

  GeneratedColumn<double> get valorTotal => $composableBuilder(
    column: $table.valorTotal,
    builder: (column) => column,
  );
}

class $$InventoryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryItemsTable,
          InventoryItemRow,
          $$InventoryItemsTableFilterComposer,
          $$InventoryItemsTableOrderingComposer,
          $$InventoryItemsTableAnnotationComposer,
          $$InventoryItemsTableCreateCompanionBuilder,
          $$InventoryItemsTableUpdateCompanionBuilder,
          (
            InventoryItemRow,
            BaseReferences<
              _$AppDatabase,
              $InventoryItemsTable,
              InventoryItemRow
            >,
          ),
          InventoryItemRow,
          PrefetchHooks Function()
        > {
  $$InventoryItemsTableTableManager(
    _$AppDatabase db,
    $InventoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> descripcion = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<String?> categoria = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<double> stockActual = const Value.absent(),
                Value<double?> stockMinimo = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<int?> proveedorId = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<double> valorTotal = const Value.absent(),
              }) => InventoryItemsCompanion(
                id: id,
                codigo: codigo,
                nombre: nombre,
                descripcion: descripcion,
                tipo: tipo,
                categoria: categoria,
                unidad: unidad,
                stockActual: stockActual,
                stockMinimo: stockMinimo,
                precioUnitario: precioUnitario,
                proveedorId: proveedorId,
                activo: activo,
                notas: notas,
                valorTotal: valorTotal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> codigo = const Value.absent(),
                required String nombre,
                Value<String?> descripcion = const Value.absent(),
                required String tipo,
                Value<String?> categoria = const Value.absent(),
                Value<String> unidad = const Value.absent(),
                Value<double> stockActual = const Value.absent(),
                Value<double?> stockMinimo = const Value.absent(),
                Value<double> precioUnitario = const Value.absent(),
                Value<int?> proveedorId = const Value.absent(),
                Value<bool> activo = const Value.absent(),
                Value<String?> notas = const Value.absent(),
                Value<double> valorTotal = const Value.absent(),
              }) => InventoryItemsCompanion.insert(
                id: id,
                codigo: codigo,
                nombre: nombre,
                descripcion: descripcion,
                tipo: tipo,
                categoria: categoria,
                unidad: unidad,
                stockActual: stockActual,
                stockMinimo: stockMinimo,
                precioUnitario: precioUnitario,
                proveedorId: proveedorId,
                activo: activo,
                notas: notas,
                valorTotal: valorTotal,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryItemsTable,
      InventoryItemRow,
      $$InventoryItemsTableFilterComposer,
      $$InventoryItemsTableOrderingComposer,
      $$InventoryItemsTableAnnotationComposer,
      $$InventoryItemsTableCreateCompanionBuilder,
      $$InventoryItemsTableUpdateCompanionBuilder,
      (
        InventoryItemRow,
        BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItemRow>,
      ),
      InventoryItemRow,
      PrefetchHooks Function()
    >;
typedef $$InventoryMovementsTableCreateCompanionBuilder =
    InventoryMovementsCompanion Function({
      Value<int> id,
      required int itemId,
      required String tipo,
      required double cantidad,
      Value<double?> precioUnitario,
      Value<String?> referencia,
      Value<String?> fecha,
      Value<String?> createdAt,
    });
typedef $$InventoryMovementsTableUpdateCompanionBuilder =
    InventoryMovementsCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<String> tipo,
      Value<double> cantidad,
      Value<double?> precioUnitario,
      Value<String?> referencia,
      Value<String?> fecha,
      Value<String?> createdAt,
    });

class $$InventoryMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipo => $composableBuilder(
    column: $table.tipo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cantidad => $composableBuilder(
    column: $table.cantidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryMovementsTable> {
  $$InventoryMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get tipo =>
      $composableBuilder(column: $table.tipo, builder: (column) => column);

  GeneratedColumn<double> get cantidad =>
      $composableBuilder(column: $table.cantidad, builder: (column) => column);

  GeneratedColumn<double> get precioUnitario => $composableBuilder(
    column: $table.precioUnitario,
    builder: (column) => column,
  );

  GeneratedColumn<String> get referencia => $composableBuilder(
    column: $table.referencia,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InventoryMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryMovementsTable,
          InventoryMovementRow,
          $$InventoryMovementsTableFilterComposer,
          $$InventoryMovementsTableOrderingComposer,
          $$InventoryMovementsTableAnnotationComposer,
          $$InventoryMovementsTableCreateCompanionBuilder,
          $$InventoryMovementsTableUpdateCompanionBuilder,
          (
            InventoryMovementRow,
            BaseReferences<
              _$AppDatabase,
              $InventoryMovementsTable,
              InventoryMovementRow
            >,
          ),
          InventoryMovementRow,
          PrefetchHooks Function()
        > {
  $$InventoryMovementsTableTableManager(
    _$AppDatabase db,
    $InventoryMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryMovementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<String> tipo = const Value.absent(),
                Value<double> cantidad = const Value.absent(),
                Value<double?> precioUnitario = const Value.absent(),
                Value<String?> referencia = const Value.absent(),
                Value<String?> fecha = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
              }) => InventoryMovementsCompanion(
                id: id,
                itemId: itemId,
                tipo: tipo,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                referencia: referencia,
                fecha: fecha,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required String tipo,
                required double cantidad,
                Value<double?> precioUnitario = const Value.absent(),
                Value<String?> referencia = const Value.absent(),
                Value<String?> fecha = const Value.absent(),
                Value<String?> createdAt = const Value.absent(),
              }) => InventoryMovementsCompanion.insert(
                id: id,
                itemId: itemId,
                tipo: tipo,
                cantidad: cantidad,
                precioUnitario: precioUnitario,
                referencia: referencia,
                fecha: fecha,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryMovementsTable,
      InventoryMovementRow,
      $$InventoryMovementsTableFilterComposer,
      $$InventoryMovementsTableOrderingComposer,
      $$InventoryMovementsTableAnnotationComposer,
      $$InventoryMovementsTableCreateCompanionBuilder,
      $$InventoryMovementsTableUpdateCompanionBuilder,
      (
        InventoryMovementRow,
        BaseReferences<
          _$AppDatabase,
          $InventoryMovementsTable,
          InventoryMovementRow
        >,
      ),
      InventoryMovementRow,
      PrefetchHooks Function()
    >;
typedef $$PendingOpsTableCreateCompanionBuilder =
    PendingOpsCompanion Function({
      Value<int> id,
      required String entityType,
      required String operation,
      Value<int?> entityId,
      Value<int?> tempId,
      required String endpoint,
      Value<String?> payload,
      Value<DateTime> createdAt,
      Value<int> retries,
    });
typedef $$PendingOpsTableUpdateCompanionBuilder =
    PendingOpsCompanion Function({
      Value<int> id,
      Value<String> entityType,
      Value<String> operation,
      Value<int?> entityId,
      Value<int?> tempId,
      Value<String> endpoint,
      Value<String?> payload,
      Value<DateTime> createdAt,
      Value<int> retries,
    });

class $$PendingOpsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingOpsTable> {
  $$PendingOpsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retries => $composableBuilder(
    column: $table.retries,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOpsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingOpsTable> {
  $$PendingOpsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tempId => $composableBuilder(
    column: $table.tempId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endpoint => $composableBuilder(
    column: $table.endpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retries => $composableBuilder(
    column: $table.retries,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOpsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingOpsTable> {
  $$PendingOpsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<int> get tempId =>
      $composableBuilder(column: $table.tempId, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get retries =>
      $composableBuilder(column: $table.retries, builder: (column) => column);
}

class $$PendingOpsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingOpsTable,
          PendingOp,
          $$PendingOpsTableFilterComposer,
          $$PendingOpsTableOrderingComposer,
          $$PendingOpsTableAnnotationComposer,
          $$PendingOpsTableCreateCompanionBuilder,
          $$PendingOpsTableUpdateCompanionBuilder,
          (
            PendingOp,
            BaseReferences<_$AppDatabase, $PendingOpsTable, PendingOp>,
          ),
          PendingOp,
          PrefetchHooks Function()
        > {
  $$PendingOpsTableTableManager(_$AppDatabase db, $PendingOpsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOpsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOpsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOpsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<int?> entityId = const Value.absent(),
                Value<int?> tempId = const Value.absent(),
                Value<String> endpoint = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retries = const Value.absent(),
              }) => PendingOpsCompanion(
                id: id,
                entityType: entityType,
                operation: operation,
                entityId: entityId,
                tempId: tempId,
                endpoint: endpoint,
                payload: payload,
                createdAt: createdAt,
                retries: retries,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String entityType,
                required String operation,
                Value<int?> entityId = const Value.absent(),
                Value<int?> tempId = const Value.absent(),
                required String endpoint,
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> retries = const Value.absent(),
              }) => PendingOpsCompanion.insert(
                id: id,
                entityType: entityType,
                operation: operation,
                entityId: entityId,
                tempId: tempId,
                endpoint: endpoint,
                payload: payload,
                createdAt: createdAt,
                retries: retries,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingOpsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingOpsTable,
      PendingOp,
      $$PendingOpsTableFilterComposer,
      $$PendingOpsTableOrderingComposer,
      $$PendingOpsTableAnnotationComposer,
      $$PendingOpsTableCreateCompanionBuilder,
      $$PendingOpsTableUpdateCompanionBuilder,
      (PendingOp, BaseReferences<_$AppDatabase, $PendingOpsTable, PendingOp>),
      PendingOp,
      PrefetchHooks Function()
    >;
typedef $$CacheEntriesTableCreateCompanionBuilder =
    CacheEntriesCompanion Function({
      required String cacheKey,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CacheEntriesTableUpdateCompanionBuilder =
    CacheEntriesCompanion Function({
      Value<String> cacheKey,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheEntriesTable,
          CacheEntry,
          $$CacheEntriesTableFilterComposer,
          $$CacheEntriesTableOrderingComposer,
          $$CacheEntriesTableAnnotationComposer,
          $$CacheEntriesTableCreateCompanionBuilder,
          $$CacheEntriesTableUpdateCompanionBuilder,
          (
            CacheEntry,
            BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>,
          ),
          CacheEntry,
          PrefetchHooks Function()
        > {
  $$CacheEntriesTableTableManager(_$AppDatabase db, $CacheEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheEntriesCompanion(
                cacheKey: cacheKey,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CacheEntriesCompanion.insert(
                cacheKey: cacheKey,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheEntriesTable,
      CacheEntry,
      $$CacheEntriesTableFilterComposer,
      $$CacheEntriesTableOrderingComposer,
      $$CacheEntriesTableAnnotationComposer,
      $$CacheEntriesTableCreateCompanionBuilder,
      $$CacheEntriesTableUpdateCompanionBuilder,
      (
        CacheEntry,
        BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>,
      ),
      CacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$InventoryMovementsTableTableManager get inventoryMovements =>
      $$InventoryMovementsTableTableManager(_db, _db.inventoryMovements);
  $$PendingOpsTableTableManager get pendingOps =>
      $$PendingOpsTableTableManager(_db, _db.pendingOps);
  $$CacheEntriesTableTableManager get cacheEntries =>
      $$CacheEntriesTableTableManager(_db, _db.cacheEntries);
}
