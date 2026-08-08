import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/database/app_database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();

  ref.onDispose(() async {
    await db.close();
  });

  return db;
});