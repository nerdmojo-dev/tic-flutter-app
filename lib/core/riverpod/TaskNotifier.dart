import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/TaskRepository.dart';
import 'package:tic_task_app/core/riverpod/AppDatabase.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/dto/TaskResponseDto.dart';

final taskProvider = AsyncNotifierProvider<TaskNotifier, List<TaskResponseDto>>(
  TaskNotifier.new,
);

class TaskNotifier extends AsyncNotifier<List<TaskResponseDto>> {
  Taskrepository get _repository =>
      Taskrepository(DioClient.dio, ref.read(databaseProvider));

  Future<void> fetchTasks({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {

      print("********************FETCHING FOR $startDate $endDate*****************************");
      // Fetch from server
      final remote = await _repository.getAssignedTasks(
        page: page,
        offset: 100,
        startDate: startDate,
        endDate: endDate,
      );

      // Read local pending tasks
      final local = await _repository.getLocalTasks();

      return [remote, local];
    });
  }

  Future<void> editTask(
    String taskId,
    String title,
    String description,
    String status,
  ) async {
    await _repository.editTask(taskId, title, description, status);
  }

  @override
  FutureOr<List<TaskResponseDto>> build() async {
    final now = DateTime.now();

    // TODO: implement build
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final remote = await _repository.getAssignedTasks(
      page: 1,
      offset: 100,
      startDate: start,
      endDate: end,
    );

    // Read local pending tasks
    final local = await _repository.getLocalTasks();

    return [remote, local];
  }
}
