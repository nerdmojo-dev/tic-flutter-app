import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/AuthRepository.dart';
import 'package:tic_task_app/dto/ApplicationResponse.dart';
import 'package:tic_task_app/dto/Auth.dart';
import 'package:tic_task_app/dto/ChangePasswordResponse.dart';
import 'package:tic_task_app/dto/TaskResponse.dart';
import 'package:tic_task_app/dto/User.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class AuthNotifier extends AsyncNotifier<User?> {
  AuthRepository get _repository => AuthRepository(DioClient.dio);

  FlutterSecureStorage get _storage => ref.read(secureStorageProvider);

  @override
  Future<User?> build() async {
    await Future.delayed(const Duration(seconds: 4));

    final userJson = await _storage.read(key: "user");

    if (userJson == null) {
      return null;
    }

    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (_) {
      await _storage.deleteAll();
      return null;
    }
  }

  Future<void> login(String employeeId, String password) async {
    state = await AsyncValue.guard(() async {
      final Applicationresponse response = await _repository.login(
        employeeId,
        password,
      );

      print(response);

      final AuthData authData = response.data;

      await _storage.write(key: "accessToken", value: authData.token);

      await _storage.write(key: "refreshToken", value: authData.refreshToken);
      await _storage.write(
        key: "isFirstLogin",
        value: authData.user.isFirstLogin.toString(),
      );

      await _storage.write(
        key: "last_submit_date",
        value: DateFormat('yyyy-MM-dd').format(
          authData.alreadyExistingTask
              ? DateTime.now()
              : DateTime.now().subtract(const Duration(days: 3)),
        ),
      );

      await _storage.write(
        key: "user",
        value: jsonEncode(authData.user.toJson()),
      );

      return authData.user;
    });
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = await AsyncValue.guard(() async {
      final ChangepasswordResponse response = await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      print("RESPONSE : $response");

      if (response.hasError) {
        throw Exception(response.message);
      }

      final user = state.value;
      if (user == null) {
        throw Exception("No logged in user");
      }

      final updatedUser = user.copyWith(isFirstLogin: false);

      await _storage.write(
        key: "user",
        value: jsonEncode(updatedUser.toJson()),
      );

      return updatedUser;
    });
  }

  Future<void> createTask(String text) async {
    final user = state.value;
    if (user == null) {
      throw Exception("No logged in user");
    }

    final CreateTaskResponse response = await _repository.submitTranscript(
      user.fullName,
      text,
    );

    if (response.hasError) {
      throw Exception(response.message);
    }
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AsyncData(null);
  }
}
