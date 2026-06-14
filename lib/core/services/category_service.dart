import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/category/category_model.dart';

class CategoryService {
  CategoryService._();
  static final CategoryService instance = CategoryService._();

  final Dio _dio = ApiClient.instance;

  Future<List<CategoryModel>> getTopLevelCategories() async {
    final response = await _dio.get(ApiConstants.categories);
    final list = response.data['data'] as List;
    return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<CategoryModel>> getSubcategories(String parentId) async {
    final response = await _dio.get(
      ApiConstants.categories,
      queryParameters: {'parentId': parentId},
    );
    final list = response.data['data'] as List;
    return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
      if (data is Map && data['errors'] is List) {
        final errors = data['errors'] as List;
        if (errors.isNotEmpty) {
          return (errors.first as Map)['message'] as String? ?? 'Unknown error';
        }
      }
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
