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
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Retry original request with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final retryResponse = await dio.fetch(err.requestOptions);
          _isRefreshing = false;
          return handler.resolve(retryResponse);
        }
      } catch (_) {
        // Refresh failed — clear session and redirect to sign-in
        await TokenStorageService.instance.clearTokens();
        _isRefreshing = false;
        Get.offAllNamed(AppRoutes.signInScreen);
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
