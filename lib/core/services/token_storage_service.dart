import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/auth/user_model.dart';

class TokenStorageService {
  TokenStorageService._();
  static final TokenStorageService instance = TokenStorageService._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await Future.wait([
      _storage.write(key: ApiConstants.accessTokenKey, value: accessToken),
      _storage.write(key: ApiConstants.refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: ApiConstants.accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: ApiConstants.refreshTokenKey);

  Future<void> saveUser(UserModel user) async {
    await _storage.write(key: ApiConstants.userKey, value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getCachedUser() async {
    final raw = await _storage.read(key: ApiConstants.userKey);
    if (raw == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: ApiConstants.accessTokenKey),
      _storage.delete(key: ApiConstants.refreshTokenKey),
      _storage.delete(key: ApiConstants.userKey),
    ]);
  }

  Future<bool> hasValidSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
