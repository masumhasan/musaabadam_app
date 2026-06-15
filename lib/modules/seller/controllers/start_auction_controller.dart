import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class StartAuctionController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final RxBool isLoading = false.obs;

  late final ProductModel product;

  @override
  void onInit() {
    super.onInit();
    product = Get.arguments as ProductModel;
    titleController.text = product.title;
  }

  @override
  void onClose() {
    titleController.dispose();
    super.onClose();
  }

  Future<void> startAuction() async {
    if (isLoading.value) return;

    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Required', 'Please enter a title for the auction stream.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    try {
      final result = await StreamService.instance.createAuctionStream(
        productId: product.id,
        title: title,
      );

      // Navigate to livestream screen with the stream ID so the host can go live
      Get.toNamed(AppRoutes.livestreamScreen, arguments: result.stream.id);
    } on DioException catch (e) {
      Get.snackbar('Error', StreamService.extractError(e),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
