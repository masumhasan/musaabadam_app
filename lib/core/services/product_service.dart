import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';

class ProductInventoryResult {
  final List<ProductModel> products;
  final int total;
  final int page;
  final int pages;

  const ProductInventoryResult({
    required this.products,
    required this.total,
    required this.page,
    required this.pages,
  });
}

class ProductService {
  ProductService._();
  static final ProductService instance = ProductService._();

  final Dio _dio = ApiClient.instance;

  Future<ProductModel> createProduct({
    required String title,
    required String description,
    required String category,
    required String condition,
    required String listingType,
    required int quantity,
    double? price,
    double? startingPrice,
    double? reservePrice,
    DateTime? auctionEndsAt,
    bool flashSale = false,
    bool acceptOffers = false,
    double maxDiscount = 0,
    bool reserveForLive = false,
    bool hazardousMaterials = false,
    String? sku,
    double? costPerItem,
    List<String> tags = const [],
    List<String> images = const [],
    bool publishNow = false,
  }) async {
    final response = await _dio.post(ApiConstants.products, data: {
      'title': title,
      'description': description,
      'category': category,
      'condition': condition,
      'listingType': listingType,
      'quantity': quantity,
      'price': ?price,
      'startingPrice': ?startingPrice,
      'reservePrice': ?reservePrice,
      'auctionEndsAt': ?auctionEndsAt?.toIso8601String(),
      'flashSale': flashSale,
      'acceptOffers': acceptOffers,
      'maxDiscount': maxDiscount,
      'reserveForLive': reserveForLive,
      'hazardousMaterials': hazardousMaterials,
      'sku': ?sku,
      'costPerItem': ?costPerItem,
      'tags': tags,
      'images': images,
      'publishNow': publishNow,
    });
    return ProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ProductInventoryResult> getInventory({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(ApiConstants.productInventory, queryParameters: {
      'page': page,
      'limit': limit,
      'status': ?status,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    final list = data['products'] as List;
    final pagination = data['pagination'] as Map<String, dynamic>;
    return ProductInventoryResult(
      products: list.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList(),
      total: pagination['total'] as int? ?? 0,
      page: pagination['page'] as int? ?? page,
      pages: pagination['pages'] as int? ?? 1,
    );
  }

  Future<ProductModel> publishProduct(String productId) async {
    final response = await _dio.patch(ApiConstants.publishProduct(productId));
    return ProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<ProductModel> deactivateProduct(String productId) async {
    final response = await _dio.patch(ApiConstants.deactivateProduct(productId));
    return ProductModel.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  Future<void> deleteProduct(String productId) async {
    await _dio.delete(ApiConstants.product(productId));
  }

  /// Starts a flash sale on a buy-now product.
  Future<ProductModel> startFlashSale(
    String productId, {
    required double flashSalePrice,
    int? durationMinutes,
    int? stock,
  }) async {
    final response = await _dio.post(ApiConstants.flashSale(productId), data: {
      'flashSalePrice': flashSalePrice,
      'durationMinutes': ?durationMinutes,
      'stock': ?stock,
    });
    return ProductModel.fromJson(response.data['data']['product'] as Map<String, dynamic>);
  }

  Future<ProductModel> endFlashSale(String productId) async {
    final response = await _dio.delete(ApiConstants.flashSale(productId));
    return ProductModel.fromJson(response.data['data']['product'] as Map<String, dynamic>);
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
