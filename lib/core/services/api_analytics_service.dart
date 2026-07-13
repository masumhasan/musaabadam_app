import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

class ApiAnalyticsService {
  ApiAnalyticsService._();
  static final ApiAnalyticsService instance = ApiAnalyticsService._();

  final Dio _dio = ApiClient.instance;

  Future<Map<String, dynamic>> getSellerOverview() async {
    final response = await _dio.get(ApiConstants.sellerAnalyticsOverview);
    return (response.data['data'] as Map<String, dynamic>?) ?? {};
  }

  Future<List<dynamic>> getSellerRevenueTrend(int days) async {
    final response = await _dio.get(ApiConstants.sellerAnalyticsRevenue, queryParameters: {'days': days});
    return (response.data['data'] as List<dynamic>?) ?? [];
  }
}
