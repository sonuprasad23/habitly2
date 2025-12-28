
part of 'database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _colorMeta = VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF6750A4));
  static const VerificationMeta _isDefaultMeta = VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
      'is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_default" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta = VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, icon, color, isDefault, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
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
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final String icon;
  final int color;
  final bool isDefault;
  final int sortOrder;
  const Category(
      {required this.id,
      required this.name,
      required this.icon,
      required this.color,
      required this.isDefault,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    map['is_default'] = Variable<bool>(isDefault);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      isDefault: Value(isDefault),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'isDefault': serializer.toJson<bool>(isDefault),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith(
          {int? id,
          String? name,
          String? icon,
          int? color,
          bool? isDefault,
          int? sortOrder}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        isDefault: isDefault ?? this.isDefault,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, color, isDefault, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.isDefault == this.isDefault &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<int> color;
  final Value<bool> isDefault;
  final Value<int> sortOrder;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    this.color = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.sortOrder = const Value.absent(),
  })  : name = Value(name),
        icon = Value(icon);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<bool>? isDefault,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (isDefault != null) 'is_default': isDefault,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  CategoriesCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? icon,
      Value<int>? color,
      Value<bool>? isDefault,
      Value<int>? sortOrder}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isDefault: isDefault ?? this.isDefault,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('isDefault: $isDefault, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, Habit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 200),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta = VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _iconMeta = VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('check_circle'));
  static const VerificationMeta _colorMeta = VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0xFF6750A4));
  static const VerificationMeta _categoryIdMeta = VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
      'category_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _frequencyTypeMeta = VerificationMeta('frequencyType');
  @override
  late final GeneratedColumnWithTypeConverter<FrequencyType, int> frequencyType =
      GeneratedColumn<int>('frequency_type', aliasedName, false,
              type: DriftSqlType.int,
              requiredDuringInsert: false,
              defaultValue: const Constant(0))
          .withConverter<FrequencyType>($HabitsTable.$converterfrequencyType);
  static const VerificationMeta _frequencyDaysMeta = VerificationMeta('frequencyDays');
  @override
  late final GeneratedColumn<String> frequencyDays = GeneratedColumn<String>(
      'frequency_days', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _targetCountMeta = VerificationMeta('targetCount');
  @override
  late final GeneratedColumn<int> targetCount = GeneratedColumn<int>(
      'target_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _reminderEnabledMeta = VerificationMeta('reminderEnabled');
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
      'reminder_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("reminder_enabled" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _reminderTimeMeta = VerificationMeta('reminderTime');
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
      'reminder_time', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta = VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _archivedAtMeta = VerificationMeta('archivedAt');
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
      'archived_at', aliasedName, true,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta = VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id, name, description, icon, color, categoryId, frequencyType,
        frequencyDays, targetCount, reminderEnabled, reminderTime,
        createdAt, archivedAt, sortOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(Insertable<Habit> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(_descriptionMeta,
          description.isAcceptableOrUnknown(data['description']!, _descriptionMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(_iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(_colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(_categoryIdMeta,
          categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta));
    }
    context.handle(_frequencyTypeMeta, const VerificationResult.success());
    if (data.containsKey('frequency_days')) {
      context.handle(_frequencyDaysMeta,
          frequencyDays.isAcceptableOrUnknown(data['frequency_days']!, _frequencyDaysMeta));
    }
    if (data.containsKey('target_count')) {
      context.handle(_targetCountMeta,
          targetCount.isAcceptableOrUnknown(data['target_count']!, _targetCountMeta));
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(_reminderEnabledMeta,
          reminderEnabled.isAcceptableOrUnknown(data['reminder_enabled']!, _reminderEnabledMeta));
    }
    if (data.containsKey('reminder_time')) {
      context.handle(_reminderTimeMeta,
          reminderTime.isAcceptableOrUnknown(data['reminder_time']!, _reminderTimeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('archived_at')) {
      context.handle(_archivedAtMeta,
          archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Habit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Habit(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      icon: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      color: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}color'])!,
      categoryId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}category_id']),
      frequencyType: $HabitsTable.$converterfrequencyType.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}frequency_type'])!),
      frequencyDays: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}frequency_days']),
      targetCount: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}target_count'])!,
      reminderEnabled: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}reminder_enabled'])!,
      reminderTime: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}reminder_time']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      archivedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}archived_at']),
      sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FrequencyType, int, int> $converterfrequencyType =
      const EnumIndexConverter<FrequencyType>(FrequencyType.values);
}

