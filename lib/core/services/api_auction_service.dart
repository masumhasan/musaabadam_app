import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/auction/bid_model.dart';

class ApiAuctionService {
  ApiAuctionService._();
  static final ApiAuctionService instance = ApiAuctionService._();

  final Dio _dio = ApiClient.instance;

  /// Seller starts a live auction on one of their products.
  Future<Map<String, dynamic>> startAuction({
    required String productId,
    String? streamId,
    int? durationMs,
    double? startingPrice,
    double? reservePrice,
    double? bidIncrement,
  }) async {
    final response = await _dio.post(ApiConstants.startAuction, data: {
      'productId': productId,
      'streamId': ?streamId,
      'durationMs': ?durationMs,
      'startingPrice': ?startingPrice,
      'reservePrice': ?reservePrice,
      'bidIncrement': ?bidIncrement,
    });
    return Map<String, dynamic>.from(response.data['data']['auction'] as Map);
  }

  Future<Map<String, dynamic>> pauseAuction(String productId) async {
    final r = await _dio.post(ApiConstants.pauseAuction(productId));
    return Map<String, dynamic>.from(r.data['data']['auction'] as Map);
  }

  Future<Map<String, dynamic>> resumeAuction(String productId) async {
    final r = await _dio.post(ApiConstants.resumeAuction(productId));
    return Map<String, dynamic>.from(r.data['data']['auction'] as Map);
  }

  Future<Map<String, dynamic>> cancelAuction(String productId) async {
    final r = await _dio.post(ApiConstants.cancelAuction(productId));
    return Map<String, dynamic>.from(r.data['data']['auction'] as Map);
  }

  /// Seller manually closes an auction early.
  Future<Map<String, dynamic>?> closeAuction(String productId) async {
    final response = await _dio.post(ApiConstants.closeAuction(productId));
    final result = response.data['data']['result'];
    return result == null ? null : Map<String, dynamic>.from(result as Map);
  }

  /// REST fallback to place a bid (primary path is the socket).
  Future<Map<String, dynamic>> placeBid({
    required String productId,
    required double amount,
    String? streamId,
    double? maxAmount,
    bool isAutoBid = false,
  }) async {
    final response = await _dio.post(ApiConstants.auctionBids(productId), data: {
      'amount': amount,
      'streamId': ?streamId,
      if (isAutoBid) 'isAutoBid': true,
      'maxAmount': ?maxAmount,
    });
    return Map<String, dynamic>.from(response.data['data']['bid'] as Map);
  }

  Future<List<BidModel>> getBidHistory(String productId, {int limit = 30}) async {
    final response = await _dio.get(
      ApiConstants.auctionBids(productId),
      queryParameters: {'limit': limit},
    );
    final list = response.data['data']['bids'] as List;
    return list.map((e) => BidModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<BidModel>> getMyBids({int page = 1}) async {
    final response = await _dio.get(ApiConstants.myBids, queryParameters: {
      'page': page,
      'limit': 20,
    });
    final list = response.data['data']['bids'] as List;
    return list.map((e) => BidModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
