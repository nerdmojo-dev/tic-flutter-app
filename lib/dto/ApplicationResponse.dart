import 'package:tic_task_app/dto/Auth.dart';

class Applicationresponse {
  final bool hasError;
  final String message;
  final AuthData data;
  final dynamic errors;
  final DateTime timestamp;

  Applicationresponse({
    required this.hasError,
    required this.message,
    required this.data,
    required this.errors,
    required this.timestamp,
  });

  factory Applicationresponse.fromJson(Map<String, dynamic> json) {
    return Applicationresponse(
      hasError: json["hasError"],
      message: json["message"],
      data: AuthData.fromJson(json["data"]),
      errors: json["errors"],
      timestamp: DateTime.parse(json["timestamp"]),
    );
  }
}