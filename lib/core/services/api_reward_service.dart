import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

class ApiRewardService {
  ApiRewardService._();
  static final ApiRewardService instance = ApiRewardService._();

  final Dio _dio = ApiClient.instance;

  Future<List<Map<String, dynamic>>> getMyRewards() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/payments/rewards');
      final list = response.data['data']['rewards'] as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>?> claimChallenge(String challengeId) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/payments/rewards/claim-challenge',
        data: {'challengeId': challengeId},
      );
      return Map<String, dynamic>.from(response.data['data']['reward'] as Map);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> adminListRewards() async {
    final response = await _dio.get('${ApiConstants.baseUrl}/payments/rewards/admin/list');
    final list = response.data['data']['rewards'] as List;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> adminCreateReward({
    required String username,
    required String title,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required int expiresDays,
  }) async {
    final response = await _dio.post(
      '${ApiConstants.baseUrl}/payments/rewards/admin/create',
      data: {
        'username': username,
        'title': title,
        'discountType': discountType,
        'discountValue': discountValue,
        'minOrderValue': minOrderValue,
        'expiresDays': expiresDays,
      },
    );
    return Map<String, dynamic>.from(response.data['data']['reward'] as Map);
  }

  Future<void> adminDeleteReward(String rewardId) async {
    await _dio.delete('${ApiConstants.baseUrl}/payments/rewards/admin/$rewardId');
  }
}
