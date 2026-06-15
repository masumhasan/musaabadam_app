import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musaab_adam/core/services/api_upload_service.dart';
import 'package:musaab_adam/core/services/category_service.dart';
import 'package:musaab_adam/core/services/product_service.dart';
import 'package:musaab_adam/data/models/category/category_model.dart';

class CreateProductController extends GetxController {
  // ─── Form: Core ───────────────────────────────────────────────────────────
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  // ─── Form: Listing Type (0=Buy It Now, 1=Auction, 2=Giveaway) ────────────
  final RxInt selectedListingType = 0.obs;

  // ─── Form: Quantity ────────────────────────────────────────────────────────
  final RxInt quantity = 1.obs;

  // ─── Form: Pricing ────────────────────────────────────────────────────────
  final TextEditingController priceController = TextEditingController();
  final TextEditingController startingPriceController = TextEditingController();
  final TextEditingController auctionEndDateController = TextEditingController();

  // ─── Form: Category & Condition ──────────────────────────────────────────
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool categoriesLoading = false.obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);
  final RxString selectedCondition = 'new'.obs;

  static const List<String> conditions = ['new', 'like_new', 'excellent', 'good', 'fair'];
  static const List<String> conditionLabels = ['New', 'Like New', 'Excellent', 'Good', 'Fair'];

  // ─── Form: Options ────────────────────────────────────────────────────────
  final RxBool isFlashSale = false.obs;
  final RxBool acceptOffers = false.obs;
  final RxBool reserveForLive = false.obs;
  final RxBool isHazardous = false.obs;

  // ─── Form: Optional ───────────────────────────────────────────────────────
  final TextEditingController costController = TextEditingController();
  final TextEditingController skuController = TextEditingController();

  // ─── Auction date ─────────────────────────────────────────────────────────
  final Rx<DateTime?> auctionEndDateTime = Rx<DateTime?>(null);

  // ─── Images ───────────────────────────────────────────────────────────────
  static const int maxImages = 8;
  final RxList<File> pickedImages = <File>[].obs;
  final RxBool isUploading = false.obs;

  // ─── Loading ──────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  void onClose() {
    titleController.dispose();
    descController.dispose();
    priceController.dispose();
    startingPriceController.dispose();
    auctionEndDateController.dispose();
    costController.dispose();
    skuController.dispose();
    super.onClose();
  }

  Future<void> loadCategories() async {
    categoriesLoading.value = true;
    try {
      final result = await CategoryService.instance.getTopLevelCategories();
      categories.assignAll(result);
    } catch (_) {}
    finally {
      categoriesLoading.value = false;
    }
  }

  Future<void> pickImages() async {
    final remaining = maxImages - pickedImages.length;
    if (remaining <= 0) return;

    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(limit: remaining);
    if (picked.isEmpty) return;

    pickedImages.addAll(picked.map((xf) => File(xf.path)));
  }

  void removeImage(int index) {
    if (index >= 0 && index < pickedImages.length) {
      pickedImages.removeAt(index);
    }
  }

  String get listingTypeString {
    switch (selectedListingType.value) {
      case 1: return 'auction';
      case 2: return 'giveaway';
      default: return 'buy_it_now';
    }
  }

  bool _validate(bool publishNow) {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter a product title.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (descController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter a product description.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (selectedCategory.value == null) {
      Get.snackbar('Required', 'Please select a category.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (listingTypeString == 'buy_it_now') {
      final p = double.tryParse(priceController.text.trim());
      if (p == null || p <= 0) {
        Get.snackbar('Required', 'Please enter a valid price for Buy It Now.', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    }
    if (listingTypeString == 'auction') {
      final sp = double.tryParse(startingPriceController.text.trim());
      if (sp == null || sp <= 0) {
        Get.snackbar('Required', 'Please enter a valid starting price for auction.', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
      if (auctionEndDateTime.value == null || auctionEndDateTime.value!.isBefore(DateTime.now())) {
        Get.snackbar('Required', 'Please pick an auction end date/time in the future.', snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    }
    return true;
  }

  Future<void> submitProduct({required bool publishNow}) async {
    if (isLoading.value) return;
    if (!_validate(publishNow)) return;

    isLoading.value = true;
    try {
      // Upload images to S3 first
      final imageUrls = <String>[];
      if (pickedImages.isNotEmpty) {
        isUploading.value = true;
        for (final file in pickedImages) {
          final url = await ApiUploadService.instance.uploadFile(
            file: file,
            folder: 'product',
            contentType: _mimeType(file.path),
          );
          imageUrls.add(url);
        }
        isUploading.value = false;
      }

      await ProductService.instance.createProduct(
        title: titleController.text.trim(),
        description: descController.text.trim(),
        category: selectedCategory.value!.name,
        condition: selectedCondition.value,
        listingType: listingTypeString,
        quantity: quantity.value,
        price: listingTypeString == 'buy_it_now'
            ? double.tryParse(priceController.text.trim())
            : null,
        startingPrice: listingTypeString == 'auction'
            ? double.tryParse(startingPriceController.text.trim())
            : null,
        auctionEndsAt: auctionEndDateTime.value,
        flashSale: isFlashSale.value,
        acceptOffers: acceptOffers.value,
        reserveForLive: reserveForLive.value,
        hazardousMaterials: isHazardous.value,
        sku: skuController.text.trim().isEmpty ? null : skuController.text.trim(),
        costPerItem: costController.text.trim().isEmpty
            ? null
            : double.tryParse(costController.text.trim()),
        images: imageUrls,
        publishNow: publishNow,
      );

      Get.back();
      Get.snackbar(
        publishNow ? 'Product Published!' : 'Draft Saved',
        publishNow ? 'Your listing is now live.' : 'You can publish it from your inventory.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } on DioException catch (e) {
      isUploading.value = false;
      Get.snackbar('Error', ProductService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickAuctionEndDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;

    if (!context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    auctionEndDateTime.value = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    auctionEndDateController.text =
        '${date.day}/${date.month}/${date.year} ${time.format(context)}';
  }

  static String _mimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png': return 'image/png';
      case 'webp': return 'image/webp';
      case 'gif': return 'image/gif';
      default: return 'image/jpeg';
    }
  }
}