class Habit extends DataClass implements Insertable<Habit> {
  final int id;
  final String name;
  final String? description;
  final String icon;
  final int color;
  final int? categoryId;
  final FrequencyType frequencyType;
  final String? frequencyDays;
  final int targetCount;
  final bool reminderEnabled;
  final String? reminderTime;
  final DateTime createdAt;
  final DateTime? archivedAt;
  final int sortOrder;
  const Habit({
    required this.id,
    required this.name,
    this.description,
    required this.icon,
    required this.color,
    this.categoryId,
    required this.frequencyType,
    this.frequencyDays,
    required this.targetCount,
    required this.reminderEnabled,
    this.reminderTime,
    required this.createdAt,
    this.archivedAt,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<int>(color);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<int>(categoryId);
    }
    {
      map['frequency_type'] = Variable<int>($HabitsTable.$converterfrequencyType.toSql(frequencyType));
    }
    if (!nullToAbsent || frequencyDays != null) {
      map['frequency_days'] = Variable<String>(frequencyDays);
    }
    map['target_count'] = Variable<int>(targetCount);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent ? const Value.absent() : Value(description),
      icon: Value(icon),
      color: Value(color),
      categoryId: categoryId == null && nullToAbsent ? const Value.absent() : Value(categoryId),
      frequencyType: Value(frequencyType),
      frequencyDays: frequencyDays == null && nullToAbsent ? const Value.absent() : Value(frequencyDays),
      targetCount: Value(targetCount),
      reminderEnabled: Value(reminderEnabled),
      reminderTime: reminderTime == null && nullToAbsent ? const Value.absent() : Value(reminderTime),
      createdAt: Value(createdAt),
      archivedAt: archivedAt == null && nullToAbsent ? const Value.absent() : Value(archivedAt),
      sortOrder: Value(sortOrder),
    );
  }

  factory Habit.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Habit(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<int>(json['color']),
      categoryId: serializer.fromJson<int?>(json['categoryId']),
      frequencyType: $HabitsTable.$converterfrequencyType.fromJson(serializer.fromJson<int>(json['frequencyType'])),
      frequencyDays: serializer.fromJson<String?>(json['frequencyDays']),
      targetCount: serializer.fromJson<int>(json['targetCount']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<int>(color),
      'categoryId': serializer.toJson<int?>(categoryId),
      'frequencyType': serializer.toJson<int>($HabitsTable.$converterfrequencyType.toJson(frequencyType)),
      'frequencyDays': serializer.toJson<String?>(frequencyDays),
      'targetCount': serializer.toJson<int>(targetCount),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Habit copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    String? icon,
    int? color,
    Value<int?> categoryId = const Value.absent(),
    FrequencyType? frequencyType,
    Value<String?> frequencyDays = const Value.absent(),
    int? targetCount,
    bool? reminderEnabled,
    Value<String?> reminderTime = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> archivedAt = const Value.absent(),
    int? sortOrder,
  }) =>
      Habit(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        icon: icon ?? this.icon,
        color: color ?? this.color,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        frequencyType: frequencyType ?? this.frequencyType,
        frequencyDays: frequencyDays.present ? frequencyDays.value : this.frequencyDays,
        targetCount: targetCount ?? this.targetCount,
        reminderEnabled: reminderEnabled ?? this.reminderEnabled,
        reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
        createdAt: createdAt ?? this.createdAt,
        archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  @override
  String toString() {
    return (StringBuffer('Habit(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('categoryId: $categoryId, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('targetCount: $targetCount, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, icon, color, categoryId,
      frequencyType, frequencyDays, targetCount, reminderEnabled, reminderTime,
      createdAt, archivedAt, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Habit &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.categoryId == this.categoryId &&
          other.frequencyType == this.frequencyType &&
          other.frequencyDays == this.frequencyDays &&
          other.targetCount == this.targetCount &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderTime == this.reminderTime &&
          other.createdAt == this.createdAt &&
          other.archivedAt == this.archivedAt &&
          other.sortOrder == this.sortOrder);
}

class HabitsCompanion extends UpdateCompanion<Habit> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> icon;
  final Value<int> color;
  final Value<int?> categoryId;
  final Value<FrequencyType> frequencyType;
  final Value<String?> frequencyDays;
  final Value<int> targetCount;
  final Value<bool> reminderEnabled;
  final Value<String?> reminderTime;
  final Value<DateTime> createdAt;
  final Value<DateTime?> archivedAt;
  final Value<int> sortOrder;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.frequencyDays = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  HabitsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.frequencyType = const Value.absent(),
    this.frequencyDays = const Value.absent(),
    this.targetCount = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Habit> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? categoryId,
    Expression<int>? frequencyType,
    Expression<String>? frequencyDays,
    Expression<int>? targetCount,
    Expression<bool>? reminderEnabled,
    Expression<String>? reminderTime,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? archivedAt,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (categoryId != null) 'category_id': categoryId,
      if (frequencyType != null) 'frequency_type': frequencyType,
      if (frequencyDays != null) 'frequency_days': frequencyDays,
      if (targetCount != null) 'target_count': targetCount,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (createdAt != null) 'created_at': createdAt,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  HabitsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? icon,
    Value<int>? color,
    Value<int?>? categoryId,
    Value<FrequencyType>? frequencyType,
    Value<String?>? frequencyDays,
    Value<int>? targetCount,
    Value<bool>? reminderEnabled,
    Value<String?>? reminderTime,
    Value<DateTime>? createdAt,
    Value<DateTime?>? archivedAt,
    Value<int>? sortOrder,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      categoryId: categoryId ?? this.categoryId,
      frequencyType: frequencyType ?? this.frequencyType,
      frequencyDays: frequencyDays ?? this.frequencyDays,
      targetCount: targetCount ?? this.targetCount,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      archivedAt: archivedAt ?? this.archivedAt,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (frequencyType.present) {
      map['frequency_type'] = Variable<int>($HabitsTable.$converterfrequencyType.toSql(frequencyType.value));
    }
    if (frequencyDays.present) {
      map['frequency_days'] = Variable<String>(frequencyDays.value);
    }
    if (targetCount.present) {
      map['target_count'] = Variable<int>(targetCount.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('categoryId: $categoryId, ')
          ..write('frequencyType: $frequencyType, ')
          ..write('frequencyDays: $frequencyDays, ')
          ..write('targetCount: $targetCount, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('createdAt: $createdAt, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

// ========== HabitCompletions Table ==========

class $HabitCompletionsTable extends HabitCompletions
    with TableInfo<$HabitCompletionsTable, HabitCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitCompletionsTable(this.attachedDatabase, [this._alias]);
  
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>(
      'habit_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES habits (id)'));
  @override
  late final GeneratedColumn<String> completedDate = GeneratedColumn<String>(
      'completed_date', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> completionCount = GeneratedColumn<int>(
      'completion_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(1));
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<bool> skipped = GeneratedColumn<bool>(
      'skipped', aliasedName, false,
      type: DriftSqlType.bool, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("skipped" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [id, habitId, completedDate, completionCount, completedAt, notes, skipped];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => 'habit_completions';
  @override
  VerificationContext validateIntegrity(Insertable<HabitCompletion> instance, {bool isInserting = false}) {
    return VerificationContext();
  }
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [{habitId, completedDate}];
  @override
  HabitCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitCompletion(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      habitId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}habit_id'])!,
      completedDate: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}completed_date'])!,
      completionCount: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}completion_count'])!,
      completedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at'])!,
      notes: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}notes']),
      skipped: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}skipped'])!,
    );
  }
  @override
  $HabitCompletionsTable createAlias(String alias) => $HabitCompletionsTable(attachedDatabase, alias);
}

class HabitCompletion extends DataClass implements Insertable<HabitCompletion> {
  final int id;
  final int habitId;
  final String completedDate;
  final int completionCount;
  final DateTime completedAt;
  final String? notes;
  final bool skipped;
  const HabitCompletion({required this.id, required this.habitId, required this.completedDate,
      required this.completionCount, required this.completedAt, this.notes, required this.skipped});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['habit_id'] = Variable<int>(habitId);
    map['completed_date'] = Variable<String>(completedDate);
    map['completion_count'] = Variable<int>(completionCount);
    map['completed_at'] = Variable<DateTime>(completedAt);
    if (!nullToAbsent || notes != null) map['notes'] = Variable<String>(notes);
    map['skipped'] = Variable<bool>(skipped);
    return map;
  }
  HabitCompletionsCompanion toCompanion(bool nullToAbsent) {
    return HabitCompletionsCompanion(id: Value(id), habitId: Value(habitId), completedDate: Value(completedDate),
      completionCount: Value(completionCount), completedAt: Value(completedAt),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes), skipped: Value(skipped));
  }
  factory HabitCompletion.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitCompletion(id: serializer.fromJson<int>(json['id']), habitId: serializer.fromJson<int>(json['habitId']),
      completedDate: serializer.fromJson<String>(json['completedDate']),
      completionCount: serializer.fromJson<int>(json['completionCount']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
      notes: serializer.fromJson<String?>(json['notes']), skipped: serializer.fromJson<bool>(json['skipped']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {'id': serializer.toJson<int>(id), 'habitId': serializer.toJson<int>(habitId),
      'completedDate': serializer.toJson<String>(completedDate), 'completionCount': serializer.toJson<int>(completionCount),
      'completedAt': serializer.toJson<DateTime>(completedAt), 'notes': serializer.toJson<String?>(notes),
      'skipped': serializer.toJson<bool>(skipped)};
  }
  HabitCompletion copyWith({int? id, int? habitId, String? completedDate, int? completionCount,
      DateTime? completedAt, Value<String?> notes = const Value.absent(), bool? skipped}) =>
      HabitCompletion(id: id ?? this.id, habitId: habitId ?? this.habitId,
        completedDate: completedDate ?? this.completedDate, completionCount: completionCount ?? this.completionCount,
        completedAt: completedAt ?? this.completedAt, notes: notes.present ? notes.value : this.notes,
        skipped: skipped ?? this.skipped);
  @override
  String toString() => 'HabitCompletion(id: $id, habitId: $habitId, completedDate: $completedDate)';
  @override
  int get hashCode => Object.hash(id, habitId, completedDate, completionCount, completedAt, notes, skipped);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is HabitCompletion && other.id == id);
}

class HabitCompletionsCompanion extends UpdateCompanion<HabitCompletion> {
  final Value<int> id;
  final Value<int> habitId;
  final Value<String> completedDate;
  final Value<int> completionCount;
  final Value<DateTime> completedAt;
  final Value<String?> notes;
  final Value<bool> skipped;
  const HabitCompletionsCompanion({this.id = const Value.absent(), this.habitId = const Value.absent(),
    this.completedDate = const Value.absent(), this.completionCount = const Value.absent(),
    this.completedAt = const Value.absent(), this.notes = const Value.absent(), this.skipped = const Value.absent()});
  HabitCompletionsCompanion.insert({this.id = const Value.absent(), required int habitId, required String completedDate,
    this.completionCount = const Value.absent(), this.completedAt = const Value.absent(),
    this.notes = const Value.absent(), this.skipped = const Value.absent()})
      : habitId = Value(habitId), completedDate = Value(completedDate);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (habitId.present) map['habit_id'] = Variable<int>(habitId.value);
    if (completedDate.present) map['completed_date'] = Variable<String>(completedDate.value);
    if (completionCount.present) map['completion_count'] = Variable<int>(completionCount.value);
    if (completedAt.present) map['completed_at'] = Variable<DateTime>(completedAt.value);
    if (notes.present) map['notes'] = Variable<String>(notes.value);
    if (skipped.present) map['skipped'] = Variable<bool>(skipped.value);
    return map;
  }
  @override
  String toString() => 'HabitCompletionsCompanion(id: $id, habitId: $habitId, completedDate: $completedDate)';
}

