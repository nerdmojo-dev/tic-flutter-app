import 'dart:async';

import 'package:dio/dio.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';

class ApiInterceptor extends Interceptor {
  final Dio dio;

  ApiInterceptor(this.dio);

  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip attaching access token for refresh endpoint
    if (options.extra["skipAuth"] == true) {
      return handler.next(options);
    }

    final token = await SecureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only refresh on 401
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Don't refresh if the refresh endpoint itself failed
    if (err.requestOptions.extra["skipAuth"] == true) {
      return handler.next(err);
    }

    try {
      if (_isRefreshing) {
        await _refreshCompleter!.future;
      } else {
        _isRefreshing = true;
        _refreshCompleter = Completer<void>();

        await _refreshToken();

        _refreshCompleter!.complete();
      }

      final response = await _retry(err.requestOptions);

      return handler.resolve(response);
    } catch (e) {
      if (!(_refreshCompleter?.isCompleted ?? true)) {
        _refreshCompleter!.completeError(e);
      }

      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await SecureStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception("Refresh token missing");
    }

    final response = await dio.get(
      "/auth/getAccessToken",
      options: Options(
        extra: {"skipAuth": true},
        headers: {"Authorization": "Bearer $refreshToken"},
      ),
    );

    final data = response.data;
    print("CURRENT STATE OF DATA:${data["data"]["token"]}");
    final newAccessToken = data["data"]["token"];
    
    
    if (newAccessToken == null) {
      throw Exception("No access token returned");
    }

    await SecureStorage.saveTokens(accessToken: newAccessToken);
    print("SAVED TOKEN: ${await SecureStorage.getAccessToken()}");
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    final accessToken = await SecureStorage.getAccessToken();

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        "Authorization": "Bearer $accessToken",
      },
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
      extra: requestOptions.extra,
    );

    return dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }
}
