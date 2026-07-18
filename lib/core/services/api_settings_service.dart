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

  Future<List<Map<String, String>>> getFaqs(String type) async {
    final response = await _dio.get(ApiConstants.faqs, queryParameters: {'type': type});
    final list = response.data['data']['faqs'] as List;
    return list.map((e) => {
      'question': (e['question'] as String?) ?? '',
      'answer': (e['answer'] as String?) ?? '',
    }).toList();
  }

  Future<Map<String, dynamic>> getSellerPremierShopStatus() async {
    final response = await _dio.get(ApiConstants.sellerPremierShopStatus);
    return (response.data['data'] as Map<String, dynamic>?) ?? {};
  }
}
