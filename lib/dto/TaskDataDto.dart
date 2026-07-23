import 'package:tic_task_app/dto/Task.dart';

class TaskDataDto {
  final int page;
  final int offset;
  final int totalTasks;
  final int totalPages;
  final List<Task> tasks;

  TaskDataDto({
    required this.page,
    required this.offset,
    required this.totalTasks,
    required this.totalPages,
    required this.tasks,
  });

  factory TaskDataDto.fromJson(Map<String, dynamic> json) {
    return TaskDataDto(
      page: json["page"],
      offset: json["offset"],
      totalTasks: json["countOfDocuments"],
      totalPages: json["totalPages"],
      tasks: (json["tasks"] as List).map((e) => Task.fromJson(e)).toList(),
    );
  }
}
