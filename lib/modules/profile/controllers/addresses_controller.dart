import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/api_user_service.dart';
import 'package:musaab_adam/data/models/address/address_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class AddressesController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  List<AddressModel> get shippingAddresses =>
      addresses.where((a) => a.type == 'shipping').toList();

  List<AddressModel> get pickupAddresses =>
      addresses.where((a) => a.type == 'pickup').toList();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> retry() => _load();

  Future<void> _load() async {
    hasError.value = false;
    isLoading.value = true;
    try {
      addresses.value = await ApiUserService.instance.getAddresses();
    } on DioException catch (e) {
      hasError.value = true;
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void addNew(String type) {
    Get.toNamed(AppRoutes.newAddressScreen, arguments: {'type': type});
  }

  void edit(AddressModel address) {
    Get.toNamed(AppRoutes.newAddressScreen, arguments: {'address': address});
  }

  Future<void> delete(AddressModel address) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete address?'),
        content: Text('Remove "${address.fullName}, ${address.line1}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Delete', style: TextStyle(color: Get.theme.colorScheme.error)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      addresses.value = await ApiUserService.instance.deleteAddress(address.id);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  void onAddressSaved(List<AddressModel> updated) {
    addresses.value = updated;
  }
}
