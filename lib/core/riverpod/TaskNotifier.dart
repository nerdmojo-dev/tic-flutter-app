import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/TaskRepository.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/dto/TaskResponseDto.dart';

final taskProvider = AsyncNotifierProvider<TaskNotifier, TaskResponseDto>(
  TaskNotifier.new,
);

class TaskNotifier extends AsyncNotifier<TaskResponseDto> {
  Taskrepository get _repository => Taskrepository(DioClient.dio);

  Future<void> fetchTasks({
    DateTime? startDate,
    DateTime? endDate,
    int page = 1,
  }) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return _repository.getAssignedTasks(
        page: page,
        offset: 10,
        startDate: startDate,
        endDate: endDate,
      );
    });
  }

  Future<void> editTask(String taskId, String title, String description,String status) async {
    await _repository.editTask(taskId, title, description,status);
  }

  @override
  FutureOr<TaskResponseDto> build() async {
    final now = DateTime.now();

    // TODO: implement build
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return await _repository.getAssignedTasks(
      page: 1,
      offset: 10,
      startDate: start,
      endDate: end,
    );
  }
}