// ========== TimerSessions Table ==========

class $TimerSessionsTable extends TimerSessions with TableInfo<$TimerSessionsTable, TimerSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimerSessionsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<TimerType, int> timerType =
      GeneratedColumn<int>('timer_type', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<TimerType>($TimerSessionsTable.$convertertimerType);
  @override
  late final GeneratedColumn<int> linkedHabitId = GeneratedColumn<int>('linked_habit_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('REFERENCES habits (id)'));
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>('duration_seconds', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>('started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>('ended_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<bool> completed = GeneratedColumn<bool>('completed', aliasedName, false,
      type: DriftSqlType.bool, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>('notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, timerType, linkedHabitId, durationSeconds, startedAt, endedAt, completed, notes];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => 'timer_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<TimerSession> instance, {bool isInserting = false}) => VerificationContext();
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimerSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimerSession(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      timerType: $TimerSessionsTable.$convertertimerType.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}timer_type'])!),
      linkedHabitId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}linked_habit_id']),
      durationSeconds: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}duration_seconds'])!,
      startedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      endedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}ended_at']),
      completed: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}completed'])!,
      notes: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }
  @override
  $TimerSessionsTable createAlias(String alias) => $TimerSessionsTable(attachedDatabase, alias);
  static JsonTypeConverter2<TimerType, int, int> $convertertimerType = const EnumIndexConverter<TimerType>(TimerType.values);
}

