import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/address/address_model.dart';

class ApiUserService {
  ApiUserService._();
  static final ApiUserService instance = ApiUserService._();

  final Dio _dio = ApiClient.instance;

  // ─── Addresses ────────────────────────────────────────────────────────────

  Future<List<AddressModel>> getAddresses() async {
    final response = await _dio.get(ApiConstants.addresses);
    final list = response.data['data'] as List<dynamic>;
    return list.map((a) => AddressModel.fromJson(a as Map<String, dynamic>)).toList();
  }

  Future<List<AddressModel>> addAddress(Map<String, dynamic> body) async {
    final response = await _dio.post(ApiConstants.addresses, data: body);
    final list = response.data['data'] as List<dynamic>;
    return list.map((a) => AddressModel.fromJson(a as Map<String, dynamic>)).toList();
  }

  Future<List<AddressModel>> updateAddress(String id, Map<String, dynamic> body) async {
    final response = await _dio.put(ApiConstants.addressById(id), data: body);
    final list = response.data['data'] as List<dynamic>;
    return list.map((a) => AddressModel.fromJson(a as Map<String, dynamic>)).toList();
  }

  Future<List<AddressModel>> deleteAddress(String id) async {
    final response = await _dio.delete(ApiConstants.addressById(id));
    final list = response.data['data'] as List<dynamic>;
    return list.map((a) => AddressModel.fromJson(a as Map<String, dynamic>)).toList();
  }

  // ─── Preferences ──────────────────────────────────────────────────────────

  Future<void> updateAppPreferences(Map<String, dynamic> body) async {
    await _dio.put(ApiConstants.appPreferences, data: body);
  }
}
