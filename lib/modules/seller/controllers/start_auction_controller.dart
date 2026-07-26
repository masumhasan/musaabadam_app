import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musaab_adam/core/services/api_upload_service.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class StartAuctionController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxString thumbnailUrl = ''.obs;
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
    descriptionController.dispose();
    super.onClose();
  }

  Future<void> pickThumbnail() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    isLoading.value = true;
    try {
      final url = await ApiUploadService.instance.uploadFile(
        file: File(image.path),
        folder: 'stream_thumbnail',
        contentType: 'image/jpeg',
      );
      thumbnailUrl.value = url;
      Get.snackbar('Image Uploaded', 'Thumbnail added successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Upload Failed', 'Failed to upload thumbnail',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startAuction() async {
    if (isLoading.value) return;

    final title = titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Required', 'Please enter a title for the auction stream.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final description = descriptionController.text.trim();
    final thumbnail = thumbnailUrl.value.trim();

    isLoading.value = true;
    try {
      final result = await StreamService.instance.createAuctionStream(
        productId: product.id,
        title: title,
        description: description.isNotEmpty ? description : null,
        thumbnailUrl: thumbnail.isNotEmpty ? thumbnail : null,
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
