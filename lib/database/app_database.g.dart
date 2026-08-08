// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TaskLocalsTable extends TaskLocals
    with TableInfo<$TaskLocalsTable, TaskLocal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskLocalsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isEditedMeta = const VerificationMeta(
    'isEdited',
  );
  @override
  late final GeneratedColumn<bool> isEdited = GeneratedColumn<bool>(
    'is_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    title,
    description,
    status,
    createdBy,
    synced,
    isEdited,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_locals';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskLocal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('is_edited')) {
      context.handle(
        _isEditedMeta,
        isEdited.isAcceptableOrUnknown(data['is_edited']!, _isEditedMeta),
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
  TaskLocal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskLocal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      isEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_edited'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskLocalsTable createAlias(String alias) {
    return $TaskLocalsTable(attachedDatabase, alias);
  }
}

class TaskLocal extends DataClass implements Insertable<TaskLocal> {
  final int id;
  final String taskId;
  final String title;
  final String description;
  final String status;
  final String createdBy;
  final bool synced;
  final bool isEdited;
  final DateTime createdAt;
  const TaskLocal({
    required this.id,
    required this.taskId,
    required this.title,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.synced,
    required this.isEdited,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['task_id'] = Variable<String>(taskId);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    map['created_by'] = Variable<String>(createdBy);
    map['synced'] = Variable<bool>(synced);
    map['is_edited'] = Variable<bool>(isEdited);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskLocalsCompanion toCompanion(bool nullToAbsent) {
    return TaskLocalsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      description: Value(description),
      status: Value(status),
      createdBy: Value(createdBy),
      synced: Value(synced),
      isEdited: Value(isEdited),
      createdAt: Value(createdAt),
    );
  }

  factory TaskLocal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskLocal(
      id: serializer.fromJson<int>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      synced: serializer.fromJson<bool>(json['synced']),
      isEdited: serializer.fromJson<bool>(json['isEdited']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
      'createdBy': serializer.toJson<String>(createdBy),
      'synced': serializer.toJson<bool>(synced),
      'isEdited': serializer.toJson<bool>(isEdited),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskLocal copyWith({
    int? id,
    String? taskId,
    String? title,
    String? description,
    String? status,
    String? createdBy,
    bool? synced,
    bool? isEdited,
    DateTime? createdAt,
  }) => TaskLocal(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    title: title ?? this.title,
    description: description ?? this.description,
    status: status ?? this.status,
    createdBy: createdBy ?? this.createdBy,
    synced: synced ?? this.synced,
    isEdited: isEdited ?? this.isEdited,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskLocal copyWithCompanion(TaskLocalsCompanion data) {
    return TaskLocal(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      synced: data.synced.present ? data.synced.value : this.synced,
      isEdited: data.isEdited.present ? data.isEdited.value : this.isEdited,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskLocal(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('synced: $synced, ')
          ..write('isEdited: $isEdited, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    title,
    description,
    status,
    createdBy,
    synced,
    isEdited,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskLocal &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.description == this.description &&
          other.status == this.status &&
          other.createdBy == this.createdBy &&
          other.synced == this.synced &&
          other.isEdited == this.isEdited &&
          other.createdAt == this.createdAt);
}

class TaskLocalsCompanion extends UpdateCompanion<TaskLocal> {
  final Value<int> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<String> description;
  final Value<String> status;
  final Value<String> createdBy;
  final Value<bool> synced;
  final Value<bool> isEdited;
  final Value<DateTime> createdAt;
  const TaskLocalsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.synced = const Value.absent(),
    this.isEdited = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  TaskLocalsCompanion.insert({
    this.id = const Value.absent(),
    required String taskId,
    required String title,
    required String description,
    required String status,
    required String createdBy,
    this.synced = const Value.absent(),
    this.isEdited = const Value.absent(),
    required DateTime createdAt,
  }) : taskId = Value(taskId),
       title = Value(title),
       description = Value(description),
       status = Value(status),
       createdBy = Value(createdBy),
       createdAt = Value(createdAt);
  static Insertable<TaskLocal> custom({
    Expression<int>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? status,
    Expression<String>? createdBy,
    Expression<bool>? synced,
    Expression<bool>? isEdited,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (createdBy != null) 'created_by': createdBy,
      if (synced != null) 'synced': synced,
      if (isEdited != null) 'is_edited': isEdited,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TaskLocalsCompanion copyWith({
    Value<int>? id,
    Value<String>? taskId,
    Value<String>? title,
    Value<String>? description,
    Value<String>? status,
    Value<String>? createdBy,
    Value<bool>? synced,
    Value<bool>? isEdited,
    Value<DateTime>? createdAt,
  }) {
    return TaskLocalsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      createdBy: createdBy ?? this.createdBy,
      synced: synced ?? this.synced,
      isEdited: isEdited ?? this.isEdited,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (isEdited.present) {
      map['is_edited'] = Variable<bool>(isEdited.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskLocalsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdBy: $createdBy, ')
          ..write('synced: $synced, ')
          ..write('isEdited: $isEdited, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TaskLocalsTable taskLocals = $TaskLocalsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [taskLocals];
}

typedef $$TaskLocalsTableCreateCompanionBuilder =
    TaskLocalsCompanion Function({
      Value<int> id,
      required String taskId,
      required String title,
      required String description,
      required String status,
      required String createdBy,
      Value<bool> synced,
      Value<bool> isEdited,
      required DateTime createdAt,
    });
typedef $$TaskLocalsTableUpdateCompanionBuilder =
    TaskLocalsCompanion Function({
      Value<int> id,
      Value<String> taskId,
      Value<String> title,
      Value<String> description,
      Value<String> status,
      Value<String> createdBy,
      Value<bool> synced,
      Value<bool> isEdited,
      Value<DateTime> createdAt,
    });

class $$TaskLocalsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskLocalsTable> {
  $$TaskLocalsTableFilterComposer({
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

  ColumnFilters<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEdited => $composableBuilder(
    column: $table.isEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TaskLocalsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskLocalsTable> {
  $$TaskLocalsTableOrderingComposer({
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

  ColumnOrderings<String> get taskId => $composableBuilder(
    column: $table.taskId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEdited => $composableBuilder(
    column: $table.isEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TaskLocalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskLocalsTable> {
  $$TaskLocalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get taskId =>
      $composableBuilder(column: $table.taskId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<bool> get isEdited =>
      $composableBuilder(column: $table.isEdited, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TaskLocalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskLocalsTable,
          TaskLocal,
          $$TaskLocalsTableFilterComposer,
          $$TaskLocalsTableOrderingComposer,
          $$TaskLocalsTableAnnotationComposer,
          $$TaskLocalsTableCreateCompanionBuilder,
          $$TaskLocalsTableUpdateCompanionBuilder,
          (
            TaskLocal,
            BaseReferences<_$AppDatabase, $TaskLocalsTable, TaskLocal>,
          ),
          TaskLocal,
          PrefetchHooks Function()
        > {
  $$TaskLocalsTableTableManager(_$AppDatabase db, $TaskLocalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskLocalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskLocalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskLocalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<bool> isEdited = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => TaskLocalsCompanion(
                id: id,
                taskId: taskId,
                title: title,
                description: description,
                status: status,
                createdBy: createdBy,
                synced: synced,
                isEdited: isEdited,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String taskId,
                required String title,
                required String description,
                required String status,
                required String createdBy,
                Value<bool> synced = const Value.absent(),
                Value<bool> isEdited = const Value.absent(),
                required DateTime createdAt,
              }) => TaskLocalsCompanion.insert(
                id: id,
                taskId: taskId,
                title: title,
                description: description,
                status: status,
                createdBy: createdBy,
                synced: synced,
                isEdited: isEdited,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TaskLocalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskLocalsTable,
      TaskLocal,
      $$TaskLocalsTableFilterComposer,
      $$TaskLocalsTableOrderingComposer,
      $$TaskLocalsTableAnnotationComposer,
      $$TaskLocalsTableCreateCompanionBuilder,
      $$TaskLocalsTableUpdateCompanionBuilder,
      (TaskLocal, BaseReferences<_$AppDatabase, $TaskLocalsTable, TaskLocal>),
      TaskLocal,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TaskLocalsTableTableManager get taskLocals =>
      $$TaskLocalsTableTableManager(_db, _db.taskLocals);
}
