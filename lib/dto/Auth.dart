import 'package:tic_task_app/dto/User.dart';

class AuthData {
  final String token;
  final String refreshToken;
  final User user;
  final bool alreadyExistingTask;

  AuthData({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.alreadyExistingTask
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    print(json);
    return AuthData(
      token: json["token"],
      refreshToken: json["refreshToken"],
      user: User.fromJson(json["user"]),
      alreadyExistingTask: json["alreadyExistingTask"]
    );
  }
}