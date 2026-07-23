import 'package:tic_task_app/dto/TaskDataDto.dart';

class TaskResponseDto {
  final bool hasError;
  final String message;
  final TaskDataDto data;
  final dynamic errors;
  final DateTime timestamp;

  TaskResponseDto({
    required this.hasError,
    required this.message,
    required this.data,
    required this.errors,
    required this.timestamp,
  });

  factory TaskResponseDto.fromJson(Map<String, dynamic> json) {
    return TaskResponseDto(
      hasError: json["hasError"],
      message: json["message"],
      data: TaskDataDto.fromJson(json["data"]),
      errors: json["errors"],
      timestamp: DateTime.parse(json["timestamp"]),
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "hasError": hasError,
  //       "message": message,
  //       "data": TaskDa.toJson(),
  //       "errors": errors,
  //       "timestamp": timestamp.toIso8601String(),
  //     };
}