import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tic_task_app/core/repository/TaskRepository.dart';
import 'package:tic_task_app/database/app_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class TaskSyncService {
  final Taskrepository repository;
  final AppDatabase db;

  TaskSyncService(this.repository, this.db);

  Future<void> syncPendingTasks() async {
    //6a76a96d6856394417d60b73
    final connectivityResult = await Connectivity().checkConnectivity();
    debugPrint("*********************SYNC TASKS*****************************");
    if (connectivityResult.contains(ConnectivityResult.none)) {
      debugPrint("No internet connection");
      return;
    }

    final rows = await (db.select(
      db.taskLocals,
    )..where((t) => t.synced.equals(false))).get();

    for (final row in rows) {
      debugPrint(
        'id=${row.id}, '
        'taskId=${row.taskId}, '
        'title=${row.title}, '
        'description=${row.description}, '
        'synced=${row.synced}, '
        'edited=${row.isEdited}',
      );
    }

    for (final task in rows) {
      try {
        if (task.synced) {
          continue; // Skip already synced tasks
        }

        String description = task.description;
        if (isBengali(task.description)) {
          description = await translate(description);
        }
        print(description);


        try {
          if (task.isEdited) {
            await repository.editTask(
              task.taskId,
              task.title,
              description,
              task.status,
            );
          } else {
            await repository.saveTask(task.title, description, task.status);
          }
          await repository.markTaskSynced(task.id);
        } catch (e) {
          debugPrint("Error in syncing task ${task.taskId}: $e");
          continue; // Skip this task and continue with the next one
        }
      } catch (e) {
        debugPrint("$e");
      }finally{
        await Future.delayed(Duration(seconds: 5));
      }
    }
    debugPrint("*********************SYNC TASKS*****************************");
  }

  bool isBengali(String text) {
    return RegExp(r'[\u0980-\u09FF]').hasMatch(text);
  }

  Future<String> translate(String description) async {
    try {
      final dio = Dio();

      final response = await dio.post(
        'http://3.26.191.191:8000/translate',
        data: {'text': description},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        return response.data['translated'] ?? description;
      }

      debugPrint('Translation failed: ${response.statusCode}');

      // return description;
      throw Exception("Translation failed");
    } on DioException catch (e) {
      debugPrint('Translation error: ${e.message}');

      throw e;
    } catch (e) {
      debugPrint('Translation error: $e');
      throw e;
    }
  }
}