class TimerSession extends DataClass implements Insertable<TimerSession> {
  final int id;
  final TimerType timerType;
  final int? linkedHabitId;
  final int durationSeconds;
  final DateTime startedAt;
  final DateTime? endedAt;
  final bool completed;
  final String? notes;
  const TimerSession({required this.id, required this.timerType, this.linkedHabitId, required this.durationSeconds,
      required this.startedAt, this.endedAt, required this.completed, this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timer_type'] = Variable<int>($TimerSessionsTable.$convertertimerType.toSql(timerType));
    if (!nullToAbsent || linkedHabitId != null) map['linked_habit_id'] = Variable<int>(linkedHabitId);
    map['duration_seconds'] = Variable<int>(durationSeconds);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) map['ended_at'] = Variable<DateTime>(endedAt);
    map['completed'] = Variable<bool>(completed);
    if (!nullToAbsent || notes != null) map['notes'] = Variable<String>(notes);
    return map;
  }
  TimerSessionsCompanion toCompanion(bool nullToAbsent) {
    return TimerSessionsCompanion(id: Value(id), timerType: Value(timerType),
      linkedHabitId: linkedHabitId == null && nullToAbsent ? const Value.absent() : Value(linkedHabitId),
      durationSeconds: Value(durationSeconds), startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent ? const Value.absent() : Value(endedAt),
      completed: Value(completed), notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes));
  }
  factory TimerSession.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimerSession(id: serializer.fromJson<int>(json['id']),
      timerType: $TimerSessionsTable.$convertertimerType.fromJson(serializer.fromJson<int>(json['timerType'])),
      linkedHabitId: serializer.fromJson<int?>(json['linkedHabitId']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      completed: serializer.fromJson<bool>(json['completed']), notes: serializer.fromJson<String?>(json['notes']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {'id': serializer.toJson<int>(id),
      'timerType': serializer.toJson<int>($TimerSessionsTable.$convertertimerType.toJson(timerType)),
      'linkedHabitId': serializer.toJson<int?>(linkedHabitId), 'durationSeconds': serializer.toJson<int>(durationSeconds),
      'startedAt': serializer.toJson<DateTime>(startedAt), 'endedAt': serializer.toJson<DateTime?>(endedAt),
      'completed': serializer.toJson<bool>(completed), 'notes': serializer.toJson<String?>(notes)};
  }
  TimerSession copyWith({int? id, TimerType? timerType, Value<int?> linkedHabitId = const Value.absent(),
      int? durationSeconds, DateTime? startedAt, Value<DateTime?> endedAt = const Value.absent(),
      bool? completed, Value<String?> notes = const Value.absent()}) =>
      TimerSession(id: id ?? this.id, timerType: timerType ?? this.timerType,
        linkedHabitId: linkedHabitId.present ? linkedHabitId.value : this.linkedHabitId,
        durationSeconds: durationSeconds ?? this.durationSeconds, startedAt: startedAt ?? this.startedAt,
        endedAt: endedAt.present ? endedAt.value : this.endedAt, completed: completed ?? this.completed,
        notes: notes.present ? notes.value : this.notes);
  @override
  String toString() => 'TimerSession(id: $id, timerType: $timerType, durationSeconds: $durationSeconds)';
  @override
  int get hashCode => Object.hash(id, timerType, linkedHabitId, durationSeconds, startedAt, endedAt, completed, notes);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is TimerSession && other.id == id);
}

