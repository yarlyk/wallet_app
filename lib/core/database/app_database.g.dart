// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CurrenciesTable extends Currencies
    with TableInfo<$CurrenciesTable, Currency> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CurrenciesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 8),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, true,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 10),
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _numCodeMeta =
      const VerificationMeta('numCode');
  @override
  late final GeneratedColumn<int> numCode = GeneratedColumn<int>(
      'num_code', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nominalMeta =
      const VerificationMeta('nominal');
  @override
  late final GeneratedColumn<int> nominal = GeneratedColumn<int>(
      'nominal', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _countryMeta =
      const VerificationMeta('country');
  @override
  late final GeneratedColumn<String> country = GeneratedColumn<String>(
      'country', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, code, name, symbol, isActive, numCode, nominal, country];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(Insertable<Currency> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('num_code')) {
      context.handle(_numCodeMeta,
          numCode.isAcceptableOrUnknown(data['num_code']!, _numCodeMeta));
    } else if (isInserting) {
      context.missing(_numCodeMeta);
    }
    if (data.containsKey('nominal')) {
      context.handle(_nominalMeta,
          nominal.isAcceptableOrUnknown(data['nominal']!, _nominalMeta));
    }
    if (data.containsKey('country')) {
      context.handle(_countryMeta,
          country.isAcceptableOrUnknown(data['country']!, _countryMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Currency map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Currency(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      numCode: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}num_code'])!,
      nominal: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}nominal'])!,
      country: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}country']),
    );
  }

  @override
  $CurrenciesTable createAlias(String alias) {
    return $CurrenciesTable(attachedDatabase, alias);
  }
}

class Currency extends DataClass implements Insertable<Currency> {
  final int id;
  final String code;
  final String name;
  final String? symbol;
  final bool isActive;
  final int numCode;
  final int nominal;
  final String? country;
  const Currency(
      {required this.id,
      required this.code,
      required this.name,
      this.symbol,
      required this.isActive,
      required this.numCode,
      required this.nominal,
      this.country});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || symbol != null) {
      map['symbol'] = Variable<String>(symbol);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['num_code'] = Variable<int>(numCode);
    map['nominal'] = Variable<int>(nominal);
    if (!nullToAbsent || country != null) {
      map['country'] = Variable<String>(country);
    }
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      symbol:
          symbol == null && nullToAbsent ? const Value.absent() : Value(symbol),
      isActive: Value(isActive),
      numCode: Value(numCode),
      nominal: Value(nominal),
      country: country == null && nullToAbsent
          ? const Value.absent()
          : Value(country),
    );
  }

  factory Currency.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Currency(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String?>(json['symbol']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      numCode: serializer.fromJson<int>(json['numCode']),
      nominal: serializer.fromJson<int>(json['nominal']),
      country: serializer.fromJson<String?>(json['country']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String?>(symbol),
      'isActive': serializer.toJson<bool>(isActive),
      'numCode': serializer.toJson<int>(numCode),
      'nominal': serializer.toJson<int>(nominal),
      'country': serializer.toJson<String?>(country),
    };
  }

  Currency copyWith(
          {int? id,
          String? code,
          String? name,
          Value<String?> symbol = const Value.absent(),
          bool? isActive,
          int? numCode,
          int? nominal,
          Value<String?> country = const Value.absent()}) =>
      Currency(
        id: id ?? this.id,
        code: code ?? this.code,
        name: name ?? this.name,
        symbol: symbol.present ? symbol.value : this.symbol,
        isActive: isActive ?? this.isActive,
        numCode: numCode ?? this.numCode,
        nominal: nominal ?? this.nominal,
        country: country.present ? country.value : this.country,
      );
  Currency copyWithCompanion(CurrenciesCompanion data) {
    return Currency(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      numCode: data.numCode.present ? data.numCode.value : this.numCode,
      nominal: data.nominal.present ? data.nominal.value : this.nominal,
      country: data.country.present ? data.country.value : this.country,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Currency(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('isActive: $isActive, ')
          ..write('numCode: $numCode, ')
          ..write('nominal: $nominal, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, symbol, isActive, numCode, nominal, country);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Currency &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.isActive == this.isActive &&
          other.numCode == this.numCode &&
          other.nominal == this.nominal &&
          other.country == this.country);
}

class CurrenciesCompanion extends UpdateCompanion<Currency> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String?> symbol;
  final Value<bool> isActive;
  final Value<int> numCode;
  final Value<int> nominal;
  final Value<String?> country;
  const CurrenciesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.isActive = const Value.absent(),
    this.numCode = const Value.absent(),
    this.nominal = const Value.absent(),
    this.country = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String name,
    this.symbol = const Value.absent(),
    this.isActive = const Value.absent(),
    required int numCode,
    this.nominal = const Value.absent(),
    this.country = const Value.absent(),
  })  : code = Value(code),
        name = Value(name),
        numCode = Value(numCode);
  static Insertable<Currency> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<bool>? isActive,
    Expression<int>? numCode,
    Expression<int>? nominal,
    Expression<String>? country,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (isActive != null) 'is_active': isActive,
      if (numCode != null) 'num_code': numCode,
      if (nominal != null) 'nominal': nominal,
      if (country != null) 'country': country,
    });
  }

  CurrenciesCompanion copyWith(
      {Value<int>? id,
      Value<String>? code,
      Value<String>? name,
      Value<String?>? symbol,
      Value<bool>? isActive,
      Value<int>? numCode,
      Value<int>? nominal,
      Value<String?>? country}) {
    return CurrenciesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      isActive: isActive ?? this.isActive,
      numCode: numCode ?? this.numCode,
      nominal: nominal ?? this.nominal,
      country: country ?? this.country,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (numCode.present) {
      map['num_code'] = Variable<int>(numCode.value);
    }
    if (nominal.present) {
      map['nominal'] = Variable<int>(nominal.value);
    }
    if (country.present) {
      map['country'] = Variable<String>(country.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('isActive: $isActive, ')
          ..write('numCode: $numCode, ')
          ..write('nominal: $nominal, ')
          ..write('country: $country')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, name, isActive, icon];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final int id;
  final String name;
  final bool isActive;
  final String? icon;
  const Project(
      {required this.id,
      required this.name,
      required this.isActive,
      this.icon});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      icon: serializer.fromJson<String?>(json['icon']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'icon': serializer.toJson<String?>(icon),
    };
  }

  Project copyWith(
          {int? id,
          String? name,
          bool? isActive,
          Value<String?> icon = const Value.absent()}) =>
      Project(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        icon: icon.present ? icon.value : this.icon,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      icon: data.icon.present ? data.icon.value : this.icon,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, icon);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.icon == this.icon);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<String?> icon;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.icon = const Value.absent(),
  });
  ProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.isActive = const Value.absent(),
    this.icon = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Project> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<String>? icon,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (icon != null) 'icon': icon,
    });
  }

  ProjectsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<bool>? isActive,
      Value<String?>? icon}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      icon: icon ?? this.icon,
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
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('icon: $icon')
          ..write(')'))
        .toString();
  }
}

