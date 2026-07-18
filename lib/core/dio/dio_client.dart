import 'package:dio/dio.dart';
import './api_interceptors.dart';

class DioClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://ticbackendapp.onrender.com/api/v1",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  )
    ..interceptors.add(ApiInterceptor());

}