class TimerSessionsCompanion extends UpdateCompanion<TimerSession> {
  final Value<int> id;
  final Value<TimerType> timerType;
  final Value<int?> linkedHabitId;
  final Value<int> durationSeconds;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<bool> completed;
  final Value<String?> notes;
  const TimerSessionsCompanion({this.id = const Value.absent(), this.timerType = const Value.absent(),
    this.linkedHabitId = const Value.absent(), this.durationSeconds = const Value.absent(),
    this.startedAt = const Value.absent(), this.endedAt = const Value.absent(),
    this.completed = const Value.absent(), this.notes = const Value.absent()});
  TimerSessionsCompanion.insert({this.id = const Value.absent(), required TimerType timerType,
    this.linkedHabitId = const Value.absent(), required int durationSeconds,
    this.startedAt = const Value.absent(), this.endedAt = const Value.absent(),
    this.completed = const Value.absent(), this.notes = const Value.absent()})
      : timerType = Value(timerType), durationSeconds = Value(durationSeconds);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (timerType.present) map['timer_type'] = Variable<int>($TimerSessionsTable.$convertertimerType.toSql(timerType.value));
    if (linkedHabitId.present) map['linked_habit_id'] = Variable<int>(linkedHabitId.value);
    if (durationSeconds.present) map['duration_seconds'] = Variable<int>(durationSeconds.value);
    if (startedAt.present) map['started_at'] = Variable<DateTime>(startedAt.value);
    if (endedAt.present) map['ended_at'] = Variable<DateTime>(endedAt.value);
    if (completed.present) map['completed'] = Variable<bool>(completed.value);
    if (notes.present) map['notes'] = Variable<String>(notes.value);
    return map;
  }
  @override
  String toString() => 'TimerSessionsCompanion(id: $id, timerType: $timerType)';
}

// ========== Tasks Table (Stub) ==========

