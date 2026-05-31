// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('active'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quotedMeta = const VerificationMeta('quoted');
  @override
  late final GeneratedColumn<double> quoted = GeneratedColumn<double>(
    'quoted',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _spentMeta = const VerificationMeta('spent');
  @override
  late final GeneratedColumn<double> spent = GeneratedColumn<double>(
    'spent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plMeta = const VerificationMeta('pl');
  @override
  late final GeneratedColumn<double> pl = GeneratedColumn<double>(
    'pl',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    clientName,
    status,
    color,
    description,
    createdAt,
    quoted,
    spent,
    pl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    } else if (isInserting) {
      context.missing(_clientNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('quoted')) {
      context.handle(
        _quotedMeta,
        quoted.isAcceptableOrUnknown(data['quoted']!, _quotedMeta),
      );
    }
    if (data.containsKey('spent')) {
      context.handle(
        _spentMeta,
        spent.isAcceptableOrUnknown(data['spent']!, _spentMeta),
      );
    }
    if (data.containsKey('pl')) {
      context.handle(_plMeta, pl.isAcceptableOrUnknown(data['pl']!, _plMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      quoted: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quoted'],
      ),
      spent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent'],
      ),
      pl: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pl'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final int id;
  final String name;
  final String clientName;
  final String status;
  final String? color;
  final String? description;
  final String createdAt;
  final double? quoted;
  final double? spent;
  final double? pl;
  const ProjectRow({
    required this.id,
    required this.name,
    required this.clientName,
    required this.status,
    this.color,
    this.description,
    required this.createdAt,
    this.quoted,
    this.spent,
    this.pl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['client_name'] = Variable<String>(clientName);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || quoted != null) {
      map['quoted'] = Variable<double>(quoted);
    }
    if (!nullToAbsent || spent != null) {
      map['spent'] = Variable<double>(spent);
    }
    if (!nullToAbsent || pl != null) {
      map['pl'] = Variable<double>(pl);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      clientName: Value(clientName),
      status: Value(status),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      createdAt: Value(createdAt),
      quoted: quoted == null && nullToAbsent
          ? const Value.absent()
          : Value(quoted),
      spent: spent == null && nullToAbsent
          ? const Value.absent()
          : Value(spent),
      pl: pl == null && nullToAbsent ? const Value.absent() : Value(pl),
    );
  }

  factory ProjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      clientName: serializer.fromJson<String>(json['clientName']),
      status: serializer.fromJson<String>(json['status']),
      color: serializer.fromJson<String?>(json['color']),
      description: serializer.fromJson<String?>(json['description']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      quoted: serializer.fromJson<double?>(json['quoted']),
      spent: serializer.fromJson<double?>(json['spent']),
      pl: serializer.fromJson<double?>(json['pl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'clientName': serializer.toJson<String>(clientName),
      'status': serializer.toJson<String>(status),
      'color': serializer.toJson<String?>(color),
      'description': serializer.toJson<String?>(description),
      'createdAt': serializer.toJson<String>(createdAt),
      'quoted': serializer.toJson<double?>(quoted),
      'spent': serializer.toJson<double?>(spent),
      'pl': serializer.toJson<double?>(pl),
    };
  }

  ProjectRow copyWith({
    int? id,
    String? name,
    String? clientName,
    String? status,
    Value<String?> color = const Value.absent(),
    Value<String?> description = const Value.absent(),
    String? createdAt,
    Value<double?> quoted = const Value.absent(),
    Value<double?> spent = const Value.absent(),
    Value<double?> pl = const Value.absent(),
  }) => ProjectRow(
    id: id ?? this.id,
    name: name ?? this.name,
    clientName: clientName ?? this.clientName,
    status: status ?? this.status,
    color: color.present ? color.value : this.color,
    description: description.present ? description.value : this.description,
    createdAt: createdAt ?? this.createdAt,
    quoted: quoted.present ? quoted.value : this.quoted,
    spent: spent.present ? spent.value : this.spent,
    pl: pl.present ? pl.value : this.pl,
  );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      status: data.status.present ? data.status.value : this.status,
      color: data.color.present ? data.color.value : this.color,
      description: data.description.present
          ? data.description.value
          : this.description,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      quoted: data.quoted.present ? data.quoted.value : this.quoted,
      spent: data.spent.present ? data.spent.value : this.spent,
      pl: data.pl.present ? data.pl.value : this.pl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('clientName: $clientName, ')
          ..write('status: $status, ')
          ..write('color: $color, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('quoted: $quoted, ')
          ..write('spent: $spent, ')
          ..write('pl: $pl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    clientName,
    status,
    color,
    description,
    createdAt,
    quoted,
    spent,
    pl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.clientName == this.clientName &&
          other.status == this.status &&
          other.color == this.color &&
          other.description == this.description &&
          other.createdAt == this.createdAt &&
          other.quoted == this.quoted &&
          other.spent == this.spent &&
          other.pl == this.pl);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> clientName;
  final Value<String> status;
  final Value<String?> color;
  final Value<String?> description;
  final Value<String> createdAt;
  final Value<double?> quoted;
  final Value<double?> spent;
  final Value<double?> pl;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.clientName = const Value.absent(),
    this.status = const Value.absent(),
    this.color = const Value.absent(),
    this.description = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.quoted = const Value.absent(),
    this.spent = const Value.absent(),
    this.pl = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String clientName,
    this.status = const Value.absent(),
    this.color = const Value.absent(),
    this.description = const Value.absent(),
    required String createdAt,
    this.quoted = const Value.absent(),
    this.spent = const Value.absent(),
    this.pl = const Value.absent(),
  }) : name = Value(name),
       clientName = Value(clientName),
       createdAt = Value(createdAt);
  static Insertable<ProjectRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? clientName,
    Expression<String>? status,
    Expression<String>? color,
    Expression<String>? description,
    Expression<String>? createdAt,
    Expression<double>? quoted,
    Expression<double>? spent,
    Expression<double>? pl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (clientName != null) 'client_name': clientName,
      if (status != null) 'status': status,
      if (color != null) 'color': color,
      if (description != null) 'description': description,
      if (createdAt != null) 'created_at': createdAt,
      if (quoted != null) 'quoted': quoted,
      if (spent != null) 'spent': spent,
      if (pl != null) 'pl': pl,
    });
  }

  ProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? clientName,
    Value<String>? status,
    Value<String?>? color,
    Value<String?>? description,
    Value<String>? createdAt,
    Value<double?>? quoted,
    Value<double?>? spent,
    Value<double?>? pl,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      clientName: clientName ?? this.clientName,
      status: status ?? this.status,
      color: color ?? this.color,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      quoted: quoted ?? this.quoted,
      spent: spent ?? this.spent,
      pl: pl ?? this.pl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (quoted.present) {
      map['quoted'] = Variable<double>(quoted.value);
    }
    if (spent.present) {
      map['spent'] = Variable<double>(spent.value);
    }
    if (pl.present) {
      map['pl'] = Variable<double>(pl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('clientName: $clientName, ')
          ..write('status: $status, ')
          ..write('color: $color, ')
          ..write('description: $description, ')
          ..write('createdAt: $createdAt, ')
          ..write('quoted: $quoted, ')
          ..write('spent: $spent, ')
          ..write('pl: $pl')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeTypeMeta = const VerificationMeta(
    'scopeType',
  );
  @override
  late final GeneratedColumn<String> scopeType = GeneratedColumn<String>(
    'scope_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeIdMeta = const VerificationMeta(
    'scopeId',
  );
  @override
  late final GeneratedColumn<int> scopeId = GeneratedColumn<int>(
    'scope_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectNameMeta = const VerificationMeta(
    'projectName',
  );
  @override
  late final GeneratedColumn<String> projectName = GeneratedColumn<String>(
    'project_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectColorMeta = const VerificationMeta(
    'projectColor',
  );
  @override
  late final GeneratedColumn<String> projectColor = GeneratedColumn<String>(
    'project_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exchangeRateMeta = const VerificationMeta(
    'exchangeRate',
  );
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
    'exchange_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMxnMeta = const VerificationMeta(
    'amountMxn',
  );
  @override
  late final GeneratedColumn<double> amountMxn = GeneratedColumn<double>(
    'amount_mxn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<String> transactionDate = GeneratedColumn<String>(
    'transaction_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _etapaMeta = const VerificationMeta('etapa');
  @override
  late final GeneratedColumn<String> etapa = GeneratedColumn<String>(
    'etapa',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    scopeType,
    scopeId,
    categoryId,
    categoryName,
    projectName,
    projectColor,
    description,
    amount,
    currency,
    exchangeRate,
    amountMxn,
    transactionDate,
    etapa,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('scope_type')) {
      context.handle(
        _scopeTypeMeta,
        scopeType.isAcceptableOrUnknown(data['scope_type']!, _scopeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeTypeMeta);
    }
    if (data.containsKey('scope_id')) {
      context.handle(
        _scopeIdMeta,
        scopeId.isAcceptableOrUnknown(data['scope_id']!, _scopeIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    }
    if (data.containsKey('project_name')) {
      context.handle(
        _projectNameMeta,
        projectName.isAcceptableOrUnknown(
          data['project_name']!,
          _projectNameMeta,
        ),
      );
    }
    if (data.containsKey('project_color')) {
      context.handle(
        _projectColorMeta,
        projectColor.isAcceptableOrUnknown(
          data['project_color']!,
          _projectColorMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
        _exchangeRateMeta,
        exchangeRate.isAcceptableOrUnknown(
          data['exchange_rate']!,
          _exchangeRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exchangeRateMeta);
    }
    if (data.containsKey('amount_mxn')) {
      context.handle(
        _amountMxnMeta,
        amountMxn.isAcceptableOrUnknown(data['amount_mxn']!, _amountMxnMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMxnMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('etapa')) {
      context.handle(
        _etapaMeta,
        etapa.isAcceptableOrUnknown(data['etapa']!, _etapaMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      scopeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_type'],
      )!,
      scopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scope_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      ),
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      ),
      projectName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_name'],
      ),
      projectColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_color'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      exchangeRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exchange_rate'],
      )!,
      amountMxn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_mxn'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_date'],
      )!,
      etapa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etapa'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionRow extends DataClass implements Insertable<TransactionRow> {
  final int id;
  final String type;
  final String scopeType;
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
  const TransactionRow({
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
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['scope_type'] = Variable<String>(scopeType);
    if (!nullToAbsent || scopeId != null) {
      map['scope_id'] = Variable<int>(scopeId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    if (!nullToAbsent || categoryName != null) {
      map['category_name'] = Variable<String>(categoryName);
    }
    if (!nullToAbsent || projectName != null) {
      map['project_name'] = Variable<String>(projectName);
    }
    if (!nullToAbsent || projectColor != null) {
      map['project_color'] = Variable<String>(projectColor);
    }
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['currency'] = Variable<String>(currency);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    map['amount_mxn'] = Variable<double>(amountMxn);
    map['transaction_date'] = Variable<String>(transactionDate);
    if (!nullToAbsent || etapa != null) {
      map['etapa'] = Variable<String>(etapa);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      type: Value(type),
      scopeType: Value(scopeType),
      scopeId: scopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(scopeId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      categoryName: categoryName == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryName),
      projectName: projectName == null && nullToAbsent
          ? const Value.absent()
          : Value(projectName),
      projectColor: projectColor == null && nullToAbsent
          ? const Value.absent()
          : Value(projectColor),
      description: Value(description),
      amount: Value(amount),
      currency: Value(currency),
      exchangeRate: Value(exchangeRate),
      amountMxn: Value(amountMxn),
      transactionDate: Value(transactionDate),
      etapa: etapa == null && nullToAbsent
          ? const Value.absent()
          : Value(etapa),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionRow(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      scopeType: serializer.fromJson<String>(json['scopeType']),
      scopeId: serializer.fromJson<int?>(json['scopeId']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      categoryName: serializer.fromJson<String?>(json['categoryName']),
      projectName: serializer.fromJson<String?>(json['projectName']),
      projectColor: serializer.fromJson<String?>(json['projectColor']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      amountMxn: serializer.fromJson<double>(json['amountMxn']),
      transactionDate: serializer.fromJson<String>(json['transactionDate']),
      etapa: serializer.fromJson<String?>(json['etapa']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'scopeType': serializer.toJson<String>(scopeType),
      'scopeId': serializer.toJson<int?>(scopeId),
      'categoryId': serializer.toJson<int?>(categoryId),
      'categoryName': serializer.toJson<String?>(categoryName),
      'projectName': serializer.toJson<String?>(projectName),
      'projectColor': serializer.toJson<String?>(projectColor),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'currency': serializer.toJson<String>(currency),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'amountMxn': serializer.toJson<double>(amountMxn),
      'transactionDate': serializer.toJson<String>(transactionDate),
      'etapa': serializer.toJson<String?>(etapa),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  TransactionRow copyWith({
    int? id,
    String? type,
    String? scopeType,
    Value<int?> scopeId = const Value.absent(),
    Value<int?> categoryId = const Value.absent(),
    Value<String?> categoryName = const Value.absent(),
    Value<String?> projectName = const Value.absent(),
    Value<String?> projectColor = const Value.absent(),
    String? description,
    double? amount,
    String? currency,
    double? exchangeRate,
    double? amountMxn,
    String? transactionDate,
    Value<String?> etapa = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? createdAt,
  }) => TransactionRow(
    id: id ?? this.id,
    type: type ?? this.type,
    scopeType: scopeType ?? this.scopeType,
    scopeId: scopeId.present ? scopeId.value : this.scopeId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    categoryName: categoryName.present ? categoryName.value : this.categoryName,
    projectName: projectName.present ? projectName.value : this.projectName,
    projectColor: projectColor.present ? projectColor.value : this.projectColor,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    exchangeRate: exchangeRate ?? this.exchangeRate,
    amountMxn: amountMxn ?? this.amountMxn,
    transactionDate: transactionDate ?? this.transactionDate,
    etapa: etapa.present ? etapa.value : this.etapa,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  TransactionRow copyWithCompanion(TransactionsCompanion data) {
    return TransactionRow(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      scopeType: data.scopeType.present ? data.scopeType.value : this.scopeType,
      scopeId: data.scopeId.present ? data.scopeId.value : this.scopeId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      projectName: data.projectName.present
          ? data.projectName.value
          : this.projectName,
      projectColor: data.projectColor.present
          ? data.projectColor.value
          : this.projectColor,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      amountMxn: data.amountMxn.present ? data.amountMxn.value : this.amountMxn,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      etapa: data.etapa.present ? data.etapa.value : this.etapa,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionRow(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeId: $scopeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('projectName: $projectName, ')
          ..write('projectColor: $projectColor, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('amountMxn: $amountMxn, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('etapa: $etapa, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    scopeType,
    scopeId,
    categoryId,
    categoryName,
    projectName,
    projectColor,
    description,
    amount,
    currency,
    exchangeRate,
    amountMxn,
    transactionDate,
    etapa,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionRow &&
          other.id == this.id &&
          other.type == this.type &&
          other.scopeType == this.scopeType &&
          other.scopeId == this.scopeId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.projectName == this.projectName &&
          other.projectColor == this.projectColor &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.exchangeRate == this.exchangeRate &&
          other.amountMxn == this.amountMxn &&
          other.transactionDate == this.transactionDate &&
          other.etapa == this.etapa &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionRow> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> scopeType;
  final Value<int?> scopeId;
  final Value<int?> categoryId;
  final Value<String?> categoryName;
  final Value<String?> projectName;
  final Value<String?> projectColor;
  final Value<String> description;
  final Value<double> amount;
  final Value<String> currency;
  final Value<double> exchangeRate;
  final Value<double> amountMxn;
  final Value<String> transactionDate;
  final Value<String?> etapa;
  final Value<String?> notes;
  final Value<String> createdAt;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.scopeType = const Value.absent(),
    this.scopeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.projectName = const Value.absent(),
    this.projectColor = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.amountMxn = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.etapa = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String scopeType,
    this.scopeId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.projectName = const Value.absent(),
    this.projectColor = const Value.absent(),
    required String description,
    required double amount,
    required String currency,
    required double exchangeRate,
    required double amountMxn,
    required String transactionDate,
    this.etapa = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
  }) : type = Value(type),
       scopeType = Value(scopeType),
       description = Value(description),
       amount = Value(amount),
       currency = Value(currency),
       exchangeRate = Value(exchangeRate),
       amountMxn = Value(amountMxn),
       transactionDate = Value(transactionDate),
       createdAt = Value(createdAt);
  static Insertable<TransactionRow> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? scopeType,
    Expression<int>? scopeId,
    Expression<int>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? projectName,
    Expression<String>? projectColor,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? currency,
    Expression<double>? exchangeRate,
    Expression<double>? amountMxn,
    Expression<String>? transactionDate,
    Expression<String>? etapa,
    Expression<String>? notes,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (scopeType != null) 'scope_type': scopeType,
      if (scopeId != null) 'scope_id': scopeId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (projectName != null) 'project_name': projectName,
      if (projectColor != null) 'project_color': projectColor,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (amountMxn != null) 'amount_mxn': amountMxn,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (etapa != null) 'etapa': etapa,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<String>? scopeType,
    Value<int?>? scopeId,
    Value<int?>? categoryId,
    Value<String?>? categoryName,
    Value<String?>? projectName,
    Value<String?>? projectColor,
    Value<String>? description,
    Value<double>? amount,
    Value<String>? currency,
    Value<double>? exchangeRate,
    Value<double>? amountMxn,
    Value<String>? transactionDate,
    Value<String?>? etapa,
    Value<String?>? notes,
    Value<String>? createdAt,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      scopeType: scopeType ?? this.scopeType,
      scopeId: scopeId ?? this.scopeId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      projectName: projectName ?? this.projectName,
      projectColor: projectColor ?? this.projectColor,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      amountMxn: amountMxn ?? this.amountMxn,
      transactionDate: transactionDate ?? this.transactionDate,
      etapa: etapa ?? this.etapa,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (scopeType.present) {
      map['scope_type'] = Variable<String>(scopeType.value);
    }
    if (scopeId.present) {
      map['scope_id'] = Variable<int>(scopeId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (projectName.present) {
      map['project_name'] = Variable<String>(projectName.value);
    }
    if (projectColor.present) {
      map['project_color'] = Variable<String>(projectColor.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (amountMxn.present) {
      map['amount_mxn'] = Variable<double>(amountMxn.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<String>(transactionDate.value);
    }
    if (etapa.present) {
      map['etapa'] = Variable<String>(etapa.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('scopeType: $scopeType, ')
          ..write('scopeId: $scopeId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('projectName: $projectName, ')
          ..write('projectColor: $projectColor, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('amountMxn: $amountMxn, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('etapa: $etapa, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, SupplierRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _razonSocialMeta = const VerificationMeta(
    'razonSocial',
  );
  @override
  late final GeneratedColumn<String> razonSocial = GeneratedColumn<String>(
    'razon_social',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rfcMeta = const VerificationMeta('rfc');
  @override
  late final GeneratedColumn<String> rfc = GeneratedColumn<String>(
    'rfc',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actividadMeta = const VerificationMeta(
    'actividad',
  );
  @override
  late final GeneratedColumn<String> actividad = GeneratedColumn<String>(
    'actividad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ciudadMeta = const VerificationMeta('ciudad');
  @override
  late final GeneratedColumn<String> ciudad = GeneratedColumn<String>(
    'ciudad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _telefonoMeta = const VerificationMeta(
    'telefono',
  );
  @override
  late final GeneratedColumn<String> telefono = GeneratedColumn<String>(
    'telefono',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contactoMeta = const VerificationMeta(
    'contacto',
  );
  @override
  late final GeneratedColumn<String> contacto = GeneratedColumn<String>(
    'contacto',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    razonSocial,
    rfc,
    actividad,
    ciudad,
    telefono,
    email,
    contacto,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplierRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('razon_social')) {
      context.handle(
        _razonSocialMeta,
        razonSocial.isAcceptableOrUnknown(
          data['razon_social']!,
          _razonSocialMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_razonSocialMeta);
    }
    if (data.containsKey('rfc')) {
      context.handle(
        _rfcMeta,
        rfc.isAcceptableOrUnknown(data['rfc']!, _rfcMeta),
      );
    }
    if (data.containsKey('actividad')) {
      context.handle(
        _actividadMeta,
        actividad.isAcceptableOrUnknown(data['actividad']!, _actividadMeta),
      );
    }
    if (data.containsKey('ciudad')) {
      context.handle(
        _ciudadMeta,
        ciudad.isAcceptableOrUnknown(data['ciudad']!, _ciudadMeta),
      );
    }
    if (data.containsKey('telefono')) {
      context.handle(
        _telefonoMeta,
        telefono.isAcceptableOrUnknown(data['telefono']!, _telefonoMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('contacto')) {
      context.handle(
        _contactoMeta,
        contacto.isAcceptableOrUnknown(data['contacto']!, _contactoMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      razonSocial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}razon_social'],
      )!,
      rfc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rfc'],
      ),
      actividad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actividad'],
      ),
      ciudad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ciudad'],
      ),
      telefono: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telefono'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      contacto: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contacto'],
      ),
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class SupplierRow extends DataClass implements Insertable<SupplierRow> {
  final int id;
  final String razonSocial;
  final String? rfc;
  final String? actividad;
  final String? ciudad;
  final String? telefono;
  final String? email;
  final String? contacto;
  const SupplierRow({
    required this.id,
    required this.razonSocial,
    this.rfc,
    this.actividad,
    this.ciudad,
    this.telefono,
    this.email,
    this.contacto,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['razon_social'] = Variable<String>(razonSocial);
    if (!nullToAbsent || rfc != null) {
      map['rfc'] = Variable<String>(rfc);
    }
    if (!nullToAbsent || actividad != null) {
      map['actividad'] = Variable<String>(actividad);
    }
    if (!nullToAbsent || ciudad != null) {
      map['ciudad'] = Variable<String>(ciudad);
    }
    if (!nullToAbsent || telefono != null) {
      map['telefono'] = Variable<String>(telefono);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || contacto != null) {
      map['contacto'] = Variable<String>(contacto);
    }
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      razonSocial: Value(razonSocial),
      rfc: rfc == null && nullToAbsent ? const Value.absent() : Value(rfc),
      actividad: actividad == null && nullToAbsent
          ? const Value.absent()
          : Value(actividad),
      ciudad: ciudad == null && nullToAbsent
          ? const Value.absent()
          : Value(ciudad),
      telefono: telefono == null && nullToAbsent
          ? const Value.absent()
          : Value(telefono),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      contacto: contacto == null && nullToAbsent
          ? const Value.absent()
          : Value(contacto),
    );
  }

  factory SupplierRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierRow(
      id: serializer.fromJson<int>(json['id']),
      razonSocial: serializer.fromJson<String>(json['razonSocial']),
      rfc: serializer.fromJson<String?>(json['rfc']),
      actividad: serializer.fromJson<String?>(json['actividad']),
      ciudad: serializer.fromJson<String?>(json['ciudad']),
      telefono: serializer.fromJson<String?>(json['telefono']),
      email: serializer.fromJson<String?>(json['email']),
      contacto: serializer.fromJson<String?>(json['contacto']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'razonSocial': serializer.toJson<String>(razonSocial),
      'rfc': serializer.toJson<String?>(rfc),
      'actividad': serializer.toJson<String?>(actividad),
      'ciudad': serializer.toJson<String?>(ciudad),
      'telefono': serializer.toJson<String?>(telefono),
      'email': serializer.toJson<String?>(email),
      'contacto': serializer.toJson<String?>(contacto),
    };
  }

  SupplierRow copyWith({
    int? id,
    String? razonSocial,
    Value<String?> rfc = const Value.absent(),
    Value<String?> actividad = const Value.absent(),
    Value<String?> ciudad = const Value.absent(),
    Value<String?> telefono = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> contacto = const Value.absent(),
  }) => SupplierRow(
    id: id ?? this.id,
    razonSocial: razonSocial ?? this.razonSocial,
    rfc: rfc.present ? rfc.value : this.rfc,
    actividad: actividad.present ? actividad.value : this.actividad,
    ciudad: ciudad.present ? ciudad.value : this.ciudad,
    telefono: telefono.present ? telefono.value : this.telefono,
    email: email.present ? email.value : this.email,
    contacto: contacto.present ? contacto.value : this.contacto,
  );
  SupplierRow copyWithCompanion(SuppliersCompanion data) {
    return SupplierRow(
      id: data.id.present ? data.id.value : this.id,
      razonSocial: data.razonSocial.present
          ? data.razonSocial.value
          : this.razonSocial,
      rfc: data.rfc.present ? data.rfc.value : this.rfc,
      actividad: data.actividad.present ? data.actividad.value : this.actividad,
      ciudad: data.ciudad.present ? data.ciudad.value : this.ciudad,
      telefono: data.telefono.present ? data.telefono.value : this.telefono,
      email: data.email.present ? data.email.value : this.email,
      contacto: data.contacto.present ? data.contacto.value : this.contacto,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierRow(')
          ..write('id: $id, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('rfc: $rfc, ')
          ..write('actividad: $actividad, ')
          ..write('ciudad: $ciudad, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('contacto: $contacto')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    razonSocial,
    rfc,
    actividad,
    ciudad,
    telefono,
    email,
    contacto,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierRow &&
          other.id == this.id &&
          other.razonSocial == this.razonSocial &&
          other.rfc == this.rfc &&
          other.actividad == this.actividad &&
          other.ciudad == this.ciudad &&
          other.telefono == this.telefono &&
          other.email == this.email &&
          other.contacto == this.contacto);
}

class SuppliersCompanion extends UpdateCompanion<SupplierRow> {
  final Value<int> id;
  final Value<String> razonSocial;
  final Value<String?> rfc;
  final Value<String?> actividad;
  final Value<String?> ciudad;
  final Value<String?> telefono;
  final Value<String?> email;
  final Value<String?> contacto;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.razonSocial = const Value.absent(),
    this.rfc = const Value.absent(),
    this.actividad = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.contacto = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String razonSocial,
    this.rfc = const Value.absent(),
    this.actividad = const Value.absent(),
    this.ciudad = const Value.absent(),
    this.telefono = const Value.absent(),
    this.email = const Value.absent(),
    this.contacto = const Value.absent(),
  }) : razonSocial = Value(razonSocial);
  static Insertable<SupplierRow> custom({
    Expression<int>? id,
    Expression<String>? razonSocial,
    Expression<String>? rfc,
    Expression<String>? actividad,
    Expression<String>? ciudad,
    Expression<String>? telefono,
    Expression<String>? email,
    Expression<String>? contacto,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (razonSocial != null) 'razon_social': razonSocial,
      if (rfc != null) 'rfc': rfc,
      if (actividad != null) 'actividad': actividad,
      if (ciudad != null) 'ciudad': ciudad,
      if (telefono != null) 'telefono': telefono,
      if (email != null) 'email': email,
      if (contacto != null) 'contacto': contacto,
    });
  }

  SuppliersCompanion copyWith({
    Value<int>? id,
    Value<String>? razonSocial,
    Value<String?>? rfc,
    Value<String?>? actividad,
    Value<String?>? ciudad,
    Value<String?>? telefono,
    Value<String?>? email,
    Value<String?>? contacto,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      razonSocial: razonSocial ?? this.razonSocial,
      rfc: rfc ?? this.rfc,
      actividad: actividad ?? this.actividad,
      ciudad: ciudad ?? this.ciudad,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      contacto: contacto ?? this.contacto,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (razonSocial.present) {
      map['razon_social'] = Variable<String>(razonSocial.value);
    }
    if (rfc.present) {
      map['rfc'] = Variable<String>(rfc.value);
    }
    if (actividad.present) {
      map['actividad'] = Variable<String>(actividad.value);
    }
    if (ciudad.present) {
      map['ciudad'] = Variable<String>(ciudad.value);
    }
    if (telefono.present) {
      map['telefono'] = Variable<String>(telefono.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (contacto.present) {
      map['contacto'] = Variable<String>(contacto.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('razonSocial: $razonSocial, ')
          ..write('rfc: $rfc, ')
          ..write('actividad: $actividad, ')
          ..write('ciudad: $ciudad, ')
          ..write('telefono: $telefono, ')
          ..write('email: $email, ')
          ..write('contacto: $contacto')
          ..write(')'))
        .toString();
  }
}

class $SupplierProductsTable extends SupplierProducts
    with TableInfo<$SupplierProductsTable, SupplierProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<int> supplierId = GeneratedColumn<int>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _unidadMeta = const VerificationMeta('unidad');
  @override
  late final GeneratedColumn<String> unidad = GeneratedColumn<String>(
    'unidad',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _precioMeta = const VerificationMeta('precio');
  @override
  late final GeneratedColumn<double> precio = GeneratedColumn<double>(
    'precio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monedaMeta = const VerificationMeta('moneda');
  @override
  late final GeneratedColumn<String> moneda = GeneratedColumn<String>(
    'moneda',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MXN'),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    supplierId,
    nombre,
    unidad,
    precio,
    moneda,
    notas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_products';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplierProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('nombre')) {
      context.handle(
        _nombreMeta,
        nombre.isAcceptableOrUnknown(data['nombre']!, _nombreMeta),
      );
    } else if (isInserting) {
      context.missing(_nombreMeta);
    }
    if (data.containsKey('unidad')) {
      context.handle(
        _unidadMeta,
        unidad.isAcceptableOrUnknown(data['unidad']!, _unidadMeta),
      );
    }
    if (data.containsKey('precio')) {
      context.handle(
        _precioMeta,
        precio.isAcceptableOrUnknown(data['precio']!, _precioMeta),
      );
    }
    if (data.containsKey('moneda')) {
      context.handle(
        _monedaMeta,
        moneda.isAcceptableOrUnknown(data['moneda']!, _monedaMeta),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}supplier_id'],
      )!,
      nombre: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nombre'],
      )!,
      unidad: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unidad'],
      ),
      precio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}precio'],
      ),
      moneda: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moneda'],
      )!,
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
    );
  }

  @override
  $SupplierProductsTable createAlias(String alias) {
    return $SupplierProductsTable(attachedDatabase, alias);
  }
}

class SupplierProductRow extends DataClass
    implements Insertable<SupplierProductRow> {
  final int id;
  final int supplierId;
  final String nombre;
  final String? unidad;
  final double? precio;
  final String moneda;
  final String? notas;
  const SupplierProductRow({
    required this.id,
    required this.supplierId,
    required this.nombre,
    this.unidad,
    this.precio,
    required this.moneda,
    this.notas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_id'] = Variable<int>(supplierId);
    map['nombre'] = Variable<String>(nombre);
    if (!nullToAbsent || unidad != null) {
      map['unidad'] = Variable<String>(unidad);
    }
    if (!nullToAbsent || precio != null) {
      map['precio'] = Variable<double>(precio);
    }
    map['moneda'] = Variable<String>(moneda);
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    return map;
  }

  SupplierProductsCompanion toCompanion(bool nullToAbsent) {
    return SupplierProductsCompanion(
      id: Value(id),
      supplierId: Value(supplierId),
      nombre: Value(nombre),
      unidad: unidad == null && nullToAbsent
          ? const Value.absent()
          : Value(unidad),
      precio: precio == null && nullToAbsent
          ? const Value.absent()
          : Value(precio),
      moneda: Value(moneda),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
    );
  }

  factory SupplierProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierProductRow(
      id: serializer.fromJson<int>(json['id']),
      supplierId: serializer.fromJson<int>(json['supplierId']),
      nombre: serializer.fromJson<String>(json['nombre']),
      unidad: serializer.fromJson<String?>(json['unidad']),
      precio: serializer.fromJson<double?>(json['precio']),
      moneda: serializer.fromJson<String>(json['moneda']),
      notas: serializer.fromJson<String?>(json['notas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierId': serializer.toJson<int>(supplierId),
      'nombre': serializer.toJson<String>(nombre),
      'unidad': serializer.toJson<String?>(unidad),
      'precio': serializer.toJson<double?>(precio),
      'moneda': serializer.toJson<String>(moneda),
      'notas': serializer.toJson<String?>(notas),
    };
  }

  SupplierProductRow copyWith({
    int? id,
    int? supplierId,
    String? nombre,
    Value<String?> unidad = const Value.absent(),
    Value<double?> precio = const Value.absent(),
    String? moneda,
    Value<String?> notas = const Value.absent(),
  }) => SupplierProductRow(
    id: id ?? this.id,
    supplierId: supplierId ?? this.supplierId,
    nombre: nombre ?? this.nombre,
    unidad: unidad.present ? unidad.value : this.unidad,
    precio: precio.present ? precio.value : this.precio,
    moneda: moneda ?? this.moneda,
    notas: notas.present ? notas.value : this.notas,
  );
  SupplierProductRow copyWithCompanion(SupplierProductsCompanion data) {
    return SupplierProductRow(
      id: data.id.present ? data.id.value : this.id,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      nombre: data.nombre.present ? data.nombre.value : this.nombre,
      unidad: data.unidad.present ? data.unidad.value : this.unidad,
      precio: data.precio.present ? data.precio.value : this.precio,
      moneda: data.moneda.present ? data.moneda.value : this.moneda,
      notas: data.notas.present ? data.notas.value : this.notas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierProductRow(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('nombre: $nombre, ')
          ..write('unidad: $unidad, ')
          ..write('precio: $precio, ')
          ..write('moneda: $moneda, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, supplierId, nombre, unidad, precio, moneda, notas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierProductRow &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.nombre == this.nombre &&
          other.unidad == this.unidad &&
          other.precio == this.precio &&
          other.moneda == this.moneda &&
          other.notas == this.notas);
}

class SupplierProductsCompanion extends UpdateCompanion<SupplierProductRow> {
  final Value<int> id;
  final Value<int> supplierId;
  final Value<String> nombre;
  final Value<String?> unidad;
  final Value<double?> precio;
  final Value<String> moneda;
  final Value<String?> notas;
  const SupplierProductsCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.nombre = const Value.absent(),
    this.unidad = const Value.absent(),
    this.precio = const Value.absent(),
    this.moneda = const Value.absent(),
    this.notas = const Value.absent(),
  });
  SupplierProductsCompanion.insert({
    this.id = const Value.absent(),
    required int supplierId,
    required String nombre,
    this.unidad = const Value.absent(),
    this.precio = const Value.absent(),
    this.moneda = const Value.absent(),
    this.notas = const Value.absent(),
  }) : supplierId = Value(supplierId),
       nombre = Value(nombre);
  static Insertable<SupplierProductRow> custom({
    Expression<int>? id,
    Expression<int>? supplierId,
    Expression<String>? nombre,
    Expression<String>? unidad,
    Expression<double>? precio,
    Expression<String>? moneda,
    Expression<String>? notas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (nombre != null) 'nombre': nombre,
      if (unidad != null) 'unidad': unidad,
      if (precio != null) 'precio': precio,
      if (moneda != null) 'moneda': moneda,
      if (notas != null) 'notas': notas,
    });
  }

  SupplierProductsCompanion copyWith({
    Value<int>? id,
    Value<int>? supplierId,
    Value<String>? nombre,
    Value<String?>? unidad,
    Value<double?>? precio,
    Value<String>? moneda,
    Value<String?>? notas,
  }) {
    return SupplierProductsCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      nombre: nombre ?? this.nombre,
      unidad: unidad ?? this.unidad,
      precio: precio ?? this.precio,
      moneda: moneda ?? this.moneda,
      notas: notas ?? this.notas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<int>(supplierId.value);
    }
    if (nombre.present) {
      map['nombre'] = Variable<String>(nombre.value);
    }
    if (unidad.present) {
      map['unidad'] = Variable<String>(unidad.value);
    }
    if (precio.present) {
      map['precio'] = Variable<double>(precio.value);
    }
    if (moneda.present) {
      map['moneda'] = Variable<String>(moneda.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplierProductsCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('nombre: $nombre, ')
          ..write('unidad: $unidad, ')
          ..write('precio: $precio, ')
          ..write('moneda: $moneda, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }
}

class $QuotesTable extends Quotes with TableInfo<$QuotesTable, QuoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMxnMeta = const VerificationMeta(
    'amountMxn',
  );
  @override
  late final GeneratedColumn<double> amountMxn = GeneratedColumn<double>(
    'amount_mxn',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('MXN'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pendiente'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    description,
    amountMxn,
    currency,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quotes';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('amount_mxn')) {
      context.handle(
        _amountMxnMeta,
        amountMxn.isAcceptableOrUnknown(data['amount_mxn']!, _amountMxnMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMxnMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}project_id'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      amountMxn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_mxn'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $QuotesTable createAlias(String alias) {
    return $QuotesTable(attachedDatabase, alias);
  }
}

class QuoteRow extends DataClass implements Insertable<QuoteRow> {
  final int id;
  final int projectId;
  final String? description;
  final double amountMxn;
  final String currency;
  final String status;
  final String createdAt;
  const QuoteRow({
    required this.id,
    required this.projectId,
    this.description,
    required this.amountMxn,
    required this.currency,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<int>(projectId);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['amount_mxn'] = Variable<double>(amountMxn);
    map['currency'] = Variable<String>(currency);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  QuotesCompanion toCompanion(bool nullToAbsent) {
    return QuotesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      amountMxn: Value(amountMxn),
      currency: Value(currency),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory QuoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuoteRow(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<int>(json['projectId']),
      description: serializer.fromJson<String?>(json['description']),
      amountMxn: serializer.fromJson<double>(json['amountMxn']),
      currency: serializer.fromJson<String>(json['currency']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<int>(projectId),
      'description': serializer.toJson<String?>(description),
      'amountMxn': serializer.toJson<double>(amountMxn),
      'currency': serializer.toJson<String>(currency),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  QuoteRow copyWith({
    int? id,
    int? projectId,
    Value<String?> description = const Value.absent(),
    double? amountMxn,
    String? currency,
    String? status,
    String? createdAt,
  }) => QuoteRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    description: description.present ? description.value : this.description,
    amountMxn: amountMxn ?? this.amountMxn,
    currency: currency ?? this.currency,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  QuoteRow copyWithCompanion(QuotesCompanion data) {
    return QuoteRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      description: data.description.present
          ? data.description.value
          : this.description,
      amountMxn: data.amountMxn.present ? data.amountMxn.value : this.amountMxn,
      currency: data.currency.present ? data.currency.value : this.currency,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuoteRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('amountMxn: $amountMxn, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    description,
    amountMxn,
    currency,
    status,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuoteRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.description == this.description &&
          other.amountMxn == this.amountMxn &&
          other.currency == this.currency &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class QuotesCompanion extends UpdateCompanion<QuoteRow> {
  final Value<int> id;
  final Value<int> projectId;
  final Value<String?> description;
  final Value<double> amountMxn;
  final Value<String> currency;
  final Value<String> status;
  final Value<String> createdAt;
  const QuotesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.description = const Value.absent(),
    this.amountMxn = const Value.absent(),
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  QuotesCompanion.insert({
    this.id = const Value.absent(),
    required int projectId,
    this.description = const Value.absent(),
    required double amountMxn,
    this.currency = const Value.absent(),
    this.status = const Value.absent(),
    required String createdAt,
  }) : projectId = Value(projectId),
       amountMxn = Value(amountMxn),
       createdAt = Value(createdAt);
  static Insertable<QuoteRow> custom({
    Expression<int>? id,
    Expression<int>? projectId,
    Expression<String>? description,
    Expression<double>? amountMxn,
    Expression<String>? currency,
    Expression<String>? status,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (description != null) 'description': description,
      if (amountMxn != null) 'amount_mxn': amountMxn,
      if (currency != null) 'currency': currency,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  QuotesCompanion copyWith({
    Value<int>? id,
    Value<int>? projectId,
    Value<String?>? description,
    Value<double>? amountMxn,
    Value<String>? currency,
    Value<String>? status,
    Value<String>? createdAt,
  }) {
    return QuotesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      description: description ?? this.description,
      amountMxn: amountMxn ?? this.amountMxn,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amountMxn.present) {
      map['amount_mxn'] = Variable<double>(amountMxn.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuotesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('description: $description, ')
          ..write('amountMxn: $amountMxn, ')
          ..write('currency: $currency, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fechaMeta = const VerificationMeta('fecha');
  @override
  late final GeneratedColumn<String> fecha = GeneratedColumn<String>(
    'fecha',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completadaMeta = const VerificationMeta(
    'completada',
  );
  @override
  late final GeneratedColumn<bool> completada = GeneratedColumn<bool>(
    'completada',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("completada" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _proyectoIdMeta = const VerificationMeta(
    'proyectoId',
  );
  @override
  late final GeneratedColumn<int> proyectoId = GeneratedColumn<int>(
    'proyecto_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fecha,
    descripcion,
    completada,
    proyectoId,
    notas,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fecha')) {
      context.handle(
        _fechaMeta,
        fecha.isAcceptableOrUnknown(data['fecha']!, _fechaMeta),
      );
    } else if (isInserting) {
      context.missing(_fechaMeta);
    }
    if (data.containsKey('descripcion')) {
      context.handle(
        _descripcionMeta,
        descripcion.isAcceptableOrUnknown(
          data['descripcion']!,
          _descripcionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descripcionMeta);
    }
    if (data.containsKey('completada')) {
      context.handle(
        _completadaMeta,
        completada.isAcceptableOrUnknown(data['completada']!, _completadaMeta),
      );
    }
    if (data.containsKey('proyecto_id')) {
      context.handle(
        _proyectoIdMeta,
        proyectoId.isAcceptableOrUnknown(data['proyecto_id']!, _proyectoIdMeta),
      );
    }
    if (data.containsKey('notas')) {
      context.handle(
        _notasMeta,
        notas.isAcceptableOrUnknown(data['notas']!, _notasMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fecha: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fecha'],
      )!,
      descripcion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}descripcion'],
      )!,
      completada: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}completada'],
      )!,
      proyectoId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}proyecto_id'],
      ),
      notas: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notas'],
      ),
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final int id;
  final String fecha;
  final String descripcion;
  final bool completada;
  final int? proyectoId;
  final String? notas;
  const TaskRow({
    required this.id,
    required this.fecha,
    required this.descripcion,
    required this.completada,
    this.proyectoId,
    this.notas,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fecha'] = Variable<String>(fecha);
    map['descripcion'] = Variable<String>(descripcion);
    map['completada'] = Variable<bool>(completada);
    if (!nullToAbsent || proyectoId != null) {
      map['proyecto_id'] = Variable<int>(proyectoId);
    }
    if (!nullToAbsent || notas != null) {
      map['notas'] = Variable<String>(notas);
    }
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      fecha: Value(fecha),
      descripcion: Value(descripcion),
      completada: Value(completada),
      proyectoId: proyectoId == null && nullToAbsent
          ? const Value.absent()
          : Value(proyectoId),
      notas: notas == null && nullToAbsent
          ? const Value.absent()
          : Value(notas),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<int>(json['id']),
      fecha: serializer.fromJson<String>(json['fecha']),
      descripcion: serializer.fromJson<String>(json['descripcion']),
      completada: serializer.fromJson<bool>(json['completada']),
      proyectoId: serializer.fromJson<int?>(json['proyectoId']),
      notas: serializer.fromJson<String?>(json['notas']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fecha': serializer.toJson<String>(fecha),
      'descripcion': serializer.toJson<String>(descripcion),
      'completada': serializer.toJson<bool>(completada),
      'proyectoId': serializer.toJson<int?>(proyectoId),
      'notas': serializer.toJson<String?>(notas),
    };
  }

  TaskRow copyWith({
    int? id,
    String? fecha,
    String? descripcion,
    bool? completada,
    Value<int?> proyectoId = const Value.absent(),
    Value<String?> notas = const Value.absent(),
  }) => TaskRow(
    id: id ?? this.id,
    fecha: fecha ?? this.fecha,
    descripcion: descripcion ?? this.descripcion,
    completada: completada ?? this.completada,
    proyectoId: proyectoId.present ? proyectoId.value : this.proyectoId,
    notas: notas.present ? notas.value : this.notas,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      fecha: data.fecha.present ? data.fecha.value : this.fecha,
      descripcion: data.descripcion.present
          ? data.descripcion.value
          : this.descripcion,
      completada: data.completada.present
          ? data.completada.value
          : this.completada,
      proyectoId: data.proyectoId.present
          ? data.proyectoId.value
          : this.proyectoId,
      notas: data.notas.present ? data.notas.value : this.notas,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('descripcion: $descripcion, ')
          ..write('completada: $completada, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fecha, descripcion, completada, proyectoId, notas);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.fecha == this.fecha &&
          other.descripcion == this.descripcion &&
          other.completada == this.completada &&
          other.proyectoId == this.proyectoId &&
          other.notas == this.notas);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<int> id;
  final Value<String> fecha;
  final Value<String> descripcion;
  final Value<bool> completada;
  final Value<int?> proyectoId;
  final Value<String?> notas;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.fecha = const Value.absent(),
    this.descripcion = const Value.absent(),
    this.completada = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.notas = const Value.absent(),
  });
  TasksCompanion.insert({
    this.id = const Value.absent(),
    required String fecha,
    required String descripcion,
    this.completada = const Value.absent(),
    this.proyectoId = const Value.absent(),
    this.notas = const Value.absent(),
  }) : fecha = Value(fecha),
       descripcion = Value(descripcion);
  static Insertable<TaskRow> custom({
    Expression<int>? id,
    Expression<String>? fecha,
    Expression<String>? descripcion,
    Expression<bool>? completada,
    Expression<int>? proyectoId,
    Expression<String>? notas,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fecha != null) 'fecha': fecha,
      if (descripcion != null) 'descripcion': descripcion,
      if (completada != null) 'completada': completada,
      if (proyectoId != null) 'proyecto_id': proyectoId,
      if (notas != null) 'notas': notas,
    });
  }

  TasksCompanion copyWith({
    Value<int>? id,
    Value<String>? fecha,
    Value<String>? descripcion,
    Value<bool>? completada,
    Value<int?>? proyectoId,
    Value<String?>? notas,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      fecha: fecha ?? this.fecha,
      descripcion: descripcion ?? this.descripcion,
      completada: completada ?? this.completada,
      proyectoId: proyectoId ?? this.proyectoId,
      notas: notas ?? this.notas,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fecha.present) {
      map['fecha'] = Variable<String>(fecha.value);
    }
    if (descripcion.present) {
      map['descripcion'] = Variable<String>(descripcion.value);
    }
    if (completada.present) {
      map['completada'] = Variable<bool>(completada.value);
    }
    if (proyectoId.present) {
      map['proyecto_id'] = Variable<int>(proyectoId.value);
    }
    if (notas.present) {
      map['notas'] = Variable<String>(notas.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('fecha: $fecha, ')
          ..write('descripcion: $descripcion, ')
          ..write('completada: $completada, ')
          ..write('proyectoId: $proyectoId, ')
          ..write('notas: $notas')
          ..write(')'))
        .toString();
  }
}

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

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, BudgetRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<int> budgetId = GeneratedColumn<int>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeTypeMeta = const VerificationMeta(
    'scopeType',
  );
  @override
  late final GeneratedColumn<String> scopeType = GeneratedColumn<String>(
    'scope_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetLimitMeta = const VerificationMeta(
    'budgetLimit',
  );
  @override
  late final GeneratedColumn<double> budgetLimit = GeneratedColumn<double>(
    'budget_limit',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _spentMeta = const VerificationMeta('spent');
  @override
  late final GeneratedColumn<double> spent = GeneratedColumn<double>(
    'spent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _remainingMeta = const VerificationMeta(
    'remaining',
  );
  @override
  late final GeneratedColumn<double> remaining = GeneratedColumn<double>(
    'remaining',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _pctMeta = const VerificationMeta('pct');
  @override
  late final GeneratedColumn<double> pct = GeneratedColumn<double>(
    'pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _alertLevelMeta = const VerificationMeta(
    'alertLevel',
  );
  @override
  late final GeneratedColumn<String> alertLevel = GeneratedColumn<String>(
    'alert_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ok'),
  );
  static const VerificationMeta _alertThresholdPctMeta = const VerificationMeta(
    'alertThresholdPct',
  );
  @override
  late final GeneratedColumn<int> alertThresholdPct = GeneratedColumn<int>(
    'alert_threshold_pct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(80),
  );
  @override
  List<GeneratedColumn> get $columns => [
    budgetId,
    categoryId,
    categoryName,
    scopeType,
    budgetLimit,
    spent,
    remaining,
    pct,
    alertLevel,
    alertThresholdPct,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('scope_type')) {
      context.handle(
        _scopeTypeMeta,
        scopeType.isAcceptableOrUnknown(data['scope_type']!, _scopeTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeTypeMeta);
    }
    if (data.containsKey('budget_limit')) {
      context.handle(
        _budgetLimitMeta,
        budgetLimit.isAcceptableOrUnknown(
          data['budget_limit']!,
          _budgetLimitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_budgetLimitMeta);
    }
    if (data.containsKey('spent')) {
      context.handle(
        _spentMeta,
        spent.isAcceptableOrUnknown(data['spent']!, _spentMeta),
      );
    }
    if (data.containsKey('remaining')) {
      context.handle(
        _remainingMeta,
        remaining.isAcceptableOrUnknown(data['remaining']!, _remainingMeta),
      );
    }
    if (data.containsKey('pct')) {
      context.handle(
        _pctMeta,
        pct.isAcceptableOrUnknown(data['pct']!, _pctMeta),
      );
    }
    if (data.containsKey('alert_level')) {
      context.handle(
        _alertLevelMeta,
        alertLevel.isAcceptableOrUnknown(data['alert_level']!, _alertLevelMeta),
      );
    }
    if (data.containsKey('alert_threshold_pct')) {
      context.handle(
        _alertThresholdPctMeta,
        alertThresholdPct.isAcceptableOrUnknown(
          data['alert_threshold_pct']!,
          _alertThresholdPctMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {budgetId};
  @override
  BudgetRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetRow(
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      scopeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope_type'],
      )!,
      budgetLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}budget_limit'],
      )!,
      spent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}spent'],
      )!,
      remaining: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining'],
      )!,
      pct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pct'],
      )!,
      alertLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alert_level'],
      )!,
      alertThresholdPct: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}alert_threshold_pct'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class BudgetRow extends DataClass implements Insertable<BudgetRow> {
  final int budgetId;
  final int categoryId;
  final String categoryName;
  final String scopeType;
  final double budgetLimit;
  final double spent;
  final double remaining;
  final double pct;
  final String alertLevel;
  final int alertThresholdPct;
  const BudgetRow({
    required this.budgetId,
    required this.categoryId,
    required this.categoryName,
    required this.scopeType,
    required this.budgetLimit,
    required this.spent,
    required this.remaining,
    required this.pct,
    required this.alertLevel,
    required this.alertThresholdPct,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['budget_id'] = Variable<int>(budgetId);
    map['category_id'] = Variable<int>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['scope_type'] = Variable<String>(scopeType);
    map['budget_limit'] = Variable<double>(budgetLimit);
    map['spent'] = Variable<double>(spent);
    map['remaining'] = Variable<double>(remaining);
    map['pct'] = Variable<double>(pct);
    map['alert_level'] = Variable<String>(alertLevel);
    map['alert_threshold_pct'] = Variable<int>(alertThresholdPct);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      budgetId: Value(budgetId),
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      scopeType: Value(scopeType),
      budgetLimit: Value(budgetLimit),
      spent: Value(spent),
      remaining: Value(remaining),
      pct: Value(pct),
      alertLevel: Value(alertLevel),
      alertThresholdPct: Value(alertThresholdPct),
    );
  }

  factory BudgetRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetRow(
      budgetId: serializer.fromJson<int>(json['budgetId']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      scopeType: serializer.fromJson<String>(json['scopeType']),
      budgetLimit: serializer.fromJson<double>(json['budgetLimit']),
      spent: serializer.fromJson<double>(json['spent']),
      remaining: serializer.fromJson<double>(json['remaining']),
      pct: serializer.fromJson<double>(json['pct']),
      alertLevel: serializer.fromJson<String>(json['alertLevel']),
      alertThresholdPct: serializer.fromJson<int>(json['alertThresholdPct']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'budgetId': serializer.toJson<int>(budgetId),
      'categoryId': serializer.toJson<int>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'scopeType': serializer.toJson<String>(scopeType),
      'budgetLimit': serializer.toJson<double>(budgetLimit),
      'spent': serializer.toJson<double>(spent),
      'remaining': serializer.toJson<double>(remaining),
      'pct': serializer.toJson<double>(pct),
      'alertLevel': serializer.toJson<String>(alertLevel),
      'alertThresholdPct': serializer.toJson<int>(alertThresholdPct),
    };
  }

  BudgetRow copyWith({
    int? budgetId,
    int? categoryId,
    String? categoryName,
    String? scopeType,
    double? budgetLimit,
    double? spent,
    double? remaining,
    double? pct,
    String? alertLevel,
    int? alertThresholdPct,
  }) => BudgetRow(
    budgetId: budgetId ?? this.budgetId,
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    scopeType: scopeType ?? this.scopeType,
    budgetLimit: budgetLimit ?? this.budgetLimit,
    spent: spent ?? this.spent,
    remaining: remaining ?? this.remaining,
    pct: pct ?? this.pct,
    alertLevel: alertLevel ?? this.alertLevel,
    alertThresholdPct: alertThresholdPct ?? this.alertThresholdPct,
  );
  BudgetRow copyWithCompanion(BudgetsCompanion data) {
    return BudgetRow(
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      scopeType: data.scopeType.present ? data.scopeType.value : this.scopeType,
      budgetLimit: data.budgetLimit.present
          ? data.budgetLimit.value
          : this.budgetLimit,
      spent: data.spent.present ? data.spent.value : this.spent,
      remaining: data.remaining.present ? data.remaining.value : this.remaining,
      pct: data.pct.present ? data.pct.value : this.pct,
      alertLevel: data.alertLevel.present
          ? data.alertLevel.value
          : this.alertLevel,
      alertThresholdPct: data.alertThresholdPct.present
          ? data.alertThresholdPct.value
          : this.alertThresholdPct,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetRow(')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('scopeType: $scopeType, ')
          ..write('budgetLimit: $budgetLimit, ')
          ..write('spent: $spent, ')
          ..write('remaining: $remaining, ')
          ..write('pct: $pct, ')
          ..write('alertLevel: $alertLevel, ')
          ..write('alertThresholdPct: $alertThresholdPct')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    budgetId,
    categoryId,
    categoryName,
    scopeType,
    budgetLimit,
    spent,
    remaining,
    pct,
    alertLevel,
    alertThresholdPct,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetRow &&
          other.budgetId == this.budgetId &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.scopeType == this.scopeType &&
          other.budgetLimit == this.budgetLimit &&
          other.spent == this.spent &&
          other.remaining == this.remaining &&
          other.pct == this.pct &&
          other.alertLevel == this.alertLevel &&
          other.alertThresholdPct == this.alertThresholdPct);
}

class BudgetsCompanion extends UpdateCompanion<BudgetRow> {
  final Value<int> budgetId;
  final Value<int> categoryId;
  final Value<String> categoryName;
  final Value<String> scopeType;
  final Value<double> budgetLimit;
  final Value<double> spent;
  final Value<double> remaining;
  final Value<double> pct;
  final Value<String> alertLevel;
  final Value<int> alertThresholdPct;
  const BudgetsCompanion({
    this.budgetId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.scopeType = const Value.absent(),
    this.budgetLimit = const Value.absent(),
    this.spent = const Value.absent(),
    this.remaining = const Value.absent(),
    this.pct = const Value.absent(),
    this.alertLevel = const Value.absent(),
    this.alertThresholdPct = const Value.absent(),
  });
  BudgetsCompanion.insert({
    this.budgetId = const Value.absent(),
    required int categoryId,
    required String categoryName,
    required String scopeType,
    required double budgetLimit,
    this.spent = const Value.absent(),
    this.remaining = const Value.absent(),
    this.pct = const Value.absent(),
    this.alertLevel = const Value.absent(),
    this.alertThresholdPct = const Value.absent(),
  }) : categoryId = Value(categoryId),
       categoryName = Value(categoryName),
       scopeType = Value(scopeType),
       budgetLimit = Value(budgetLimit);
  static Insertable<BudgetRow> custom({
    Expression<int>? budgetId,
    Expression<int>? categoryId,
    Expression<String>? categoryName,
    Expression<String>? scopeType,
    Expression<double>? budgetLimit,
    Expression<double>? spent,
    Expression<double>? remaining,
    Expression<double>? pct,
    Expression<String>? alertLevel,
    Expression<int>? alertThresholdPct,
  }) {
    return RawValuesInsertable({
      if (budgetId != null) 'budget_id': budgetId,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (scopeType != null) 'scope_type': scopeType,
      if (budgetLimit != null) 'budget_limit': budgetLimit,
      if (spent != null) 'spent': spent,
      if (remaining != null) 'remaining': remaining,
      if (pct != null) 'pct': pct,
      if (alertLevel != null) 'alert_level': alertLevel,
      if (alertThresholdPct != null) 'alert_threshold_pct': alertThresholdPct,
    });
  }

  BudgetsCompanion copyWith({
    Value<int>? budgetId,
    Value<int>? categoryId,
    Value<String>? categoryName,
    Value<String>? scopeType,
    Value<double>? budgetLimit,
    Value<double>? spent,
    Value<double>? remaining,
    Value<double>? pct,
    Value<String>? alertLevel,
    Value<int>? alertThresholdPct,
  }) {
    return BudgetsCompanion(
      budgetId: budgetId ?? this.budgetId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      scopeType: scopeType ?? this.scopeType,
      budgetLimit: budgetLimit ?? this.budgetLimit,
      spent: spent ?? this.spent,
      remaining: remaining ?? this.remaining,
      pct: pct ?? this.pct,
      alertLevel: alertLevel ?? this.alertLevel,
      alertThresholdPct: alertThresholdPct ?? this.alertThresholdPct,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (budgetId.present) {
      map['budget_id'] = Variable<int>(budgetId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (scopeType.present) {
      map['scope_type'] = Variable<String>(scopeType.value);
    }
    if (budgetLimit.present) {
      map['budget_limit'] = Variable<double>(budgetLimit.value);
    }
    if (spent.present) {
      map['spent'] = Variable<double>(spent.value);
    }
    if (remaining.present) {
      map['remaining'] = Variable<double>(remaining.value);
    }
    if (pct.present) {
      map['pct'] = Variable<double>(pct.value);
    }
    if (alertLevel.present) {
      map['alert_level'] = Variable<String>(alertLevel.value);
    }
    if (alertThresholdPct.present) {
      map['alert_threshold_pct'] = Variable<int>(alertThresholdPct.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('scopeType: $scopeType, ')
          ..write('budgetLimit: $budgetLimit, ')
          ..write('spent: $spent, ')
          ..write('remaining: $remaining, ')
          ..write('pct: $pct, ')
          ..write('alertLevel: $alertLevel, ')
          ..write('alertThresholdPct: $alertThresholdPct')
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
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  late final $SupplierProductsTable supplierProducts = $SupplierProductsTable(
    this,
  );
  late final $QuotesTable quotes = $QuotesTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $InventoryMovementsTable inventoryMovements =
      $InventoryMovementsTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $PendingOpsTable pendingOps = $PendingOpsTable(this);
  late final $CacheEntriesTable cacheEntries = $CacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    transactions,
    suppliers,
    supplierProducts,
    quotes,
    tasks,
    inventoryItems,
    inventoryMovements,
    budgets,
    pendingOps,
    cacheEntries,
  ];
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      required String name,
      required String clientName,
      Value<String> status,
      Value<String?> color,
      Value<String?> description,
      required String createdAt,
      Value<double?> quoted,
      Value<double?> spent,
      Value<double?> pl,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> clientName,
      Value<String> status,
      Value<String?> color,
      Value<String?> description,
      Value<String> createdAt,
      Value<double?> quoted,
      Value<double?> spent,
      Value<double?> pl,
    });

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quoted => $composableBuilder(
    column: $table.quoted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spent => $composableBuilder(
    column: $table.spent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pl => $composableBuilder(
    column: $table.pl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quoted => $composableBuilder(
    column: $table.quoted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spent => $composableBuilder(
    column: $table.spent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pl => $composableBuilder(
    column: $table.pl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<double> get quoted =>
      $composableBuilder(column: $table.quoted, builder: (column) => column);

  GeneratedColumn<double> get spent =>
      $composableBuilder(column: $table.spent, builder: (column) => column);

  GeneratedColumn<double> get pl =>
      $composableBuilder(column: $table.pl, builder: (column) => column);
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (
            ProjectRow,
            BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow>,
          ),
          ProjectRow,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> clientName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<double?> quoted = const Value.absent(),
                Value<double?> spent = const Value.absent(),
                Value<double?> pl = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                clientName: clientName,
                status: status,
                color: color,
                description: description,
                createdAt: createdAt,
                quoted: quoted,
                spent: spent,
                pl: pl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String clientName,
                Value<String> status = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required String createdAt,
                Value<double?> quoted = const Value.absent(),
                Value<double?> spent = const Value.absent(),
                Value<double?> pl = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                clientName: clientName,
                status: status,
                color: color,
                description: description,
                createdAt: createdAt,
                quoted: quoted,
                spent: spent,
                pl: pl,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectRow, BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow>),
      ProjectRow,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      required String type,
      required String scopeType,
      Value<int?> scopeId,
      Value<int?> categoryId,
      Value<String?> categoryName,
      Value<String?> projectName,
      Value<String?> projectColor,
      required String description,
      required double amount,
      required String currency,
      required double exchangeRate,
      required double amountMxn,
      required String transactionDate,
      Value<String?> etapa,
      Value<String?> notes,
      required String createdAt,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<String> scopeType,
      Value<int?> scopeId,
      Value<int?> categoryId,
      Value<String?> categoryName,
      Value<String?> projectName,
      Value<String?> projectColor,
      Value<String> description,
      Value<double> amount,
      Value<String> currency,
      Value<double> exchangeRate,
      Value<double> amountMxn,
      Value<String> transactionDate,
      Value<String?> etapa,
      Value<String?> notes,
      Value<String> createdAt,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectColor => $composableBuilder(
    column: $table.projectColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountMxn => $composableBuilder(
    column: $table.amountMxn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etapa => $composableBuilder(
    column: $table.etapa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scopeId => $composableBuilder(
    column: $table.scopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectColor => $composableBuilder(
    column: $table.projectColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountMxn => $composableBuilder(
    column: $table.amountMxn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etapa => $composableBuilder(
    column: $table.etapa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get scopeType =>
      $composableBuilder(column: $table.scopeType, builder: (column) => column);

  GeneratedColumn<int> get scopeId =>
      $composableBuilder(column: $table.scopeId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectColor => $composableBuilder(
    column: $table.projectColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountMxn =>
      $composableBuilder(column: $table.amountMxn, builder: (column) => column);

  GeneratedColumn<String> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get etapa =>
      $composableBuilder(column: $table.etapa, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          TransactionRow,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            TransactionRow,
            BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
          ),
          TransactionRow,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> scopeType = const Value.absent(),
                Value<int?> scopeId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> projectName = const Value.absent(),
                Value<String?> projectColor = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> exchangeRate = const Value.absent(),
                Value<double> amountMxn = const Value.absent(),
                Value<String> transactionDate = const Value.absent(),
                Value<String?> etapa = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                type: type,
                scopeType: scopeType,
                scopeId: scopeId,
                categoryId: categoryId,
                categoryName: categoryName,
                projectName: projectName,
                projectColor: projectColor,
                description: description,
                amount: amount,
                currency: currency,
                exchangeRate: exchangeRate,
                amountMxn: amountMxn,
                transactionDate: transactionDate,
                etapa: etapa,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required String scopeType,
                Value<int?> scopeId = const Value.absent(),
                Value<int?> categoryId = const Value.absent(),
                Value<String?> categoryName = const Value.absent(),
                Value<String?> projectName = const Value.absent(),
                Value<String?> projectColor = const Value.absent(),
                required String description,
                required double amount,
                required String currency,
                required double exchangeRate,
                required double amountMxn,
                required String transactionDate,
                Value<String?> etapa = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
              }) => TransactionsCompanion.insert(
                id: id,
                type: type,
                scopeType: scopeType,
                scopeId: scopeId,
                categoryId: categoryId,
                categoryName: categoryName,
                projectName: projectName,
                projectColor: projectColor,
                description: description,
                amount: amount,
                currency: currency,
                exchangeRate: exchangeRate,
                amountMxn: amountMxn,
                transactionDate: transactionDate,
                etapa: etapa,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      TransactionRow,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        TransactionRow,
        BaseReferences<_$AppDatabase, $TransactionsTable, TransactionRow>,
      ),
      TransactionRow,
      PrefetchHooks Function()
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      required String razonSocial,
      Value<String?> rfc,
      Value<String?> actividad,
      Value<String?> ciudad,
      Value<String?> telefono,
      Value<String?> email,
      Value<String?> contacto,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      Value<String> razonSocial,
      Value<String?> rfc,
      Value<String?> actividad,
      Value<String?> ciudad,
      Value<String?> telefono,
      Value<String?> email,
      Value<String?> contacto,
    });

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
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

  ColumnFilters<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rfc => $composableBuilder(
    column: $table.rfc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actividad => $composableBuilder(
    column: $table.actividad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
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

  ColumnOrderings<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rfc => $composableBuilder(
    column: $table.rfc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actividad => $composableBuilder(
    column: $table.actividad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ciudad => $composableBuilder(
    column: $table.ciudad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telefono => $composableBuilder(
    column: $table.telefono,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contacto => $composableBuilder(
    column: $table.contacto,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get razonSocial => $composableBuilder(
    column: $table.razonSocial,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rfc =>
      $composableBuilder(column: $table.rfc, builder: (column) => column);

  GeneratedColumn<String> get actividad =>
      $composableBuilder(column: $table.actividad, builder: (column) => column);

  GeneratedColumn<String> get ciudad =>
      $composableBuilder(column: $table.ciudad, builder: (column) => column);

  GeneratedColumn<String> get telefono =>
      $composableBuilder(column: $table.telefono, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get contacto =>
      $composableBuilder(column: $table.contacto, builder: (column) => column);
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          SupplierRow,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (
            SupplierRow,
            BaseReferences<_$AppDatabase, $SuppliersTable, SupplierRow>,
          ),
          SupplierRow,
          PrefetchHooks Function()
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> razonSocial = const Value.absent(),
                Value<String?> rfc = const Value.absent(),
                Value<String?> actividad = const Value.absent(),
                Value<String?> ciudad = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> contacto = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                razonSocial: razonSocial,
                rfc: rfc,
                actividad: actividad,
                ciudad: ciudad,
                telefono: telefono,
                email: email,
                contacto: contacto,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String razonSocial,
                Value<String?> rfc = const Value.absent(),
                Value<String?> actividad = const Value.absent(),
                Value<String?> ciudad = const Value.absent(),
                Value<String?> telefono = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> contacto = const Value.absent(),
              }) => SuppliersCompanion.insert(
                id: id,
                razonSocial: razonSocial,
                rfc: rfc,
                actividad: actividad,
                ciudad: ciudad,
                telefono: telefono,
                email: email,
                contacto: contacto,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      SupplierRow,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (
        SupplierRow,
        BaseReferences<_$AppDatabase, $SuppliersTable, SupplierRow>,
      ),
      SupplierRow,
      PrefetchHooks Function()
    >;
typedef $$SupplierProductsTableCreateCompanionBuilder =
    SupplierProductsCompanion Function({
      Value<int> id,
      required int supplierId,
      required String nombre,
      Value<String?> unidad,
      Value<double?> precio,
      Value<String> moneda,
      Value<String?> notas,
    });
typedef $$SupplierProductsTableUpdateCompanionBuilder =
    SupplierProductsCompanion Function({
      Value<int> id,
      Value<int> supplierId,
      Value<String> nombre,
      Value<String?> unidad,
      Value<double?> precio,
      Value<String> moneda,
      Value<String?> notas,
    });

class $$SupplierProductsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierProductsTable> {
  $$SupplierProductsTableFilterComposer({
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

  ColumnFilters<int> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplierProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierProductsTable> {
  $$SupplierProductsTableOrderingComposer({
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

  ColumnOrderings<int> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nombre => $composableBuilder(
    column: $table.nombre,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unidad => $composableBuilder(
    column: $table.unidad,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get precio => $composableBuilder(
    column: $table.precio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moneda => $composableBuilder(
    column: $table.moneda,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplierProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierProductsTable> {
  $$SupplierProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nombre =>
      $composableBuilder(column: $table.nombre, builder: (column) => column);

  GeneratedColumn<String> get unidad =>
      $composableBuilder(column: $table.unidad, builder: (column) => column);

  GeneratedColumn<double> get precio =>
      $composableBuilder(column: $table.precio, builder: (column) => column);

  GeneratedColumn<String> get moneda =>
      $composableBuilder(column: $table.moneda, builder: (column) => column);

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);
}

class $$SupplierProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplierProductsTable,
          SupplierProductRow,
          $$SupplierProductsTableFilterComposer,
          $$SupplierProductsTableOrderingComposer,
          $$SupplierProductsTableAnnotationComposer,
          $$SupplierProductsTableCreateCompanionBuilder,
          $$SupplierProductsTableUpdateCompanionBuilder,
          (
            SupplierProductRow,
            BaseReferences<
              _$AppDatabase,
              $SupplierProductsTable,
              SupplierProductRow
            >,
          ),
          SupplierProductRow,
          PrefetchHooks Function()
        > {
  $$SupplierProductsTableTableManager(
    _$AppDatabase db,
    $SupplierProductsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> supplierId = const Value.absent(),
                Value<String> nombre = const Value.absent(),
                Value<String?> unidad = const Value.absent(),
                Value<double?> precio = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => SupplierProductsCompanion(
                id: id,
                supplierId: supplierId,
                nombre: nombre,
                unidad: unidad,
                precio: precio,
                moneda: moneda,
                notas: notas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int supplierId,
                required String nombre,
                Value<String?> unidad = const Value.absent(),
                Value<double?> precio = const Value.absent(),
                Value<String> moneda = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => SupplierProductsCompanion.insert(
                id: id,
                supplierId: supplierId,
                nombre: nombre,
                unidad: unidad,
                precio: precio,
                moneda: moneda,
                notas: notas,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplierProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplierProductsTable,
      SupplierProductRow,
      $$SupplierProductsTableFilterComposer,
      $$SupplierProductsTableOrderingComposer,
      $$SupplierProductsTableAnnotationComposer,
      $$SupplierProductsTableCreateCompanionBuilder,
      $$SupplierProductsTableUpdateCompanionBuilder,
      (
        SupplierProductRow,
        BaseReferences<
          _$AppDatabase,
          $SupplierProductsTable,
          SupplierProductRow
        >,
      ),
      SupplierProductRow,
      PrefetchHooks Function()
    >;
typedef $$QuotesTableCreateCompanionBuilder =
    QuotesCompanion Function({
      Value<int> id,
      required int projectId,
      Value<String?> description,
      required double amountMxn,
      Value<String> currency,
      Value<String> status,
      required String createdAt,
    });
typedef $$QuotesTableUpdateCompanionBuilder =
    QuotesCompanion Function({
      Value<int> id,
      Value<int> projectId,
      Value<String?> description,
      Value<double> amountMxn,
      Value<String> currency,
      Value<String> status,
      Value<String> createdAt,
    });

class $$QuotesTableFilterComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableFilterComposer({
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

  ColumnFilters<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountMxn => $composableBuilder(
    column: $table.amountMxn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuotesTableOrderingComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableOrderingComposer({
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

  ColumnOrderings<int> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountMxn => $composableBuilder(
    column: $table.amountMxn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuotesTable> {
  $$QuotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountMxn =>
      $composableBuilder(column: $table.amountMxn, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$QuotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuotesTable,
          QuoteRow,
          $$QuotesTableFilterComposer,
          $$QuotesTableOrderingComposer,
          $$QuotesTableAnnotationComposer,
          $$QuotesTableCreateCompanionBuilder,
          $$QuotesTableUpdateCompanionBuilder,
          (QuoteRow, BaseReferences<_$AppDatabase, $QuotesTable, QuoteRow>),
          QuoteRow,
          PrefetchHooks Function()
        > {
  $$QuotesTableTableManager(_$AppDatabase db, $QuotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> projectId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double> amountMxn = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => QuotesCompanion(
                id: id,
                projectId: projectId,
                description: description,
                amountMxn: amountMxn,
                currency: currency,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int projectId,
                Value<String?> description = const Value.absent(),
                required double amountMxn,
                Value<String> currency = const Value.absent(),
                Value<String> status = const Value.absent(),
                required String createdAt,
              }) => QuotesCompanion.insert(
                id: id,
                projectId: projectId,
                description: description,
                amountMxn: amountMxn,
                currency: currency,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuotesTable,
      QuoteRow,
      $$QuotesTableFilterComposer,
      $$QuotesTableOrderingComposer,
      $$QuotesTableAnnotationComposer,
      $$QuotesTableCreateCompanionBuilder,
      $$QuotesTableUpdateCompanionBuilder,
      (QuoteRow, BaseReferences<_$AppDatabase, $QuotesTable, QuoteRow>),
      QuoteRow,
      PrefetchHooks Function()
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      required String fecha,
      required String descripcion,
      Value<bool> completada,
      Value<int?> proyectoId,
      Value<String?> notas,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<int> id,
      Value<String> fecha,
      Value<String> descripcion,
      Value<bool> completada,
      Value<int?> proyectoId,
      Value<String?> notas,
    });

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
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

  ColumnFilters<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get proyectoId => $composableBuilder(
    column: $table.proyectoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
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

  ColumnOrderings<String> get fecha => $composableBuilder(
    column: $table.fecha,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get proyectoId => $composableBuilder(
    column: $table.proyectoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notas => $composableBuilder(
    column: $table.notas,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fecha =>
      $composableBuilder(column: $table.fecha, builder: (column) => column);

  GeneratedColumn<String> get descripcion => $composableBuilder(
    column: $table.descripcion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get completada => $composableBuilder(
    column: $table.completada,
    builder: (column) => column,
  );

  GeneratedColumn<int> get proyectoId => $composableBuilder(
    column: $table.proyectoId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notas =>
      $composableBuilder(column: $table.notas, builder: (column) => column);
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
          TaskRow,
          PrefetchHooks Function()
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> fecha = const Value.absent(),
                Value<String> descripcion = const Value.absent(),
                Value<bool> completada = const Value.absent(),
                Value<int?> proyectoId = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                fecha: fecha,
                descripcion: descripcion,
                completada: completada,
                proyectoId: proyectoId,
                notas: notas,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String fecha,
                required String descripcion,
                Value<bool> completada = const Value.absent(),
                Value<int?> proyectoId = const Value.absent(),
                Value<String?> notas = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                fecha: fecha,
                descripcion: descripcion,
                completada: completada,
                proyectoId: proyectoId,
                notas: notas,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, BaseReferences<_$AppDatabase, $TasksTable, TaskRow>),
      TaskRow,
      PrefetchHooks Function()
    >;
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
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> budgetId,
      required int categoryId,
      required String categoryName,
      required String scopeType,
      required double budgetLimit,
      Value<double> spent,
      Value<double> remaining,
      Value<double> pct,
      Value<String> alertLevel,
      Value<int> alertThresholdPct,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<int> budgetId,
      Value<int> categoryId,
      Value<String> categoryName,
      Value<String> scopeType,
      Value<double> budgetLimit,
      Value<double> spent,
      Value<double> remaining,
      Value<double> pct,
      Value<String> alertLevel,
      Value<int> alertThresholdPct,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get budgetLimit => $composableBuilder(
    column: $table.budgetLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get spent => $composableBuilder(
    column: $table.spent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pct => $composableBuilder(
    column: $table.pct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alertLevel => $composableBuilder(
    column: $table.alertLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get alertThresholdPct => $composableBuilder(
    column: $table.alertThresholdPct,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scopeType => $composableBuilder(
    column: $table.scopeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get budgetLimit => $composableBuilder(
    column: $table.budgetLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get spent => $composableBuilder(
    column: $table.spent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remaining => $composableBuilder(
    column: $table.remaining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pct => $composableBuilder(
    column: $table.pct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alertLevel => $composableBuilder(
    column: $table.alertLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get alertThresholdPct => $composableBuilder(
    column: $table.alertThresholdPct,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<int> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scopeType =>
      $composableBuilder(column: $table.scopeType, builder: (column) => column);

  GeneratedColumn<double> get budgetLimit => $composableBuilder(
    column: $table.budgetLimit,
    builder: (column) => column,
  );

  GeneratedColumn<double> get spent =>
      $composableBuilder(column: $table.spent, builder: (column) => column);

  GeneratedColumn<double> get remaining =>
      $composableBuilder(column: $table.remaining, builder: (column) => column);

  GeneratedColumn<double> get pct =>
      $composableBuilder(column: $table.pct, builder: (column) => column);

  GeneratedColumn<String> get alertLevel => $composableBuilder(
    column: $table.alertLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get alertThresholdPct => $composableBuilder(
    column: $table.alertThresholdPct,
    builder: (column) => column,
  );
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          BudgetRow,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
          BudgetRow,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> budgetId = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<String> scopeType = const Value.absent(),
                Value<double> budgetLimit = const Value.absent(),
                Value<double> spent = const Value.absent(),
                Value<double> remaining = const Value.absent(),
                Value<double> pct = const Value.absent(),
                Value<String> alertLevel = const Value.absent(),
                Value<int> alertThresholdPct = const Value.absent(),
              }) => BudgetsCompanion(
                budgetId: budgetId,
                categoryId: categoryId,
                categoryName: categoryName,
                scopeType: scopeType,
                budgetLimit: budgetLimit,
                spent: spent,
                remaining: remaining,
                pct: pct,
                alertLevel: alertLevel,
                alertThresholdPct: alertThresholdPct,
              ),
          createCompanionCallback:
              ({
                Value<int> budgetId = const Value.absent(),
                required int categoryId,
                required String categoryName,
                required String scopeType,
                required double budgetLimit,
                Value<double> spent = const Value.absent(),
                Value<double> remaining = const Value.absent(),
                Value<double> pct = const Value.absent(),
                Value<String> alertLevel = const Value.absent(),
                Value<int> alertThresholdPct = const Value.absent(),
              }) => BudgetsCompanion.insert(
                budgetId: budgetId,
                categoryId: categoryId,
                categoryName: categoryName,
                scopeType: scopeType,
                budgetLimit: budgetLimit,
                spent: spent,
                remaining: remaining,
                pct: pct,
                alertLevel: alertLevel,
                alertThresholdPct: alertThresholdPct,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      BudgetRow,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (BudgetRow, BaseReferences<_$AppDatabase, $BudgetsTable, BudgetRow>),
      BudgetRow,
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
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
  $$SupplierProductsTableTableManager get supplierProducts =>
      $$SupplierProductsTableTableManager(_db, _db.supplierProducts);
  $$QuotesTableTableManager get quotes =>
      $$QuotesTableTableManager(_db, _db.quotes);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$InventoryMovementsTableTableManager get inventoryMovements =>
      $$InventoryMovementsTableTableManager(_db, _db.inventoryMovements);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$PendingOpsTableTableManager get pendingOps =>
      $$PendingOpsTableTableManager(_db, _db.pendingOps);
  $$CacheEntriesTableTableManager get cacheEntries =>
      $$CacheEntriesTableTableManager(_db, _db.cacheEntries);
}
