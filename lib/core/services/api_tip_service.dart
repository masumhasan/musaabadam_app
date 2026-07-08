import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

class ApiTipService {
  ApiTipService._();
  static final ApiTipService instance = ApiTipService._();

  final Dio _dio = ApiClient.instance;

  Future<Map<String, dynamic>?> sendTip({
    required String sellerId,
    String? streamId,
    required double amount,
    required String paymentMethodId,
    String? message,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.baseUrl}/payments/tips',
        data: {
          'sellerId': sellerId,
          'streamId': streamId,
          'amount': amount,
          'paymentMethodId': paymentMethodId,
          'message': message,
        },
      );
      return Map<String, dynamic>.from(response.data['data'] as Map);
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getReceivedTips() async {
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/payments/tips/received');
      final list = response.data['data']['tips'] as List;
      return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (e) {
      return [];
    }
  }
}