class $TasksTable extends Tasks with TableInfo<$TasksTable, Task> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> dueDate = GeneratedColumn<String>('due_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<String> dueTime = GeneratedColumn<String>('due_time', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<TaskPriority, int> priority =
      GeneratedColumn<int>('priority', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false,
          defaultValue: const Constant(1)).withConverter<TaskPriority>($TasksTable.$converterpriority);
  @override
  late final GeneratedColumn<bool> isRecurring = GeneratedColumn<bool>('is_recurring', aliasedName, false,
      type: DriftSqlType.bool, requiredDuringInsert: false, defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<String> recurrenceRule = GeneratedColumn<String>('recurrence_rule', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>('completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>('category_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, title, description, dueDate, dueTime, priority, isRecurring, recurrenceRule, completedAt, createdAt, categoryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => 'tasks';
  @override
  VerificationContext validateIntegrity(Insertable<Task> instance, {bool isInserting = false}) => VerificationContext();
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Task map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Task(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      dueDate: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}due_date']),
      dueTime: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}due_time']),
      priority: $TasksTable.$converterpriority.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}priority'])!),
      isRecurring: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_recurring'])!,
      recurrenceRule: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}recurrence_rule']),
      completedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      categoryId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}category_id']));
  }
  @override
  $TasksTable createAlias(String alias) => $TasksTable(attachedDatabase, alias);
  static JsonTypeConverter2<TaskPriority, int, int> $converterpriority = const EnumIndexConverter<TaskPriority>(TaskPriority.values);
}

class Task extends DataClass implements Insertable<Task> {
  final int id;
  final String title;
  final String? description;
  final String? dueDate;
  final String? dueTime;
  final TaskPriority priority;
  final bool isRecurring;
  final String? recurrenceRule;
  final DateTime? completedAt;
  final DateTime createdAt;
  final int? categoryId;
  const Task({required this.id, required this.title, this.description, this.dueDate, this.dueTime,
      required this.priority, required this.isRecurring, this.recurrenceRule, this.completedAt,
      required this.createdAt, this.categoryId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) map['description'] = Variable<String>(description);
    if (!nullToAbsent || dueDate != null) map['due_date'] = Variable<String>(dueDate);
    if (!nullToAbsent || dueTime != null) map['due_time'] = Variable<String>(dueTime);
    map['priority'] = Variable<int>($TasksTable.$converterpriority.toSql(priority));
    map['is_recurring'] = Variable<bool>(isRecurring);
    if (!nullToAbsent || recurrenceRule != null) map['recurrence_rule'] = Variable<String>(recurrenceRule);
    if (!nullToAbsent || completedAt != null) map['completed_at'] = Variable<DateTime>(completedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || categoryId != null) map['category_id'] = Variable<int>(categoryId);
    return map;
  }
  factory Task.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Task(id: serializer.fromJson<int>(json['id']), title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']), dueDate: serializer.fromJson<String?>(json['dueDate']),
      dueTime: serializer.fromJson<String?>(json['dueTime']),
      priority: $TasksTable.$converterpriority.fromJson(serializer.fromJson<int>(json['priority'])),
      isRecurring: serializer.fromJson<bool>(json['isRecurring']),
      recurrenceRule: serializer.fromJson<String?>(json['recurrenceRule']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      categoryId: serializer.fromJson<int?>(json['categoryId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {'id': serializer.toJson<int>(id), 'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description), 'dueDate': serializer.toJson<String?>(dueDate),
      'dueTime': serializer.toJson<String?>(dueTime),
      'priority': serializer.toJson<int>($TasksTable.$converterpriority.toJson(priority)),
      'isRecurring': serializer.toJson<bool>(isRecurring), 'recurrenceRule': serializer.toJson<String?>(recurrenceRule),
      'completedAt': serializer.toJson<DateTime?>(completedAt), 'createdAt': serializer.toJson<DateTime>(createdAt),
      'categoryId': serializer.toJson<int?>(categoryId)};
  }
  @override
  String toString() => 'Task(id: $id, title: $title)';
  @override
  int get hashCode => Object.hash(id, title, description, dueDate, dueTime, priority, isRecurring, recurrenceRule, completedAt, createdAt, categoryId);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Task && other.id == id);
}

