import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/offer/offer_model.dart';

class ApiOfferService {
  ApiOfferService._();
  static final ApiOfferService instance = ApiOfferService._();

  final Dio _dio = ApiClient.instance;

  Future<OfferModel> createOffer({required String productId, required double amount}) async {
    final response = await _dio.post(ApiConstants.offers, data: {
      'productId': productId,
      'amount': amount,
    });
    return OfferModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<List<OfferModel>> getBuyerOffers({int page = 1}) async {
    final response = await _dio.get(ApiConstants.buyerOffers, queryParameters: {
      'page': page,
      'limit': 20,
    });
    final list = response.data['data']['offers'] as List;
    return list.map((e) => OfferModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<OfferModel>> getSellerOffers({int page = 1}) async {
    final response = await _dio.get(ApiConstants.sellerOffers, queryParameters: {
      'page': page,
      'limit': 20,
    });
    final list = response.data['data']['offers'] as List;
    return list.map((e) => OfferModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OfferModel> updateStatus(String offerId, String status) async {
    final response = await _dio.patch('/offers/$offerId/status', data: {'status': status});
    return OfferModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
