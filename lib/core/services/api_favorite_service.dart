import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';

class ApiFavoriteService {
  ApiFavoriteService._();
  static final ApiFavoriteService instance = ApiFavoriteService._();

  final Dio _dio = ApiClient.instance;

  /// Toggle a product in the wishlist. Returns whether it is now favorited.
  Future<bool> toggle(String productId) async {
    final response = await _dio.post(ApiConstants.toggleFavorite(productId));
    return response.data['data']['favorited'] == true;
  }

  Future<List<ProductModel>> list({int page = 1}) async {
    final response = await _dio.get(ApiConstants.favorites, queryParameters: {'page': page, 'limit': 20});
    final list = response.data['data']['products'] as List;
    return list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
