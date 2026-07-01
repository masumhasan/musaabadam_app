import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';

/// Unified search results across sellers, products, and live shows.
class SearchResults {
  final List<Map<String, dynamic>> sellers;
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> streams;

  const SearchResults({this.sellers = const [], this.products = const [], this.streams = const []});

  bool get isEmpty => sellers.isEmpty && products.isEmpty && streams.isEmpty;

  factory SearchResults.fromJson(Map<String, dynamic> j) => SearchResults(
        sellers: _list(j['sellers']),
        products: _list(j['products']),
        streams: _list(j['streams']),
      );

  static List<Map<String, dynamic>> _list(dynamic v) =>
      (v as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
}

class ApiSearchService {
  ApiSearchService._();
  static final ApiSearchService instance = ApiSearchService._();

  final Dio _dio = ApiClient.instance;

  Future<SearchResults> search(String query, {String type = 'all', String? filter}) async {
    final response = await _dio.get(ApiConstants.search, queryParameters: {
      'q': query,
      'type': type,
      'filter': ?filter,
    });
    return SearchResults.fromJson(Map<String, dynamic>.from(response.data['data'] as Map));
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
