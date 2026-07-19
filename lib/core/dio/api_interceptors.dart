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

    final token = await SecureStorage.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      // If another request is already refreshing, wait.
      if (_isRefreshing) {
        await _refreshCompleter?.future;

        final retryResponse = await _retry(err.requestOptions);

        return handler.resolve(retryResponse);
      }

      _isRefreshing = true;
      _refreshCompleter = Completer<void>();

      await _refreshToken();

      _refreshCompleter?.complete();

      final retryResponse = await _retry(err.requestOptions);

      handler.resolve(retryResponse);
    } catch (e) {
      _refreshCompleter?.completeError(e);

      await SecureStorage.clear();

      handler.next(err);

      // Navigate to Login screen here
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await SecureStorage.getRefreshToken();

    if (refreshToken == null) {
      throw Exception("No refresh token");
    }

    final response = await dio.post(
      "/getAccessToken",
      options: Options(headers: {"Authorization": "Bearer $refreshToken"}),
    );

    final data = response.data;

    await SecureStorage.saveTokens(
      accessToken: data["accessToken"],
      refreshToken: data["refreshToken"],
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final accessToken = await SecureStorage.getAccessToken();

    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        "Authorization": "Bearer $accessToken",
      },
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      followRedirects: requestOptions.followRedirects,
      receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
      extra: requestOptions.extra,
      listFormat: requestOptions.listFormat,
      maxRedirects: requestOptions.maxRedirects,
      receiveTimeout: requestOptions.receiveTimeout,
      requestEncoder: requestOptions.requestEncoder,
      responseDecoder: requestOptions.responseDecoder,
      sendTimeout: requestOptions.sendTimeout,
      validateStatus: requestOptions.validateStatus,
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
