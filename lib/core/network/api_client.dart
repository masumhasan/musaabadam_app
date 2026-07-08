import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class ApiClient {
  ApiClient._();

  static Dio? _dio;

  static Dio get instance {
    _dio ??= _buildDio();
    return _dio!;
  }

  static Dio _buildDio() {
    final dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ));

    dio.interceptors.add(_AuthInterceptor(dio));
    return dio;
  }
}

class _AuthInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _queue = [];

  _AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await TokenStorageService.instance.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final requestPath = err.requestOptions.path;
      // If the 401 is from the refresh-token endpoint itself, the refresh token is expired.
      if (requestPath.contains(ApiConstants.refreshToken)) {
        await TokenStorageService.instance.clearTokens();
        _isRefreshing = false;
        _queue.clear();
        Get.offAllNamed(AppRoutes.signInScreen);
        return handler.next(err);
      }

      // Check if another concurrent request already refreshed the token
      final currentToken = await TokenStorageService.instance.getAccessToken();
      final requestToken = err.requestOptions.headers['Authorization']?.toString().replaceFirst('Bearer ', '');
      if (currentToken != null && requestToken != null && currentToken != requestToken) {
        err.requestOptions.headers['Authorization'] = 'Bearer $currentToken';
        try {
          final retryResponse = await dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          return handler.next(e is DioException ? e : DioException(requestOptions: err.requestOptions, error: e));
        }
      }

      if (_isRefreshing) {
        _queue.add({
          'options': err.requestOptions,
          'handler': handler,
        });
        return;
      }

      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry the original request
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          handler.resolve(retryResponse);

          // Retry all queued requests
          final localQueue = List.from(_queue);
          _queue.clear();
          for (final item in localQueue) {
            final opts = item['options'] as RequestOptions;
            final h = item['handler'] as ErrorInterceptorHandler;
            opts.headers['Authorization'] = 'Bearer $newToken';
            try {
              final resp = await dio.fetch(opts);
              h.resolve(resp);
            } catch (e) {
              h.next(e is DioException ? e : DioException(requestOptions: opts, error: e));
            }
          }
          return;
        }
      } catch (e) {
        bool shouldLogout = true;
        if (e is DioException) {
          final status = e.response?.statusCode;
          // Keep session intact if it's a network glitch, timeout, or server error (5xx)
          if (status == null || status >= 500) {
            shouldLogout = false;
          }
        }

        if (shouldLogout) {
          await TokenStorageService.instance.clearTokens();
          final localQueue = List.from(_queue);
          _queue.clear();
          for (final item in localQueue) {
            final h = item['handler'] as ErrorInterceptorHandler;
            final opts = item['options'] as RequestOptions;
            h.next(DioException(requestOptions: opts, error: 'Session expired'));
          }
          Get.offAllNamed(AppRoutes.signInScreen);
        } else {
          final localQueue = List.from(_queue);
          _queue.clear();
          for (final item in localQueue) {
            final h = item['handler'] as ErrorInterceptorHandler;
            final opts = item['options'] as RequestOptions;
            h.next(e is DioException ? e : DioException(requestOptions: opts, error: e));
          }
        }
      } finally {
        _isRefreshing = false;
      }
    }
    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    final stored = await TokenStorageService.instance.getRefreshToken();
    if (stored == null) return null;

    final response = await Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)).post(
      ApiConstants.refreshToken,
      data: {'refreshToken': stored},
    );

    if (response.statusCode == 200 && response.data['success'] == true) {
      final data = response.data['data'];
      await TokenStorageService.instance.saveTokens(
        accessToken: data['accessToken'],
        refreshToken: data['refreshToken'],
      );
      return data['accessToken'];
    }
    return null;
  }
}
