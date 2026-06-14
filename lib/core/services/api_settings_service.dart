import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

class ApiSettingsService {
  ApiSettingsService._();
  static final ApiSettingsService instance = ApiSettingsService._();

  final Dio _dio = ApiClient.instance;

  Future<String> getPrivacyPolicy() async {
    final response = await _dio.get(ApiConstants.legalPrivacyPolicy);
    return (response.data['data']['content'] as String?) ?? '';
  }

  Future<String> getTerms() async {
    final response = await _dio.get(ApiConstants.legalTerms);
    return (response.data['data']['content'] as String?) ?? '';
  }
}
