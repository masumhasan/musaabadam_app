import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/data/models/social/public_profile_model.dart';

class SocialService {
  SocialService._();
  static final SocialService instance = SocialService._();

  final Dio _dio = ApiClient.instance;

  Future<PublicProfileModel> getPublicProfile(String userId) async {
    final response = await _dio.get(ApiConstants.userProfile(userId));
    return PublicProfileModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> followUser(String userId) async {
    await _dio.post(ApiConstants.followUser(userId));
  }

  Future<void> unfollowUser(String userId) async {
    await _dio.delete(ApiConstants.followUser(userId));
  }

  Future<void> blockUser(String userId) async {
    await _dio.post(ApiConstants.blockUser(userId));
  }

  Future<void> unblockUser(String userId) async {
    await _dio.delete(ApiConstants.blockUser(userId));
  }

  Future<Map<String, dynamic>> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.userFollowers(userId),
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      ApiConstants.userFollowing(userId),
      queryParameters: {'page': page, 'limit': limit},
    );
    return response.data['data'] as Map<String, dynamic>;
  }

  static String extractError(DioException e) => ApiAuthService.extractError(e);
}
