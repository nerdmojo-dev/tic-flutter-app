import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tic_task_app/database/app_database.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/dto/TaskDataDto.dart';
import 'package:tic_task_app/dto/TaskResponse.dart';
import 'package:tic_task_app/dto/TaskResponseDto.dart';
import 'package:tic_task_app/dto/User.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';

class Taskrepository {
  final Dio dio;
  final AppDatabase db;

  Taskrepository(this.dio, this.db);

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
      return new TaskResponseDto(
        hasError: true,
        message: "Failed to fetch tasks",
        errors: [e.toString()],
        timestamp: DateTime.now(),
        data: TaskDataDto(
          page: 0,
          offset: 0,
          totalPages: 0,
          totalTasks: 0,
          tasks: [],
        ),
      );
    }
  }

  Future<void> editTask(
    String taskId,
    String title,
    String description,
    String status,
  ) async {
    try {
      final response = await dio.put(
        "/tasks/editTask/$taskId",
        data: {"title": title, "description": description, "status": status},
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("DATA: ${response.data}");
    } on DioException catch (e) {
      debugPrint("DIO ERROR: ${e.message}");
      debugPrint("STATUS: ${e.response?.statusCode}");
      debugPrint("ERROR DATA: ${e.response?.data}");
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

  Future<TaskResponseDto> getLocalTasks() async {
    final rows = await (db.select(
      db.taskLocals,
    )..where((t) => t.synced.equals(false))).get();
    String userId = await SecureStorage.getuserId() ?? "8324823u4";
    String empId = await SecureStorage.getEmpId() ?? "null";
    String fullName = await SecureStorage.getFullname() ?? "null";

    return TaskResponseDto(
      hasError: false,
      message: "Local tasks fetched successfully from local",
      errors: [],
      timestamp: DateTime.now(),

      data: TaskDataDto(
        page: 1,
        offset: rows.length,
        totalPages: 1,
        totalTasks: rows.length,
        tasks: rows.map((row) {
          return Task(
            id: row.taskId,
            title: row.title,
            description: row.description,
            status: row.status,
            isEdited: row.isEdited,
            createdBy: User(
              id: userId, // You can set this to an appropriate value if needed
              fullName:
                  fullName, // You can set this to an appropriate value if needed
              employeeId:
                  empId, // You can set this to an appropriate value if needed
              department: '',
              role: '',
              gender: '',
              isActive: true,
              isFirstLogin: false,
              accountLocked: false,
              createdAt: DateTime.now(),
              updatedAt: row
                  .createdAt, // You can set this to an appropriate value if needed
            ),
            dueDate: row.createdAt,
            priority: '',
            assignedTo: [],
            tags: [],
            isDeleted: false,
            comments: [],
            createdAt: row.createdAt,
            updatedAt: row.createdAt,
            version: 0,
            // Assuming dueDate is the same as createdAt for local tasks
          );
        }).toList(),
      ),
    );
  }

  Future<void> markTaskSynced(int id) async {
    await (db.update(db.taskLocals)..where((t) => t.id.equals(id))).write(
      const TaskLocalsCompanion(synced: Value(true)),
    );
  }

  Future<void> deleteTask(int id) async {
    await (db.delete(db.taskLocals)..where((t) => t.id.equals(id))).go();
  }

  Future<CreateTaskResponse> saveTask(
    String userFullName,
    String text,
    String status,
  ) async {
    try {
      print("URL: ${dio.options.baseUrl}/tasks/addtask");
      print("Method: POST");
      print("Headers: ${dio.options.headers}");

      final response = await dio.post(
        "/tasks/addtask", // Replace with your endpoint
        data: {
          "title": "$userFullName",
          "description": text,
          "assignedTo": [],
          "dueDate": DateTime.now().toIso8601String(),
          "status": status,
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
