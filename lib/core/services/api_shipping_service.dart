import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/shipping/shipping_profile_model.dart';

class ApiShippingService {
  ApiShippingService._();
  static final ApiShippingService instance = ApiShippingService._();

  final Dio _dio = ApiClient.instance;

  // ── Profiles ─────────────────────────────────────────────────────────────────
  Future<List<ShippingProfileModel>> listProfiles() async {
    final response = await _dio.get(ApiConstants.shippingProfiles);
    final list = response.data['data']['profiles'] as List;
    return list.map((e) => ShippingProfileModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ShippingProfileModel> createProfile(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiConstants.shippingProfiles, data: body);
    return ShippingProfileModel.fromJson(response.data['data']['profile'] as Map<String, dynamic>);
  }

  Future<ShippingProfileModel> updateProfile(String id, Map<String, dynamic> body) async {
    final response = await _dio.patch(ApiConstants.shippingProfile(id), data: body);
    return ShippingProfileModel.fromJson(response.data['data']['profile'] as Map<String, dynamic>);
  }

  Future<void> deleteProfile(String id) async {
    await _dio.delete(ApiConstants.shippingProfile(id));
  }

  // ── Estimate ───────────────────────────────────────────────────────────────--
  Future<Map<String, dynamic>> estimate(String productId, {double? subtotal, bool? international}) async {
    final response = await _dio.get(ApiConstants.shippingEstimate(productId), queryParameters: {
      'subtotal': ?subtotal,
      'international': ?international,
    });
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  // ── Labels & tracking ────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> generateLabel(String orderId, {String? carrier}) async {
    final response = await _dio.post(ApiConstants.generateLabel(orderId), data: {'carrier': ?carrier});
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  Future<Map<String, dynamic>> track(String orderId) async {
    final response = await _dio.get(ApiConstants.trackOrder(orderId));
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
