import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/auth/user_model.dart';

class SellerService {
  SellerService._();
  static final SellerService instance = SellerService._();

  final Dio _dio = ApiClient.instance;

  Future<UserModel> applyAsSeller({
    required String primaryCategory,
    required List<String> subcategories,
    required String sellerType,
    required Map<String, String> businessAddress,
    required String averageEarningRange,
  }) async {
    final response = await _dio.post(ApiConstants.sellerApplication, data: {
      'primaryCategory': primaryCategory,
      'subcategories': subcategories,
      'sellerType': sellerType,
      'businessAddress': businessAddress,
      'averageEarningRange': averageEarningRange,
    });
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
      if (data is Map && data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          return (errors.first as Map)['message'] as String? ?? 'Unknown error';
        }
      }
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