class TasksCompanion extends UpdateCompanion<Task> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> dueDate;
  final Value<String?> dueTime;
  final Value<TaskPriority> priority;
  final Value<bool> isRecurring;
  final Value<String?> recurrenceRule;
  final Value<DateTime?> completedAt;
  final Value<DateTime> createdAt;
  final Value<int?> categoryId;
  const TasksCompanion({this.id = const Value.absent(), this.title = const Value.absent(),
    this.description = const Value.absent(), this.dueDate = const Value.absent(), this.dueTime = const Value.absent(),
    this.priority = const Value.absent(), this.isRecurring = const Value.absent(),
    this.recurrenceRule = const Value.absent(), this.completedAt = const Value.absent(),
    this.createdAt = const Value.absent(), this.categoryId = const Value.absent()});
  TasksCompanion.insert({this.id = const Value.absent(), required String title, this.description = const Value.absent(),
    this.dueDate = const Value.absent(), this.dueTime = const Value.absent(), this.priority = const Value.absent(),
    this.isRecurring = const Value.absent(), this.recurrenceRule = const Value.absent(),
    this.completedAt = const Value.absent(), this.createdAt = const Value.absent(), this.categoryId = const Value.absent()})
      : title = Value(title);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (title.present) map['title'] = Variable<String>(title.value);
    if (description.present) map['description'] = Variable<String>(description.value);
    if (dueDate.present) map['due_date'] = Variable<String>(dueDate.value);
    if (dueTime.present) map['due_time'] = Variable<String>(dueTime.value);
    if (priority.present) map['priority'] = Variable<int>($TasksTable.$converterpriority.toSql(priority.value));
    if (isRecurring.present) map['is_recurring'] = Variable<bool>(isRecurring.value);
    if (recurrenceRule.present) map['recurrence_rule'] = Variable<String>(recurrenceRule.value);
    if (completedAt.present) map['completed_at'] = Variable<DateTime>(completedAt.value);
    if (createdAt.present) map['created_at'] = Variable<DateTime>(createdAt.value);
    if (categoryId.present) map['category_id'] = Variable<int>(categoryId.value);
    return map;
  }
  @override
  String toString() => 'TasksCompanion(id: $id, title: $title)';
}

// ========== Goals Table ==========

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>('title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>('description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumnWithTypeConverter<GoalType, int> goalType =
      GeneratedColumn<int>('goal_type', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false,
          defaultValue: const Constant(0)).withConverter<GoalType>($GoalsTable.$convertergoalType);
  @override
  late final GeneratedColumn<String> targetDate = GeneratedColumn<String>('target_date', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<double> progressPercentage = GeneratedColumn<double>('progress_percentage', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(0.0));
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>('is_completed', aliasedName, false,
      type: DriftSqlType.bool, requiredDuringInsert: false, defaultValue: const Constant(false));
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>('completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, title, description, goalType, targetDate, progressPercentage, isCompleted, createdAt, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<Goal> instance, {bool isInserting = false}) => VerificationContext();
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}description']),
      goalType: $GoalsTable.$convertergoalType.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}goal_type'])!),
      targetDate: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}target_date']),
      progressPercentage: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}progress_percentage'])!,
      isCompleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      completedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']));
  }
  @override
  $GoalsTable createAlias(String alias) => $GoalsTable(attachedDatabase, alias);
  static JsonTypeConverter2<GoalType, int, int> $convertergoalType = const EnumIndexConverter<GoalType>(GoalType.values);
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final String title;
  final String? description;
  final GoalType goalType;
  final String? targetDate;
  final double progressPercentage;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  const Goal({required this.id, required this.title, this.description, required this.goalType,
      this.targetDate, required this.progressPercentage, required this.isCompleted,
      required this.createdAt, this.completedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) map['description'] = Variable<String>(description);
    map['goal_type'] = Variable<int>($GoalsTable.$convertergoalType.toSql(goalType));
    if (!nullToAbsent || targetDate != null) map['target_date'] = Variable<String>(targetDate);
    map['progress_percentage'] = Variable<double>(progressPercentage);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || completedAt != null) map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }
  factory Goal.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(id: serializer.fromJson<int>(json['id']), title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      goalType: $GoalsTable.$convertergoalType.fromJson(serializer.fromJson<int>(json['goalType'])),
      targetDate: serializer.fromJson<String?>(json['targetDate']),
      progressPercentage: serializer.fromJson<double>(json['progressPercentage']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {'id': serializer.toJson<int>(id), 'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'goalType': serializer.toJson<int>($GoalsTable.$convertergoalType.toJson(goalType)),
      'targetDate': serializer.toJson<String?>(targetDate), 'progressPercentage': serializer.toJson<double>(progressPercentage),
      'isCompleted': serializer.toJson<bool>(isCompleted), 'createdAt': serializer.toJson<DateTime>(createdAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt)};
  }
  @override
  String toString() => 'Goal(id: $id, title: $title)';
  @override
  int get hashCode => Object.hash(id, title, description, goalType, targetDate, progressPercentage, isCompleted, createdAt, completedAt);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is Goal && other.id == id);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> description;
  final Value<GoalType> goalType;
  final Value<String?> targetDate;
  final Value<double> progressPercentage;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime?> completedAt;
  const GoalsCompanion({this.id = const Value.absent(), this.title = const Value.absent(),
    this.description = const Value.absent(), this.goalType = const Value.absent(),
    this.targetDate = const Value.absent(), this.progressPercentage = const Value.absent(),
    this.isCompleted = const Value.absent(), this.createdAt = const Value.absent(), this.completedAt = const Value.absent()});
  GoalsCompanion.insert({this.id = const Value.absent(), required String title, this.description = const Value.absent(),
    this.goalType = const Value.absent(), this.targetDate = const Value.absent(),
    this.progressPercentage = const Value.absent(), this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(), this.completedAt = const Value.absent()}) : title = Value(title);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (title.present) map['title'] = Variable<String>(title.value);
    if (description.present) map['description'] = Variable<String>(description.value);
    if (goalType.present) map['goal_type'] = Variable<int>($GoalsTable.$convertergoalType.toSql(goalType.value));
    if (targetDate.present) map['target_date'] = Variable<String>(targetDate.value);
    if (progressPercentage.present) map['progress_percentage'] = Variable<double>(progressPercentage.value);
    if (isCompleted.present) map['is_completed'] = Variable<bool>(isCompleted.value);
    if (createdAt.present) map['created_at'] = Variable<DateTime>(createdAt.value);
    if (completedAt.present) map['completed_at'] = Variable<DateTime>(completedAt.value);
    return map;
  }
  @override
  String toString() => 'GoalsCompanion(id: $id, title: $title)';
}

