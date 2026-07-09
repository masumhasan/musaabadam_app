import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_shipping_service.dart';
import 'package:musaab_adam/data/models/shipping/shipping_profile_model.dart';

class ShippingProfilesController extends GetxController {
  final RxList<ShippingProfileModel> profiles = <ShippingProfileModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    isLoading.value = true;
    try {
      final data = await ApiShippingService.instance.listProfiles();
      profiles.assignAll(data);
    } catch (_) {
      // Ignore or handle
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProfile(String id) async {
    try {
      await ApiShippingService.instance.deleteProfile(id);
      profiles.removeWhere((p) => p.id == id);
      Get.snackbar('Success', 'Profile deleted', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiShippingService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }
}
