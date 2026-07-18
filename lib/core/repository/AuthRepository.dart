import 'package:dio/dio.dart';
import 'package:tic_task_app/dto/ApplicationResponse.dart';

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
}