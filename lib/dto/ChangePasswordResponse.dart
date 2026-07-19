import 'package:tic_task_app/dto/Auth.dart';

class ChangepasswordResponse {
  final bool hasError;
  final String message;
  final dynamic data;
  final dynamic errors;
  final DateTime timestamp;

  ChangepasswordResponse({
    required this.hasError,
    required this.message,
    required this.data,
    required this.errors,
    required this.timestamp,
  });

  factory ChangepasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangepasswordResponse(
      hasError: json["hasError"],
      message: json["message"],
      data: json["data"],
      errors: json["errors"],
      timestamp: DateTime.parse(json["timestamp"]),
    );
  }
}