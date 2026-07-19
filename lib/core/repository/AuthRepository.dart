import 'package:dio/dio.dart';
import 'package:tic_task_app/dto/ApplicationResponse.dart';
import 'package:tic_task_app/dto/ChangePasswordResponse.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<Applicationresponse> login(
    String employeeId,
    String password,
  ) async {
    try {
      final response = await dio.post(
        "/auth/loginUser",
        data: {
          "employeeId": employeeId,
          "password": password,
        },
      );
      print(response.data.runtimeType);
      print(response.data);
      return Applicationresponse.fromJson(response.data);
    } on DioException catch (e) {
      print(e);
      if (e.response != null) {
        throw Exception(
          e.response?.data["data"] ??
              e.response?.data["message"] ??
              "Login failed",
        );
      }

      throw Exception("Unable to connect to server");
    }
  }

  Future<ChangepasswordResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final response = await dio.post(
      "/auth/changePassword",
      data: {
        "oldPassword": currentPassword,
        "newPassword": newPassword,
      },
    );
      print(response.data.runtimeType);
      print(response.data);
      return ChangepasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data["data"] ??
              e.response?.data["message"] ??
              "Change Password failed",
        );
      }

      throw Exception("Unable to connect to server");
    }
    
  }
}