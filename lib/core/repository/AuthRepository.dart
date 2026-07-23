import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:tic_task_app/dto/ApplicationResponse.dart';
import 'package:tic_task_app/dto/ChangePasswordResponse.dart';
import 'package:tic_task_app/dto/TaskResponse.dart';
import 'package:tic_task_app/dto/TaskResponseDto.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<Applicationresponse> login(String employeeId, String password) async {
    try {
      final response = await dio.post(
        "/auth/loginUser",
        data: {"employeeId": employeeId, "password": password},
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
        data: {"oldPassword": currentPassword, "newPassword": newPassword},
      );
      
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


  Future<TaskResponseDto> getTasksByDate({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await dio.post(
        "/tasks/getAssignedTasks?page=1&offset=10&startDate=$startDate&endDate=$endDate",
      );
      
      return TaskResponseDto.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data["data"] ??
              e.response?.data["message"] ??
              "Tasks fetching issue",
        );
      }

      throw Exception("Unable to connect to server");
    }
  }

  Future<CreateTaskResponse> submitTranscript(
    String userFullName,
    String text,
  ) async {
    try {
      final currDateTIme = DateTime.now();
      final formattedDateTime = DateFormat(
        'dd, MMM yyyy',
      ).format(DateTime.now());

      print("URL: ${dio.options.baseUrl}/tasks/addtask");
      print("Method: POST");
      print("Headers: ${dio.options.headers}");

      final response = await dio.post(
        "/tasks/addtask", // Replace with your endpoint
        data: {
          "title": "$userFullName - $formattedDateTime",
          "description": text,
          "assignedTo": [],
          "dueDate": currDateTIme.toUtc().toIso8601String(),
        },
      );

      print(response.data.runtimeType);
      print(response.data);

      return CreateTaskResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data["data"] ??
              e.response?.data["message"] ??
              "Task submission failed",
        );
      }

      throw Exception("Unable to connect to server");
    }
  }
}
