import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

class ApiGiveawayService {
  ApiGiveawayService._();
  static final ApiGiveawayService instance = ApiGiveawayService._();

  final Dio _dio = ApiClient.instance;

  Future<Map<String, dynamic>> create({
    required String title,
    String? streamId,
    String? productId,
    String restriction = 'everyone',
  }) async {
    final response = await _dio.post(ApiConstants.giveaways, data: {
      'title': title,
      'streamId': ?streamId,
      'productId': ?productId,
      'restriction': restriction,
    });
    return Map<String, dynamic>.from(response.data['data']['giveaway'] as Map);
  }

  Future<Map<String, dynamic>> join(String giveawayId) async {
    final response = await _dio.post(ApiConstants.joinGiveaway(giveawayId));
    return Map<String, dynamic>.from(response.data['data']['giveaway'] as Map);
  }

  Future<Map<String, dynamic>> draw(String giveawayId) async {
    final response = await _dio.post(ApiConstants.drawGiveaway(giveawayId));
    return Map<String, dynamic>.from(response.data['data']['result'] as Map);
  }

  Future<void> cancel(String giveawayId) async {
    await _dio.post(ApiConstants.cancelGiveaway(giveawayId));
  }

  Future<List<Map<String, dynamic>>> forStream(String streamId) async {
    final response = await _dio.get(ApiConstants.streamGiveaways(streamId));
    final list = response.data['data']['giveaways'] as List;
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
