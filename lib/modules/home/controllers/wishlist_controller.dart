import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_favorite_service.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';

class WishlistController extends GetxController {
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      products.assignAll(await ApiFavoriteService.instance.list());
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> remove(ProductModel product) async {
    try {
      await ApiFavoriteService.instance.toggle(product.id);
      products.removeWhere((p) => p.id == product.id);
    } on DioException catch (e) {
      Get.snackbar('Wishlist', ApiFavoriteService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
