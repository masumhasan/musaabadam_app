import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/auth/auth_response_model.dart';
import 'package:musaab_adam/data/models/auth/user_model.dart';

class ApiAuthService {
  ApiAuthService._();
  static final ApiAuthService instance = ApiAuthService._();

  final Dio _dio = ApiClient.instance;

  // ─── Auth Calls ────────────────────────────────────────────────────────────

  Future<({String email, String userId})> register({
    required String email,
    required String password,
    String? username,
    String? referralCode,
  }) async {
    final response = await _dio.post(ApiConstants.register, data: {
      'email': email,
      'password': password,
      'username': ?username,
      'referralCode': ?referralCode,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    return (email: data['email'] as String, userId: data['userId'] as String);
  }

  /// Fetches the current user's referral code + invite stats.
  Future<({String referralCode, int credit, int complete, int pending})> getReferralInfo() async {
    final response = await _dio.get(ApiConstants.referral);
    final data = response.data['data'] as Map<String, dynamic>;
    final stats = (data['stats'] as Map?) ?? const {};
    return (
      referralCode: data['referralCode']?.toString() ?? '',
      credit: (stats['credit'] as num?)?.toInt() ?? 0,
      complete: (stats['complete'] as num?)?.toInt() ?? 0,
      pending: (stats['pending'] as num?)?.toInt() ?? 0,
    );
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(ApiConstants.login, data: {
      'email': email,
      'password': password,
    });
    return AuthResponseModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post(ApiConstants.logout, data: {'refreshToken': refreshToken});
  }

  Future<AuthResponseModel> verifyEmailOtp({required String email, required String otp}) async {
    final response = await _dio.post(ApiConstants.verifyEmail, data: {'email': email, 'otp': otp});
    return AuthResponseModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> resendVerification(String email) async {
    await _dio.post(ApiConstants.resendVerification, data: {'email': email});
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post(ApiConstants.forgotPassword, data: {'email': email});
  }

  Future<void> resetPassword({required String resetToken, required String newPassword}) async {
    await _dio.post(ApiConstants.resetPassword, data: {
      'resetToken': resetToken,
      'newPassword': newPassword,
    });
  }

  // ─── User Profile ──────────────────────────────────────────────────────────

  Future<UserModel> getMyProfile() async {
    final response = await _dio.get(ApiConstants.myProfile);
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<UserModel> updateProfile({
    String? displayName,
    String? bio,
    String? location,
    String? avatarUrl,
  }) async {
    final response = await _dio.put(ApiConstants.myProfile, data: {
      'displayName': ?displayName,
      'bio': ?bio,
      'location': ?location,
      'avatarUrl': ?avatarUrl,
    });
    return UserModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ─── Change Email (authenticated) ─────────────────────────────────────────

  Future<void> initiateEmailChange({required String newEmail}) async {
    await _dio.post(ApiConstants.changeEmailInitiate, data: {'newEmail': newEmail});
  }

  Future<UserModel> verifyEmailChange({required String otp}) async {
    final response = await _dio.post(ApiConstants.changeEmailVerify, data: {'otp': otp});
    return UserModel.fromJson(response.data['data']['user'] as Map<String, dynamic>);
  }

  // ─── Change Password (authenticated) ──────────────────────────────────────

  Future<void> initiatePasswordChange({required String currentPassword, required String newPassword}) async {
    await _dio.post(ApiConstants.changePasswordInitiate, data: {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    });
  }

  Future<void> verifyPasswordChange({required String otp, required String newPassword}) async {
    await _dio.post(ApiConstants.changePasswordVerify, data: {
      'otp': otp,
      'newPassword': newPassword,
    });
  }

  Future<String> verifyResetOtp({required String email, required String otp}) async {
    final response = await _dio.post(ApiConstants.verifyResetOtp, data: {
      'email': email,
      'otp': otp,
    });
    return (response.data['data']['resetToken'] as String);
  }

  // ─── Error extraction helper ───────────────────────────────────────────────

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
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
