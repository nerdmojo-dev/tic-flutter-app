import 'package:dio/dio.dart';
import './api_interceptors.dart';

class DioClient {
  static final Dio dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        // baseUrl: "https://ticbackendapp.onrender.com/api/v1",
        baseUrl: "http://15.134.31.187:8080/api/v1",
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(ApiInterceptor(dio));

    return dio;
  }
}
