import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';

class ApiOrderService {
  ApiOrderService._();
  static final ApiOrderService instance = ApiOrderService._();

  final Dio _dio = ApiClient.instance;

  Future<OrderModel> createOrder({
    required List<Map<String, dynamic>> items,
    Map<String, dynamic>? shippingAddressSnapshot,
    String? streamId,
    String? notes,
  }) async {
    final response = await _dio.post(ApiConstants.orders, data: {
      'items': items,
      'shippingAddressSnapshot': ?shippingAddressSnapshot,
      'streamId': ?streamId,
      'notes': ?notes,
    });
    return OrderModel.fromJson(response.data['data']['order'] as Map<String, dynamic>);
  }

  Future<List<OrderModel>> getMyOrders({String? status, int page = 1}) async {
    final response = await _dio.get(ApiConstants.myOrders, queryParameters: {
      'page': page,
      'limit': 20,
      'status': ?status,
    });
    final list = response.data['data']['orders'] as List;
    return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<OrderModel>> getSellerOrders({String? status, int page = 1}) async {
    final response = await _dio.get(ApiConstants.sellerOrders, queryParameters: {
      'page': page,
      'limit': 20,
      'status': ?status,
    });
    final list = response.data['data']['orders'] as List;
    return list.map((e) => OrderModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderModel> getOrder(String orderId) async {
    final response = await _dio.get(ApiConstants.orderDetail(orderId));
    return OrderModel.fromJson(response.data['data']['order'] as Map<String, dynamic>);
  }

  Future<OrderModel> updateStatus(String orderId, String status, {String? trackingNumber, String? trackingCarrier}) async {
    final response = await _dio.patch(ApiConstants.updateOrderStatus(orderId), data: {
      'status': status,
      'trackingNumber': ?trackingNumber,
      'trackingCarrier': ?trackingCarrier,
    });
    return OrderModel.fromJson(response.data['data']['order'] as Map<String, dynamic>);
  }

  Future<OrderModel> cancelOrder(String orderId, {String? cancelReason}) async {
    final response = await _dio.post(ApiConstants.cancelOrder(orderId), data: {
      'cancelReason': ?cancelReason,
    });
    return OrderModel.fromJson(response.data['data']['order'] as Map<String, dynamic>);
  }

  /// Buyer confirms receipt of a delivered order → marks it completed.
  Future<OrderModel> completeOrder(String orderId) async {
    final response = await _dio.post(ApiConstants.completeOrder(orderId));
    return OrderModel.fromJson(response.data['data']['order'] as Map<String, dynamic>);
  }

  /// Sets the shipping address on a pending order and recomputes shipping + tax.
  Future<OrderModel> setAddress(String orderId, Map<String, dynamic> address) async {
    final response = await _dio.patch(
      ApiConstants.orderAddress(orderId),
      data: {'shippingAddressSnapshot': address},
    );
    return OrderModel.fromJson(response.data['data']['order'] as Map<String, dynamic>);
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