class $AccountGroupsTable extends AccountGroups
    with TableInfo<$AccountGroupsTable, AccountGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES account_groups (id)'));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [id, name, icon, parentId, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_groups';
  @override
  VerificationContext validateIntegrity(Insertable<AccountGroup> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $AccountGroupsTable createAlias(String alias) {
    return $AccountGroupsTable(attachedDatabase, alias);
  }
}

class AccountGroup extends DataClass implements Insertable<AccountGroup> {
  final int id;
  final String name;
  final String? icon;
  final int? parentId;
  final bool isActive;
  const AccountGroup(
      {required this.id,
      required this.name,
      this.icon,
      this.parentId,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  AccountGroupsCompanion toCompanion(bool nullToAbsent) {
    return AccountGroupsCompanion(
      id: Value(id),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isActive: Value(isActive),
    );
  }

  factory AccountGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountGroup(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'parentId': serializer.toJson<int?>(parentId),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  AccountGroup copyWith(
          {int? id,
          String? name,
          Value<String?> icon = const Value.absent(),
          Value<int?> parentId = const Value.absent(),
          bool? isActive}) =>
      AccountGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon.present ? icon.value : this.icon,
        parentId: parentId.present ? parentId.value : this.parentId,
        isActive: isActive ?? this.isActive,
      );
  AccountGroup copyWithCompanion(AccountGroupsCompanion data) {
    return AccountGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, parentId, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.parentId == this.parentId &&
          other.isActive == this.isActive);
}

class AccountGroupsCompanion extends UpdateCompanion<AccountGroup> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> icon;
  final Value<int?> parentId;
  final Value<bool> isActive;
  const AccountGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  AccountGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name);
  static Insertable<AccountGroup> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? parentId,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (parentId != null) 'parent_id': parentId,
      if (isActive != null) 'is_active': isActive,
    });
  }

  AccountGroupsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? icon,
      Value<int?>? parentId,
      Value<bool>? isActive}) {
    return AccountGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('parentId: $parentId, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
      'group_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES account_groups (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 255),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 20),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _currencyIdMeta =
      const VerificationMeta('currencyId');
  @override
  late final GeneratedColumn<int> currencyId = GeneratedColumn<int>(
      'currency_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES currencies (id)'));
  static const VerificationMeta _initialBalanceMeta =
      const VerificationMeta('initialBalance');
  @override
  late final GeneratedColumn<double> initialBalance = GeneratedColumn<double>(
      'initial_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isCreditCardMeta =
      const VerificationMeta('isCreditCard');
  @override
  late final GeneratedColumn<bool> isCreditCard = GeneratedColumn<bool>(
      'is_credit_card', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_credit_card" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _creditLimitMeta =
      const VerificationMeta('creditLimit');
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
      'credit_limit', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _paymentDueDateMeta =
      const VerificationMeta('paymentDueDate');
  @override
  late final GeneratedColumn<String> paymentDueDate = GeneratedColumn<String>(
      'payment_due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _gracePeriodDaysMeta =
      const VerificationMeta('gracePeriodDays');
  @override
  late final GeneratedColumn<int> gracePeriodDays = GeneratedColumn<int>(
      'grace_period_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _cardLast4DigitsMeta =
      const VerificationMeta('cardLast4Digits');
  @override
  late final GeneratedColumn<String> cardLast4Digits = GeneratedColumn<String>(
      'card_last4_digits', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _accountLast4DigitsMeta =
      const VerificationMeta('accountLast4Digits');
  @override
  late final GeneratedColumn<String> accountLast4Digits =
      GeneratedColumn<String>('account_last4_digits', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _smsSenderNameMeta =
      const VerificationMeta('smsSenderName');
  @override
  late final GeneratedColumn<String> smsSenderName = GeneratedColumn<String>(
      'sms_sender_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        groupId,
        name,
        icon,
        type,
        currencyId,
        initialBalance,
        isActive,
        isCreditCard,
        creditLimit,
        paymentDueDate,
        gracePeriodDays,
        cardLast4Digits,
        accountLast4Digits,
        smsSenderName
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('currency_id')) {
      context.handle(
          _currencyIdMeta,
          currencyId.isAcceptableOrUnknown(
              data['currency_id']!, _currencyIdMeta));
    } else if (isInserting) {
      context.missing(_currencyIdMeta);
    }
    if (data.containsKey('initial_balance')) {
      context.handle(
          _initialBalanceMeta,
          initialBalance.isAcceptableOrUnknown(
              data['initial_balance']!, _initialBalanceMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_credit_card')) {
      context.handle(
          _isCreditCardMeta,
          isCreditCard.isAcceptableOrUnknown(
              data['is_credit_card']!, _isCreditCardMeta));
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
          _creditLimitMeta,
          creditLimit.isAcceptableOrUnknown(
              data['credit_limit']!, _creditLimitMeta));
    }
    if (data.containsKey('payment_due_date')) {
      context.handle(
          _paymentDueDateMeta,
          paymentDueDate.isAcceptableOrUnknown(
              data['payment_due_date']!, _paymentDueDateMeta));
    }
    if (data.containsKey('grace_period_days')) {
      context.handle(
          _gracePeriodDaysMeta,
          gracePeriodDays.isAcceptableOrUnknown(
              data['grace_period_days']!, _gracePeriodDaysMeta));
    }
    if (data.containsKey('card_last4_digits')) {
      context.handle(
          _cardLast4DigitsMeta,
          cardLast4Digits.isAcceptableOrUnknown(
              data['card_last4_digits']!, _cardLast4DigitsMeta));
    }
    if (data.containsKey('account_last4_digits')) {
      context.handle(
          _accountLast4DigitsMeta,
          accountLast4Digits.isAcceptableOrUnknown(
              data['account_last4_digits']!, _accountLast4DigitsMeta));
    }
    if (data.containsKey('sms_sender_name')) {
      context.handle(
          _smsSenderNameMeta,
          smsSenderName.isAcceptableOrUnknown(
              data['sms_sender_name']!, _smsSenderNameMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}group_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currencyId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}currency_id'])!,
      initialBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}initial_balance'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isCreditCard: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_credit_card'])!,
      creditLimit: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}credit_limit']),
      paymentDueDate: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}payment_due_date']),
      gracePeriodDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}grace_period_days']),
      cardLast4Digits: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}card_last4_digits']),
      accountLast4Digits: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}account_last4_digits']),
      smsSenderName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sms_sender_name']),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final int? groupId;
  final String name;
  final String? icon;
  final String type;
  final int currencyId;
  final double initialBalance;
  final bool isActive;
  final bool isCreditCard;
  final double? creditLimit;
  final String? paymentDueDate;
  final int? gracePeriodDays;
  final String? cardLast4Digits;
  final String? accountLast4Digits;
  final String? smsSenderName;
  const Account(
      {required this.id,
      this.groupId,
      required this.name,
      this.icon,
      required this.type,
      required this.currencyId,
      required this.initialBalance,
      required this.isActive,
      required this.isCreditCard,
      this.creditLimit,
      this.paymentDueDate,
      this.gracePeriodDays,
      this.cardLast4Digits,
      this.accountLast4Digits,
      this.smsSenderName});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<int>(groupId);
    }
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['type'] = Variable<String>(type);
    map['currency_id'] = Variable<int>(currencyId);
    map['initial_balance'] = Variable<double>(initialBalance);
    map['is_active'] = Variable<bool>(isActive);
    map['is_credit_card'] = Variable<bool>(isCreditCard);
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<double>(creditLimit);
    }
    if (!nullToAbsent || paymentDueDate != null) {
      map['payment_due_date'] = Variable<String>(paymentDueDate);
    }
    if (!nullToAbsent || gracePeriodDays != null) {
      map['grace_period_days'] = Variable<int>(gracePeriodDays);
    }
    if (!nullToAbsent || cardLast4Digits != null) {
      map['card_last4_digits'] = Variable<String>(cardLast4Digits);
    }
    if (!nullToAbsent || accountLast4Digits != null) {
      map['account_last4_digits'] = Variable<String>(accountLast4Digits);
    }
    if (!nullToAbsent || smsSenderName != null) {
      map['sms_sender_name'] = Variable<String>(smsSenderName);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      name: Value(name),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      type: Value(type),
      currencyId: Value(currencyId),
      initialBalance: Value(initialBalance),
      isActive: Value(isActive),
      isCreditCard: Value(isCreditCard),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
      paymentDueDate: paymentDueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDueDate),
      gracePeriodDays: gracePeriodDays == null && nullToAbsent
          ? const Value.absent()
          : Value(gracePeriodDays),
      cardLast4Digits: cardLast4Digits == null && nullToAbsent
          ? const Value.absent()
          : Value(cardLast4Digits),
      accountLast4Digits: accountLast4Digits == null && nullToAbsent
          ? const Value.absent()
          : Value(accountLast4Digits),
      smsSenderName: smsSenderName == null && nullToAbsent
          ? const Value.absent()
          : Value(smsSenderName),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      groupId: serializer.fromJson<int?>(json['groupId']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String?>(json['icon']),
      type: serializer.fromJson<String>(json['type']),
      currencyId: serializer.fromJson<int>(json['currencyId']),
      initialBalance: serializer.fromJson<double>(json['initialBalance']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isCreditCard: serializer.fromJson<bool>(json['isCreditCard']),
      creditLimit: serializer.fromJson<double?>(json['creditLimit']),
      paymentDueDate: serializer.fromJson<String?>(json['paymentDueDate']),
      gracePeriodDays: serializer.fromJson<int?>(json['gracePeriodDays']),
      cardLast4Digits: serializer.fromJson<String?>(json['cardLast4Digits']),
      accountLast4Digits:
          serializer.fromJson<String?>(json['accountLast4Digits']),
      smsSenderName: serializer.fromJson<String?>(json['smsSenderName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'groupId': serializer.toJson<int?>(groupId),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String?>(icon),
      'type': serializer.toJson<String>(type),
      'currencyId': serializer.toJson<int>(currencyId),
      'initialBalance': serializer.toJson<double>(initialBalance),
      'isActive': serializer.toJson<bool>(isActive),
      'isCreditCard': serializer.toJson<bool>(isCreditCard),
      'creditLimit': serializer.toJson<double?>(creditLimit),
      'paymentDueDate': serializer.toJson<String?>(paymentDueDate),
      'gracePeriodDays': serializer.toJson<int?>(gracePeriodDays),
      'cardLast4Digits': serializer.toJson<String?>(cardLast4Digits),
      'accountLast4Digits': serializer.toJson<String?>(accountLast4Digits),
      'smsSenderName': serializer.toJson<String?>(smsSenderName),
    };
  }

  Account copyWith(
          {int? id,
          Value<int?> groupId = const Value.absent(),
          String? name,
          Value<String?> icon = const Value.absent(),
          String? type,
          int? currencyId,
          double? initialBalance,
          bool? isActive,
          bool? isCreditCard,
          Value<double?> creditLimit = const Value.absent(),
          Value<String?> paymentDueDate = const Value.absent(),
          Value<int?> gracePeriodDays = const Value.absent(),
          Value<String?> cardLast4Digits = const Value.absent(),
          Value<String?> accountLast4Digits = const Value.absent(),
          Value<String?> smsSenderName = const Value.absent()}) =>
      Account(
        id: id ?? this.id,
        groupId: groupId.present ? groupId.value : this.groupId,
        name: name ?? this.name,
        icon: icon.present ? icon.value : this.icon,
        type: type ?? this.type,
        currencyId: currencyId ?? this.currencyId,
        initialBalance: initialBalance ?? this.initialBalance,
        isActive: isActive ?? this.isActive,
        isCreditCard: isCreditCard ?? this.isCreditCard,
        creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
        paymentDueDate:
            paymentDueDate.present ? paymentDueDate.value : this.paymentDueDate,
        gracePeriodDays: gracePeriodDays.present
            ? gracePeriodDays.value
            : this.gracePeriodDays,
        cardLast4Digits: cardLast4Digits.present
            ? cardLast4Digits.value
            : this.cardLast4Digits,
        accountLast4Digits: accountLast4Digits.present
            ? accountLast4Digits.value
            : this.accountLast4Digits,
        smsSenderName:
            smsSenderName.present ? smsSenderName.value : this.smsSenderName,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      type: data.type.present ? data.type.value : this.type,
      currencyId:
          data.currencyId.present ? data.currencyId.value : this.currencyId,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isCreditCard: data.isCreditCard.present
          ? data.isCreditCard.value
          : this.isCreditCard,
      creditLimit:
          data.creditLimit.present ? data.creditLimit.value : this.creditLimit,
      paymentDueDate: data.paymentDueDate.present
          ? data.paymentDueDate.value
          : this.paymentDueDate,
      gracePeriodDays: data.gracePeriodDays.present
          ? data.gracePeriodDays.value
          : this.gracePeriodDays,
      cardLast4Digits: data.cardLast4Digits.present
          ? data.cardLast4Digits.value
          : this.cardLast4Digits,
      accountLast4Digits: data.accountLast4Digits.present
          ? data.accountLast4Digits.value
          : this.accountLast4Digits,
      smsSenderName: data.smsSenderName.present
          ? data.smsSenderName.value
          : this.smsSenderName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('currencyId: $currencyId, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('isActive: $isActive, ')
          ..write('isCreditCard: $isCreditCard, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('gracePeriodDays: $gracePeriodDays, ')
          ..write('cardLast4Digits: $cardLast4Digits, ')
          ..write('accountLast4Digits: $accountLast4Digits, ')
          ..write('smsSenderName: $smsSenderName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      groupId,
      name,
      icon,
      type,
      currencyId,
      initialBalance,
      isActive,
      isCreditCard,
      creditLimit,
      paymentDueDate,
      gracePeriodDays,
      cardLast4Digits,
      accountLast4Digits,
      smsSenderName);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.type == this.type &&
          other.currencyId == this.currencyId &&
          other.initialBalance == this.initialBalance &&
          other.isActive == this.isActive &&
          other.isCreditCard == this.isCreditCard &&
          other.creditLimit == this.creditLimit &&
          other.paymentDueDate == this.paymentDueDate &&
          other.gracePeriodDays == this.gracePeriodDays &&
          other.cardLast4Digits == this.cardLast4Digits &&
          other.accountLast4Digits == this.accountLast4Digits &&
          other.smsSenderName == this.smsSenderName);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<int?> groupId;
  final Value<String> name;
  final Value<String?> icon;
  final Value<String> type;
  final Value<int> currencyId;
  final Value<double> initialBalance;
  final Value<bool> isActive;
  final Value<bool> isCreditCard;
  final Value<double?> creditLimit;
  final Value<String?> paymentDueDate;
  final Value<int?> gracePeriodDays;
  final Value<String?> cardLast4Digits;
  final Value<String?> accountLast4Digits;
  final Value<String?> smsSenderName;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.type = const Value.absent(),
    this.currencyId = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isCreditCard = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentDueDate = const Value.absent(),
    this.gracePeriodDays = const Value.absent(),
    this.cardLast4Digits = const Value.absent(),
    this.accountLast4Digits = const Value.absent(),
    this.smsSenderName = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    this.groupId = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    required String type,
    required int currencyId,
    this.initialBalance = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isCreditCard = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.paymentDueDate = const Value.absent(),
    this.gracePeriodDays = const Value.absent(),
    this.cardLast4Digits = const Value.absent(),
    this.accountLast4Digits = const Value.absent(),
    this.smsSenderName = const Value.absent(),
  })  : name = Value(name),
        type = Value(type),
        currencyId = Value(currencyId);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<int>? groupId,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? type,
    Expression<int>? currencyId,
    Expression<double>? initialBalance,
    Expression<bool>? isActive,
    Expression<bool>? isCreditCard,
    Expression<double>? creditLimit,
    Expression<String>? paymentDueDate,
    Expression<int>? gracePeriodDays,
    Expression<String>? cardLast4Digits,
    Expression<String>? accountLast4Digits,
    Expression<String>? smsSenderName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (type != null) 'type': type,
      if (currencyId != null) 'currency_id': currencyId,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (isActive != null) 'is_active': isActive,
      if (isCreditCard != null) 'is_credit_card': isCreditCard,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (paymentDueDate != null) 'payment_due_date': paymentDueDate,
      if (gracePeriodDays != null) 'grace_period_days': gracePeriodDays,
      if (cardLast4Digits != null) 'card_last4_digits': cardLast4Digits,
      if (accountLast4Digits != null)
        'account_last4_digits': accountLast4Digits,
      if (smsSenderName != null) 'sms_sender_name': smsSenderName,
    });
  }

  AccountsCompanion copyWith(
      {Value<int>? id,
      Value<int?>? groupId,
      Value<String>? name,
      Value<String?>? icon,
      Value<String>? type,
      Value<int>? currencyId,
      Value<double>? initialBalance,
      Value<bool>? isActive,
      Value<bool>? isCreditCard,
      Value<double?>? creditLimit,
      Value<String?>? paymentDueDate,
      Value<int?>? gracePeriodDays,
      Value<String?>? cardLast4Digits,
      Value<String?>? accountLast4Digits,
      Value<String?>? smsSenderName}) {
    return AccountsCompanion(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      type: type ?? this.type,
      currencyId: currencyId ?? this.currencyId,
      initialBalance: initialBalance ?? this.initialBalance,
      isActive: isActive ?? this.isActive,
      isCreditCard: isCreditCard ?? this.isCreditCard,
      creditLimit: creditLimit ?? this.creditLimit,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      gracePeriodDays: gracePeriodDays ?? this.gracePeriodDays,
      cardLast4Digits: cardLast4Digits ?? this.cardLast4Digits,
      accountLast4Digits: accountLast4Digits ?? this.accountLast4Digits,
      smsSenderName: smsSenderName ?? this.smsSenderName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currencyId.present) {
      map['currency_id'] = Variable<int>(currencyId.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<double>(initialBalance.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isCreditCard.present) {
      map['is_credit_card'] = Variable<bool>(isCreditCard.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (paymentDueDate.present) {
      map['payment_due_date'] = Variable<String>(paymentDueDate.value);
    }
    if (gracePeriodDays.present) {
      map['grace_period_days'] = Variable<int>(gracePeriodDays.value);
    }
    if (cardLast4Digits.present) {
      map['card_last4_digits'] = Variable<String>(cardLast4Digits.value);
    }
    if (accountLast4Digits.present) {
      map['account_last4_digits'] = Variable<String>(accountLast4Digits.value);
    }
    if (smsSenderName.present) {
      map['sms_sender_name'] = Variable<String>(smsSenderName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('type: $type, ')
          ..write('currencyId: $currencyId, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('isActive: $isActive, ')
          ..write('isCreditCard: $isCreditCard, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('paymentDueDate: $paymentDueDate, ')
          ..write('gracePeriodDays: $gracePeriodDays, ')
          ..write('cardLast4Digits: $cardLast4Digits, ')
          ..write('accountLast4Digits: $accountLast4Digits, ')
          ..write('smsSenderName: $smsSenderName')
          ..write(')'))
        .toString();
  }
}

class $AccountProjectsTable extends AccountProjects
    with TableInfo<$AccountProjectsTable, AccountProject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
      'account_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<int> projectId = GeneratedColumn<int>(
      'project_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES projects (id)'));
  @override
  List<GeneratedColumn> get $columns => [accountId, projectId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_projects';
  @override
  VerificationContext validateIntegrity(Insertable<AccountProject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId, projectId};
  @override
  AccountProject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountProject(
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}project_id'])!,
    );
  }

  @override
  $AccountProjectsTable createAlias(String alias) {
    return $AccountProjectsTable(attachedDatabase, alias);
  }
}

class AccountProject extends DataClass implements Insertable<AccountProject> {
  final int accountId;
  final int projectId;
  const AccountProject({required this.accountId, required this.projectId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<int>(accountId);
    map['project_id'] = Variable<int>(projectId);
    return map;
  }

  AccountProjectsCompanion toCompanion(bool nullToAbsent) {
    return AccountProjectsCompanion(
      accountId: Value(accountId),
      projectId: Value(projectId),
    );
  }

  factory AccountProject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountProject(
      accountId: serializer.fromJson<int>(json['accountId']),
      projectId: serializer.fromJson<int>(json['projectId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<int>(accountId),
      'projectId': serializer.toJson<int>(projectId),
    };
  }

  AccountProject copyWith({int? accountId, int? projectId}) => AccountProject(
        accountId: accountId ?? this.accountId,
        projectId: projectId ?? this.projectId,
      );
  AccountProject copyWithCompanion(AccountProjectsCompanion data) {
    return AccountProject(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountProject(')
          ..write('accountId: $accountId, ')
          ..write('projectId: $projectId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(accountId, projectId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountProject &&
          other.accountId == this.accountId &&
          other.projectId == this.projectId);
}

class AccountProjectsCompanion extends UpdateCompanion<AccountProject> {
  final Value<int> accountId;
  final Value<int> projectId;
  final Value<int> rowid;
  const AccountProjectsCompanion({
    this.accountId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountProjectsCompanion.insert({
    required int accountId,
    required int projectId,
    this.rowid = const Value.absent(),
  })  : accountId = Value(accountId),
        projectId = Value(projectId);
  static Insertable<AccountProject> custom({
    Expression<int>? accountId,
    Expression<int>? projectId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (projectId != null) 'project_id': projectId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountProjectsCompanion copyWith(
      {Value<int>? accountId, Value<int>? projectId, Value<int>? rowid}) {
    return AccountProjectsCompanion(
      accountId: accountId ?? this.accountId,
      projectId: projectId ?? this.projectId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<int>(projectId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountProjectsCompanion(')
          ..write('accountId: $accountId, ')
          ..write('projectId: $projectId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CurrenciesTable currencies = $CurrenciesTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $AccountGroupsTable accountGroups = $AccountGroupsTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $AccountProjectsTable accountProjects =
      $AccountProjectsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [currencies, projects, accountGroups, accounts, accountProjects];
}

typedef $$CurrenciesTableCreateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  required String code,
  required String name,
  Value<String?> symbol,
  Value<bool> isActive,
  required int numCode,
  Value<int> nominal,
  Value<String?> country,
});
typedef $$CurrenciesTableUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<int> id,
  Value<String> code,
  Value<String> name,
  Value<String?> symbol,
  Value<bool> isActive,
  Value<int> numCode,
  Value<int> nominal,
  Value<String?> country,
});

final class $$CurrenciesTableReferences
    extends BaseReferences<_$AppDatabase, $CurrenciesTable, Currency> {
  $$CurrenciesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.accounts,
          aliasName: 'currencies__id__accounts__currency_id');

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.currencyId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CurrenciesTableFilterComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get numCode => $composableBuilder(
      column: $table.numCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get nominal => $composableBuilder(
      column: $table.nominal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnFilters(column));

  Expression<bool> accountsRefs(
      Expression<bool> Function($$AccountsTableFilterComposer f) f) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CurrenciesTableOrderingComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get numCode => $composableBuilder(
      column: $table.numCode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get nominal => $composableBuilder(
      column: $table.nominal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get country => $composableBuilder(
      column: $table.country, builder: (column) => ColumnOrderings(column));
}

class $$CurrenciesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CurrenciesTable> {
  $$CurrenciesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get numCode =>
      $composableBuilder(column: $table.numCode, builder: (column) => column);

  GeneratedColumn<int> get nominal =>
      $composableBuilder(column: $table.nominal, builder: (column) => column);

  GeneratedColumn<String> get country =>
      $composableBuilder(column: $table.country, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
      Expression<T> Function($$AccountsTableAnnotationComposer a) f) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.currencyId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CurrenciesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, $$CurrenciesTableReferences),
    Currency,
    PrefetchHooks Function({bool accountsRefs})> {
  $$CurrenciesTableTableManager(_$AppDatabase db, $CurrenciesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CurrenciesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CurrenciesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CurrenciesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> symbol = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> numCode = const Value.absent(),
            Value<int> nominal = const Value.absent(),
            Value<String?> country = const Value.absent(),
          }) =>
              CurrenciesCompanion(
            id: id,
            code: code,
            name: name,
            symbol: symbol,
            isActive: isActive,
            numCode: numCode,
            nominal: nominal,
            country: country,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String code,
            required String name,
            Value<String?> symbol = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            required int numCode,
            Value<int> nominal = const Value.absent(),
            Value<String?> country = const Value.absent(),
          }) =>
              CurrenciesCompanion.insert(
            id: id,
            code: code,
            name: name,
            symbol: symbol,
            isActive: isActive,
            numCode: numCode,
            nominal: nominal,
            country: country,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$CurrenciesTable, Currency>(table),
                    $$CurrenciesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({accountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (accountsRefs) db.accounts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountsRefs)
                    await $_getPrefetchedData<Currency, $CurrenciesTable,
                            Account>(
                        currentTable: table,
                        referencedTable:
                            $$CurrenciesTableReferences._accountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CurrenciesTableReferences(db, table, p0)
                                .accountsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.currencyId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CurrenciesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CurrenciesTable,
    Currency,
    $$CurrenciesTableFilterComposer,
    $$CurrenciesTableOrderingComposer,
    $$CurrenciesTableAnnotationComposer,
    $$CurrenciesTableCreateCompanionBuilder,
    $$CurrenciesTableUpdateCompanionBuilder,
    (Currency, $$CurrenciesTableReferences),
    Currency,
    PrefetchHooks Function({bool accountsRefs})>;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  required String name,
  Value<bool> isActive,
  Value<String?> icon,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<bool> isActive,
  Value<String?> icon,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AccountProjectsTable, List<AccountProject>>
      _accountProjectsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.accountProjects,
              aliasName: 'projects__id__account_projects__project_id');

  $$AccountProjectsTableProcessedTableManager get accountProjectsRefs {
    final manager =
        $$AccountProjectsTableTableManager($_db, $_db.accountProjects)
            .filter((f) => f.projectId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_accountProjectsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

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
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  Expression<bool> accountProjectsRefs(
      Expression<bool> Function($$AccountProjectsTableFilterComposer f) f) {
    final $$AccountProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accountProjects,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountProjectsTableFilterComposer(
              $db: $db,
              $table: $db.accountProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  Expression<T> accountProjectsRefs<T extends Object>(
      Expression<T> Function($$AccountProjectsTableAnnotationComposer a) f) {
    final $$AccountProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accountProjects,
        getReferencedColumn: (t) => t.projectId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.accountProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool accountProjectsRefs})> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<String?> icon = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            isActive: isActive,
            icon: icon,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<bool> isActive = const Value.absent(),
            Value<String?> icon = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            isActive: isActive,
            icon: icon,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$ProjectsTable, Project>(table),
                    $$ProjectsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({accountProjectsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountProjectsRefs) db.accountProjects
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountProjectsRefs)
                    await $_getPrefetchedData<Project, $ProjectsTable,
                            AccountProject>(
                        currentTable: table,
                        referencedTable: $$ProjectsTableReferences
                            ._accountProjectsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProjectsTableReferences(db, table, p0)
                                .accountProjectsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.projectId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, $$ProjectsTableReferences),
    Project,
    PrefetchHooks Function({bool accountProjectsRefs})>;
typedef $$AccountGroupsTableCreateCompanionBuilder = AccountGroupsCompanion
    Function({
  Value<int> id,
  required String name,
  Value<String?> icon,
  Value<int?> parentId,
  Value<bool> isActive,
});
typedef $$AccountGroupsTableUpdateCompanionBuilder = AccountGroupsCompanion
    Function({
  Value<int> id,
  Value<String> name,
  Value<String?> icon,
  Value<int?> parentId,
  Value<bool> isActive,
});

final class $$AccountGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountGroupsTable, AccountGroup> {
  $$AccountGroupsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AccountGroupsTable _parentIdTable(_$AppDatabase db) =>
      db.accountGroups
          .createAlias('account_groups__parent_id__account_groups__id');

  $$AccountGroupsTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$AccountGroupsTableTableManager($_db, $_db.accountGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.accounts,
          aliasName: 'account_groups__id__accounts__group_id');

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountGroupsTable> {
  $$AccountGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$AccountGroupsTableFilterComposer get parentId {
    final $$AccountGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.accountGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountGroupsTableFilterComposer(
              $db: $db,
              $table: $db.accountGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> accountsRefs(
      Expression<bool> Function($$AccountsTableFilterComposer f) f) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountGroupsTable> {
  $$AccountGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$AccountGroupsTableOrderingComposer get parentId {
    final $$AccountGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.accountGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.accountGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountGroupsTable> {
  $$AccountGroupsTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$AccountGroupsTableAnnotationComposer get parentId {
    final $$AccountGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.accountGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.accountGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> accountsRefs<T extends Object>(
      Expression<T> Function($$AccountsTableAnnotationComposer a) f) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.groupId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountGroupsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountGroupsTable,
    AccountGroup,
    $$AccountGroupsTableFilterComposer,
    $$AccountGroupsTableOrderingComposer,
    $$AccountGroupsTableAnnotationComposer,
    $$AccountGroupsTableCreateCompanionBuilder,
    $$AccountGroupsTableUpdateCompanionBuilder,
    (AccountGroup, $$AccountGroupsTableReferences),
    AccountGroup,
    PrefetchHooks Function({bool parentId, bool accountsRefs})> {
  $$AccountGroupsTableTableManager(_$AppDatabase db, $AccountGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AccountGroupsCompanion(
            id: id,
            name: name,
            icon: icon,
            parentId: parentId,
            isActive: isActive,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            Value<String?> icon = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
          }) =>
              AccountGroupsCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            parentId: parentId,
            isActive: isActive,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AccountGroupsTable, AccountGroup>(table),
                    $$AccountGroupsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({parentId = false, accountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (accountsRefs) db.accounts],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$AccountGroupsTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$AccountGroupsTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountsRefs)
                    await $_getPrefetchedData<AccountGroup, $AccountGroupsTable,
                            Account>(
                        currentTable: table,
                        referencedTable: $$AccountGroupsTableReferences
                            ._accountsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountGroupsTableReferences(db, table, p0)
                                .accountsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.groupId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountGroupsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountGroupsTable,
    AccountGroup,
    $$AccountGroupsTableFilterComposer,
    $$AccountGroupsTableOrderingComposer,
    $$AccountGroupsTableAnnotationComposer,
    $$AccountGroupsTableCreateCompanionBuilder,
    $$AccountGroupsTableUpdateCompanionBuilder,
    (AccountGroup, $$AccountGroupsTableReferences),
    AccountGroup,
    PrefetchHooks Function({bool parentId, bool accountsRefs})>;
typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<int?> groupId,
  required String name,
  Value<String?> icon,
  required String type,
  required int currencyId,
  Value<double> initialBalance,
  Value<bool> isActive,
  Value<bool> isCreditCard,
  Value<double?> creditLimit,
  Value<String?> paymentDueDate,
  Value<int?> gracePeriodDays,
  Value<String?> cardLast4Digits,
  Value<String?> accountLast4Digits,
  Value<String?> smsSenderName,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<int> id,
  Value<int?> groupId,
  Value<String> name,
  Value<String?> icon,
  Value<String> type,
  Value<int> currencyId,
  Value<double> initialBalance,
  Value<bool> isActive,
  Value<bool> isCreditCard,
  Value<double?> creditLimit,
  Value<String?> paymentDueDate,
  Value<int?> gracePeriodDays,
  Value<String?> cardLast4Digits,
  Value<String?> accountLast4Digits,
  Value<String?> smsSenderName,
});

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.accountGroups.createAlias('accounts__group_id__account_groups__id');

  $$AccountGroupsTableProcessedTableManager? get groupId {
    final $_column = $_itemColumn<int>('group_id');
    if ($_column == null) return null;
    final manager = $$AccountGroupsTableTableManager($_db, $_db.accountGroups)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CurrenciesTable _currencyIdTable(_$AppDatabase db) =>
      db.currencies.createAlias('accounts__currency_id__currencies__id');

  $$CurrenciesTableProcessedTableManager get currencyId {
    final $_column = $_itemColumn<int>('currency_id')!;

    final manager = $$CurrenciesTableTableManager($_db, $_db.currencies)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$AccountProjectsTable, List<AccountProject>>
      _accountProjectsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.accountProjects,
              aliasName: 'accounts__id__account_projects__account_id');

  $$AccountProjectsTableProcessedTableManager get accountProjectsRefs {
    final manager =
        $$AccountProjectsTableTableManager($_db, $_db.accountProjects)
            .filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_accountProjectsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCreditCard => $composableBuilder(
      column: $table.isCreditCard, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentDueDate => $composableBuilder(
      column: $table.paymentDueDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get gracePeriodDays => $composableBuilder(
      column: $table.gracePeriodDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cardLast4Digits => $composableBuilder(
      column: $table.cardLast4Digits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get accountLast4Digits => $composableBuilder(
      column: $table.accountLast4Digits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get smsSenderName => $composableBuilder(
      column: $table.smsSenderName, builder: (column) => ColumnFilters(column));

  $$AccountGroupsTableFilterComposer get groupId {
    final $$AccountGroupsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.accountGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountGroupsTableFilterComposer(
              $db: $db,
              $table: $db.accountGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableFilterComposer get currencyId {
    final $$CurrenciesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableFilterComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> accountProjectsRefs(
      Expression<bool> Function($$AccountProjectsTableFilterComposer f) f) {
    final $$AccountProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accountProjects,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountProjectsTableFilterComposer(
              $db: $db,
              $table: $db.accountProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCreditCard => $composableBuilder(
      column: $table.isCreditCard,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentDueDate => $composableBuilder(
      column: $table.paymentDueDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get gracePeriodDays => $composableBuilder(
      column: $table.gracePeriodDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cardLast4Digits => $composableBuilder(
      column: $table.cardLast4Digits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get accountLast4Digits => $composableBuilder(
      column: $table.accountLast4Digits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get smsSenderName => $composableBuilder(
      column: $table.smsSenderName,
      builder: (column) => ColumnOrderings(column));

  $$AccountGroupsTableOrderingComposer get groupId {
    final $$AccountGroupsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.accountGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountGroupsTableOrderingComposer(
              $db: $db,
              $table: $db.accountGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableOrderingComposer get currencyId {
    final $$CurrenciesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableOrderingComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isCreditCard => $composableBuilder(
      column: $table.isCreditCard, builder: (column) => column);

  GeneratedColumn<double> get creditLimit => $composableBuilder(
      column: $table.creditLimit, builder: (column) => column);

  GeneratedColumn<String> get paymentDueDate => $composableBuilder(
      column: $table.paymentDueDate, builder: (column) => column);

  GeneratedColumn<int> get gracePeriodDays => $composableBuilder(
      column: $table.gracePeriodDays, builder: (column) => column);

  GeneratedColumn<String> get cardLast4Digits => $composableBuilder(
      column: $table.cardLast4Digits, builder: (column) => column);

  GeneratedColumn<String> get accountLast4Digits => $composableBuilder(
      column: $table.accountLast4Digits, builder: (column) => column);

  GeneratedColumn<String> get smsSenderName => $composableBuilder(
      column: $table.smsSenderName, builder: (column) => column);

  $$AccountGroupsTableAnnotationComposer get groupId {
    final $$AccountGroupsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.groupId,
        referencedTable: $db.accountGroups,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountGroupsTableAnnotationComposer(
              $db: $db,
              $table: $db.accountGroups,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CurrenciesTableAnnotationComposer get currencyId {
    final $$CurrenciesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.currencyId,
        referencedTable: $db.currencies,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CurrenciesTableAnnotationComposer(
              $db: $db,
              $table: $db.currencies,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> accountProjectsRefs<T extends Object>(
      Expression<T> Function($$AccountProjectsTableAnnotationComposer a) f) {
    final $$AccountProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.accountProjects,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.accountProjects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool groupId, bool currencyId, bool accountProjectsRefs})> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<int> currencyId = const Value.absent(),
            Value<double> initialBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isCreditCard = const Value.absent(),
            Value<double?> creditLimit = const Value.absent(),
            Value<String?> paymentDueDate = const Value.absent(),
            Value<int?> gracePeriodDays = const Value.absent(),
            Value<String?> cardLast4Digits = const Value.absent(),
            Value<String?> accountLast4Digits = const Value.absent(),
            Value<String?> smsSenderName = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            groupId: groupId,
            name: name,
            icon: icon,
            type: type,
            currencyId: currencyId,
            initialBalance: initialBalance,
            isActive: isActive,
            isCreditCard: isCreditCard,
            creditLimit: creditLimit,
            paymentDueDate: paymentDueDate,
            gracePeriodDays: gracePeriodDays,
            cardLast4Digits: cardLast4Digits,
            accountLast4Digits: accountLast4Digits,
            smsSenderName: smsSenderName,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> groupId = const Value.absent(),
            required String name,
            Value<String?> icon = const Value.absent(),
            required String type,
            required int currencyId,
            Value<double> initialBalance = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isCreditCard = const Value.absent(),
            Value<double?> creditLimit = const Value.absent(),
            Value<String?> paymentDueDate = const Value.absent(),
            Value<int?> gracePeriodDays = const Value.absent(),
            Value<String?> cardLast4Digits = const Value.absent(),
            Value<String?> accountLast4Digits = const Value.absent(),
            Value<String?> smsSenderName = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            groupId: groupId,
            name: name,
            icon: icon,
            type: type,
            currencyId: currencyId,
            initialBalance: initialBalance,
            isActive: isActive,
            isCreditCard: isCreditCard,
            creditLimit: creditLimit,
            paymentDueDate: paymentDueDate,
            gracePeriodDays: gracePeriodDays,
            cardLast4Digits: cardLast4Digits,
            accountLast4Digits: accountLast4Digits,
            smsSenderName: smsSenderName,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AccountsTable, Account>(table),
                    $$AccountsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {groupId = false,
              currencyId = false,
              accountProjectsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (accountProjectsRefs) db.accountProjects
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (groupId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.groupId,
                    referencedTable:
                        $$AccountsTableReferences._groupIdTable(db),
                    referencedColumn:
                        $$AccountsTableReferences._groupIdTable(db).id,
                  ) as T;
                }
                if (currencyId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.currencyId,
                    referencedTable:
                        $$AccountsTableReferences._currencyIdTable(db),
                    referencedColumn:
                        $$AccountsTableReferences._currencyIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountProjectsRefs)
                    await $_getPrefetchedData<Account, $AccountsTable,
                            AccountProject>(
                        currentTable: table,
                        referencedTable: $$AccountsTableReferences
                            ._accountProjectsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$AccountsTableReferences(db, table, p0)
                                .accountProjectsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$AccountsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableAnnotationComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder,
    (Account, $$AccountsTableReferences),
    Account,
    PrefetchHooks Function(
        {bool groupId, bool currencyId, bool accountProjectsRefs})>;
typedef $$AccountProjectsTableCreateCompanionBuilder = AccountProjectsCompanion
    Function({
  required int accountId,
  required int projectId,
  Value<int> rowid,
});
typedef $$AccountProjectsTableUpdateCompanionBuilder = AccountProjectsCompanion
    Function({
  Value<int> accountId,
  Value<int> projectId,
  Value<int> rowid,
});

final class $$AccountProjectsTableReferences extends BaseReferences<
    _$AppDatabase, $AccountProjectsTable, AccountProject> {
  $$AccountProjectsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('account_projects__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager($_db, $_db.accounts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias('account_projects__project_id__projects__id');

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<int>('project_id')!;

    final manager = $$ProjectsTableTableManager($_db, $_db.projects)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AccountProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountProjectsTable> {
  $$AccountProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableFilterComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableFilterComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountProjectsTable> {
  $$AccountProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableOrderingComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableOrderingComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountProjectsTable> {
  $$AccountProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.accounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.projectId,
        referencedTable: $db.projects,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProjectsTableAnnotationComposer(
              $db: $db,
              $table: $db.projects,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AccountProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountProjectsTable,
    AccountProject,
    $$AccountProjectsTableFilterComposer,
    $$AccountProjectsTableOrderingComposer,
    $$AccountProjectsTableAnnotationComposer,
    $$AccountProjectsTableCreateCompanionBuilder,
    $$AccountProjectsTableUpdateCompanionBuilder,
    (AccountProject, $$AccountProjectsTableReferences),
    AccountProject,
    PrefetchHooks Function({bool accountId, bool projectId})> {
  $$AccountProjectsTableTableManager(
      _$AppDatabase db, $AccountProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> accountId = const Value.absent(),
            Value<int> projectId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountProjectsCompanion(
            accountId: accountId,
            projectId: projectId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required int accountId,
            required int projectId,
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountProjectsCompanion.insert(
            accountId: accountId,
            projectId: projectId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable<$AccountProjectsTable, AccountProject>(table),
                    $$AccountProjectsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({accountId = false, projectId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable:
                        $$AccountProjectsTableReferences._accountIdTable(db),
                    referencedColumn:
                        $$AccountProjectsTableReferences._accountIdTable(db).id,
                  ) as T;
                }
                if (projectId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.projectId,
                    referencedTable:
                        $$AccountProjectsTableReferences._projectIdTable(db),
                    referencedColumn:
                        $$AccountProjectsTableReferences._projectIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AccountProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AccountProjectsTable,
    AccountProject,
    $$AccountProjectsTableFilterComposer,
    $$AccountProjectsTableOrderingComposer,
    $$AccountProjectsTableAnnotationComposer,
    $$AccountProjectsTableCreateCompanionBuilder,
    $$AccountProjectsTableUpdateCompanionBuilder,
    (AccountProject, $$AccountProjectsTableReferences),
    AccountProject,
    PrefetchHooks Function({bool accountId, bool projectId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CurrenciesTableTableManager get currencies =>
      $$CurrenciesTableTableManager(_db, _db.currencies);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$AccountGroupsTableTableManager get accountGroups =>
      $$AccountGroupsTableTableManager(_db, _db.accountGroups);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$AccountProjectsTableTableManager get accountProjects =>
      $$AccountProjectsTableTableManager(_db, _db.accountProjects);
}
