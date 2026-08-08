import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: "accessToken");
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: "refreshToken");
  }

  static Future<String?> getEmpId() async {
    return await _storage.read(key: "employeeId");
  }
  static Future<String?> getFullname() async {
    return await _storage.read(key: "fullName");
  }


  static Future<void> saveTokens({required String accessToken}) async {
    await _storage.write(key: "accessToken", value: accessToken);
  }

  static Future<void> saveLastSubmittedDate() async {
    await _storage.write(
      key: "last_submit_date",
      value: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
  }

  static Future<String?> readLastSubmitDate() async {
    await _storage.read(
      key: "last_submit_date",
    );
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
  }

  static Future<String?> getuserId() async {
        return await _storage.read(key: "empId");

  }
}
