import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/product_service.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class SellerInventoryController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt totalProducts = 0.obs;

  static const List<String?> _tabStatuses = ['active', 'draft', 'inactive'];

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  String? get _currentStatus => _tabStatuses[selectedTabIndex.value];

  void selectTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
    loadProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    try {
      final result = await ProductService.instance.getInventory(status: _currentStatus);
      products.assignAll(result.products);
      totalProducts.value = result.total;
    } on DioException catch (e) {
      Get.snackbar('Error', ProductService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  List<ProductModel> get filteredProducts {
    final q = searchQuery.value.toLowerCase().trim();
    if (q.isEmpty) return products;
    return products.where((p) => p.title.toLowerCase().contains(q)).toList();
  }

  Future<void> publishProduct(String productId) async {
    try {
      await ProductService.instance.publishProduct(productId);
      await loadProducts();
      Get.snackbar('Published', 'Product is now live.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ProductService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deactivateProduct(String productId) async {
    try {
      await ProductService.instance.deactivateProduct(productId);
      await loadProducts();
      Get.snackbar('Deactivated', 'Product moved to inactive.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ProductService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void pinProductForAuction(ProductModel product) {
    Get.toNamed(AppRoutes.startAuctionScreen, arguments: product);
  }
}
