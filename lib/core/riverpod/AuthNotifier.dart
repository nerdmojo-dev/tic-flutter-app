import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/AuthRepository.dart';
import 'package:tic_task_app/dto/ApplicationResponse.dart';
import 'package:tic_task_app/dto/Auth.dart';
import 'package:tic_task_app/dto/User.dart';

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

class AuthNotifier extends AsyncNotifier<User?> {
  late final FlutterSecureStorage _storage;
  late final AuthRepository _repository;

  @override
  Future<User?> build() async {
    await Future.delayed(const Duration(seconds: 4));

    _storage = ref.read(secureStorageProvider);
    _repository = AuthRepository(DioClient.dio);

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

      final AuthData authData = response.data;

      await _storage.write(key: "accessToken", value: authData.token);

      await _storage.write(key: "refreshToken", value: authData.refreshToken);

      await _storage.write(
        key: "user",
        value: jsonEncode(authData.user.toJson()),
      );

      return authData.user;
    });
  }

  Future<void> logout() async {
    await _storage.deleteAll();
    state = const AsyncData(null);
  }
}
