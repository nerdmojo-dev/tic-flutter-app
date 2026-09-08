
import 'package:dio/dio.dart';

class Healthservice {
  final Dio dio;
  Healthservice({required this.dio});

  Future<bool> pingServer() async {
    try {
      await dio.get("/health");

      return true;
    } catch (e) {
      return false;
    }
  }
}
