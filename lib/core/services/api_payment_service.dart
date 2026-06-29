import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/payment/payment_method_model.dart';
import 'package:musaab_adam/data/models/payment/wallet_model.dart';

class ApiPaymentService {
  ApiPaymentService._();
  static final ApiPaymentService instance = ApiPaymentService._();

  final Dio _dio = ApiClient.instance;

  // ── Payment methods ─────────────────────────────────────────────────────────
  Future<List<PaymentMethodModel>> listMethods() async {
    final response = await _dio.get(ApiConstants.paymentMethods);
    final list = response.data['data']['methods'] as List;
    return list.map((e) => PaymentMethodModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<PaymentMethodModel> addMethod({
    Map<String, dynamic>? card,
    String? providerPaymentMethodId,
    bool makeDefault = false,
  }) async {
    final response = await _dio.post(ApiConstants.paymentMethods, data: {
      'card': ?card,
      'providerPaymentMethodId': ?providerPaymentMethodId,
      'makeDefault': makeDefault,
    });
    return PaymentMethodModel.fromJson(response.data['data']['method'] as Map<String, dynamic>);
  }

  Future<void> deleteMethod(String methodId) async {
    await _dio.delete(ApiConstants.paymentMethod(methodId));
  }

  // ── Checkout / escrow ───────────────────────────────────────────────────────
  /// Starts checkout for an order, returning the provider client secret.
  Future<String?> startCheckout(String orderId, {String? paymentMethodId}) async {
    final response = await _dio.post(ApiConstants.checkoutOrder(orderId), data: {
      'paymentMethodId': ?paymentMethodId,
    });
    return response.data['data']['clientSecret']?.toString();
  }

  /// Confirms payment server-side and moves funds into escrow.
  Future<Map<String, dynamic>> confirmPayment(String orderId, {String? paymentMethodId}) async {
    final response = await _dio.post(ApiConstants.confirmOrderPayment(orderId), data: {
      'paymentMethodId': ?paymentMethodId,
    });
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  // ── Wallet / payouts ──────────────────────────────────────────────────────--
  Future<WalletModel> getWallet() async {
    final response = await _dio.get(ApiConstants.wallet);
    return WalletModel.fromJson(response.data['data']['wallet'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> requestPayout({double? amount, String? destination}) async {
    final response = await _dio.post(ApiConstants.payouts, data: {
      'amount': ?amount,
      'destination': ?destination,
    });
    return Map<String, dynamic>.from(response.data['data']['payout'] as Map);
  }

  Future<List<Map<String, dynamic>>> listPayouts({int page = 1}) async {
    final response = await _dio.get(ApiConstants.payouts, queryParameters: {'page': page, 'limit': 20});
    final list = response.data['data']['payouts'] as List;
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