// ========== GoalLinks Table ==========

class $GoalLinksTable extends GoalLinks with TableInfo<$GoalLinksTable, GoalLink> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalLinksTable(this.attachedDatabase, [this._alias]);
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>('id', aliasedName, false,
      hasAutoIncrement: true, type: DriftSqlType.int, requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>('goal_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  late final GeneratedColumn<int> habitId = GeneratedColumn<int>('habit_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  late final GeneratedColumn<int> taskId = GeneratedColumn<int>('task_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, goalId, habitId, taskId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => 'goal_links';
  @override
  VerificationContext validateIntegrity(Insertable<GoalLink> instance, {bool isInserting = false}) => VerificationContext();
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalLink map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalLink(id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      goalId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}goal_id'])!,
      habitId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}habit_id']),
      taskId: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}task_id']));
  }
  @override
  $GoalLinksTable createAlias(String alias) => $GoalLinksTable(attachedDatabase, alias);
}

class GoalLink extends DataClass implements Insertable<GoalLink> {
  final int id;
  final int goalId;
  final int? habitId;
  final int? taskId;
  const GoalLink({required this.id, required this.goalId, this.habitId, this.taskId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    if (!nullToAbsent || habitId != null) map['habit_id'] = Variable<int>(habitId);
    if (!nullToAbsent || taskId != null) map['task_id'] = Variable<int>(taskId);
    return map;
  }
  factory GoalLink.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalLink(id: serializer.fromJson<int>(json['id']), goalId: serializer.fromJson<int>(json['goalId']),
      habitId: serializer.fromJson<int?>(json['habitId']), taskId: serializer.fromJson<int?>(json['taskId']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return {'id': serializer.toJson<int>(id), 'goalId': serializer.toJson<int>(goalId),
      'habitId': serializer.toJson<int?>(habitId), 'taskId': serializer.toJson<int?>(taskId)};
  }
  @override
  String toString() => 'GoalLink(id: $id, goalId: $goalId)';
  @override
  int get hashCode => Object.hash(id, goalId, habitId, taskId);
  @override
  bool operator ==(Object other) => identical(this, other) || (other is GoalLink && other.id == id);
}

class GoalLinksCompanion extends UpdateCompanion<GoalLink> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<int?> habitId;
  final Value<int?> taskId;
  const GoalLinksCompanion({this.id = const Value.absent(), this.goalId = const Value.absent(),
    this.habitId = const Value.absent(), this.taskId = const Value.absent()});
  GoalLinksCompanion.insert({this.id = const Value.absent(), required int goalId,
    this.habitId = const Value.absent(), this.taskId = const Value.absent()}) : goalId = Value(goalId);
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) map['id'] = Variable<int>(id.value);
    if (goalId.present) map['goal_id'] = Variable<int>(goalId.value);
    if (habitId.present) map['habit_id'] = Variable<int>(habitId.value);
    if (taskId.present) map['task_id'] = Variable<int>(taskId.value);
    return map;
  }
  @override
  String toString() => 'GoalLinksCompanion(id: $id, goalId: $goalId)';
}

// ========== AppDatabase Mixin ==========

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $HabitCompletionsTable habitCompletions = $HabitCompletionsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $GoalLinksTable goalLinks = $GoalLinksTable(this);
  late final $TimerSessionsTable timerSessions = $TimerSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [categories, habits, habitCompletions, tasks, goals, goalLinks, timerSessions];
}
