import 'package:dio/dio.dart';
import './api_interceptors.dart';

class DioClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8080/api/v1",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  )
    ..interceptors.add(ApiInterceptor());

}