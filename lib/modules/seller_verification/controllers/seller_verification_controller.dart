import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/category_service.dart';
import 'package:musaab_adam/core/services/seller_service.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/data/models/category/category_model.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class SellerVerificationController extends GetxController {
  // ─── Step 1: Category ─────────────────────────────────────────────────────
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool categoriesLoading = false.obs;
  final RxSet<String> selectedCategoryIds = <String>{}.obs;

  // ─── Step 2: Subcategory ──────────────────────────────────────────────────
  final RxList<CategoryModel> subcategories = <CategoryModel>[].obs;
  final RxBool subcategoriesLoading = false.obs;
  final RxSet<String> selectedSubcategoryIds = <String>{}.obs;

  // ─── Step 3: Seller Type (0 = starting out, 1 = actively selling) ─────────
  final RxInt sellerTypeIndex = (-1).obs;

  // ─── Step 4: Business Address ─────────────────────────────────────────────
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController zipController = TextEditingController();
  final RxString selectedCountry = 'USA'.obs;

  // ─── Step 5: Average Earning ──────────────────────────────────────────────
  final RxBool isDropdownExpanded = false.obs;
  final RxString selectedRange = AppStrings.select.obs;

  // ─── Loading ──────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  void onClose() {
    nameController.dispose();
    addressController.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    zipController.dispose();
    super.onClose();
  }

  // ─── Category loading ─────────────────────────────────────────────────────
  Future<void> loadCategories() async {
    categoriesLoading.value = true;
    try {
      final result = await CategoryService.instance.getTopLevelCategories();
      categories.assignAll(result);
    } catch (_) {
      // retain empty list — screen will show empty state
    } finally {
      categoriesLoading.value = false;
    }
  }

  // ─── Subcategory loading ──────────────────────────────────────────────────
  Future<void> loadSubcategories() async {
    if (selectedCategoryIds.isEmpty) {
      subcategories.clear();
      selectedSubcategoryIds.clear();
      return;
    }
    subcategoriesLoading.value = true;
    try {
      final futures = selectedCategoryIds
          .map((id) => CategoryService.instance.getSubcategories(id));
      final results = await Future.wait(futures);
      final merged = results.expand((list) => list).toList();
      subcategories.assignAll(merged);
      // Remove previously selected subcategories that no longer belong
      final validIds = merged.map((c) => c.id).toSet();
      selectedSubcategoryIds.removeWhere((id) => !validIds.contains(id));
    } catch (_) {
      subcategories.clear();
    } finally {
      subcategoriesLoading.value = false;
    }
  }

  // ─── Category toggle ──────────────────────────────────────────────────────
  void toggleCategory(String id, bool isSelected) {
    if (isSelected) {
      selectedCategoryIds.add(id);
    } else {
      selectedCategoryIds.remove(id);
    }
  }

  // ─── Subcategory toggle ───────────────────────────────────────────────────
  void toggleSubcategory(String id) {
    if (selectedSubcategoryIds.contains(id)) {
      selectedSubcategoryIds.remove(id);
    } else {
      selectedSubcategoryIds.add(id);
    }
  }

  // ─── Submit Application ───────────────────────────────────────────────────
  Future<void> submitApplication() async {
    if (isLoading.value) return;

    if (selectedRange.value == AppStrings.select) {
      Get.snackbar(
        'Required',
        'Please select your average monthly earnings.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final primaryCategory = selectedCategoryIds.isNotEmpty
          ? categories.firstWhereOrNull((c) => c.id == selectedCategoryIds.first)?.name ?? 'General'
          : 'General';

      final subcategoryNames = selectedSubcategoryIds
          .map((id) => subcategories.firstWhereOrNull((c) => c.id == id)?.name)
          .whereType<String>()
          .toList();

      await SellerService.instance.applyAsSeller(
        primaryCategory: primaryCategory,
        subcategories: subcategoryNames,
        sellerType: sellerTypeIndex.value == 0 ? 'starting' : 'active',
        businessAddress: {
          'fullName': nameController.text.trim(),
          'line1': addressController.text.trim(),
          'line2': address2Controller.text.trim(),
          'city': cityController.text.trim(),
          'state': stateController.text.trim(),
          'postalCode': zipController.text.trim(),
          'country': selectedCountry.value,
        },
        averageEarningRange: selectedRange.value,
      );

      final user = await ApiAuthService.instance.getMyProfile();
      await TokenStorageService.instance.saveUser(user);
      Get.find<AuthController>().currentUser.value = user;

      Get.offAllNamed(AppRoutes.mainScreen);
      Get.snackbar(
        'Application Submitted!',
        "Your seller application is under review. We'll notify you once approved.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        SellerService.extractError(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
