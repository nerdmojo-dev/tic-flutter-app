import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class TaskLocals extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get taskId => text()();

  TextColumn get title => text()();

  TextColumn get description => text()();

  TextColumn get status => text()();

  TextColumn get createdBy => text()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  BoolColumn get isEdited => boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [TaskLocals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'tasks.sqlite'));
    return NativeDatabase(file);
  });
}