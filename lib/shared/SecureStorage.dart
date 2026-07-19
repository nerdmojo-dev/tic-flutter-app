import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "accessToken");
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refreshToken");
  }

  static Future<void> saveTokens({
    required String accessToken
  }) async {
    await _storage.write(key: "accessToken", value: accessToken);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}