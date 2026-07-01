import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/review/review_model.dart';

class ApiReviewService {
  ApiReviewService._();
  static final ApiReviewService instance = ApiReviewService._();

  final Dio _dio = ApiClient.instance;

  Future<SellerReviews> getSellerReviews(String sellerId, {int page = 1}) async {
    final response = await _dio.get(ApiConstants.sellerReviews(sellerId), queryParameters: {
      'page': page,
      'limit': 20,
    });
    return SellerReviews.fromJson(Map<String, dynamic>.from(response.data['data'] as Map));
  }

  Future<void> submitReview({required String orderId, required int rating, String? comment}) async {
    await _dio.post(ApiConstants.reviews, data: {
      'orderId': orderId,
      'rating': rating,
      'comment': ?comment,
    });
  }

  Future<List<Map<String, dynamic>>> getReviewableOrders() async {
    final response = await _dio.get(ApiConstants.reviewableOrders);
    final list = response.data['data']['orders'] as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
