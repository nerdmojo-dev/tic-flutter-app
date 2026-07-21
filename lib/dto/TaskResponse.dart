import 'package:tic_task_app/dto/Task.dart';

class CreateTaskResponse {
  final bool hasError;
  final String message;
  final Task task;
  final dynamic errors;
  final DateTime timestamp;

  CreateTaskResponse({
    required this.hasError,
    required this.message,
    required this.task,
    required this.errors,
    required this.timestamp,
  });

  factory CreateTaskResponse.fromJson(Map<String, dynamic> json) {
    return CreateTaskResponse(
      hasError: json["hasError"],
      message: json["message"],
      task: Task.fromJson(json["data"]),
      errors: json["errors"],
      timestamp: DateTime.parse(json["timestamp"]),
    );
  }
}