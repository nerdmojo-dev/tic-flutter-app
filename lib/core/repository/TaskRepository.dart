import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tic_task_app/dto/TaskResponseDto.dart';

class Taskrepository {
  final Dio dio;

  Taskrepository(this.dio);

  Future<TaskResponseDto> getAssignedTasks({
    int page = 1,
    int offset = 10,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final response = await dio.get(
        "/tasks/getAssignedTasks",
        queryParameters: {
          "page": page,
          "offset": offset,
          if (startDate != null)
            "startDate": DateFormat("yyyy-MM-dd").format(startDate),
          if (endDate != null)
            "endDate": DateFormat("yyyy-MM-dd").format(endDate),
        },
      );

      print(response);

      return TaskResponseDto.fromJson(response.data);
    } on Exception catch (e) {
      print(e);
      throw new Exception("hatt bal");
    }
  }

  Future<void> editTask(String taskId, String title, String description) async {
    await dio.put(
      "/tasks/editTask/$taskId",
      data: {"title": title, "description": description},
    );
  }
}
