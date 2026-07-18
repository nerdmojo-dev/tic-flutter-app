import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    // Add JWT token
    options.headers["Authorization"] = "Bearer YOUR_TOKEN";

    print("REQUEST: ${options.method} ${options.uri}");

    handler.next(options);
  }


  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print("RESPONSE: ${response.statusCode}");

    handler.next(response);
  }


  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    print(
      "ERROR: ${err.response?.statusCode} ${err.message}"
    );

    if (err.response?.statusCode == 401) {
      // Handle unauthorized error, e.g., refresh token or redirect to login
      
    }

    handler.next(err);
  }
}