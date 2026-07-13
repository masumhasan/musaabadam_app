import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_payment_service.dart';
import 'package:musaab_adam/data/models/payment/payment_method_model.dart';

class PaymentMethodsController extends GetxController {
  final RxList<PaymentMethodModel> methods = <PaymentMethodModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMethods();
  }

  Future<void> loadMethods() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final list = await ApiPaymentService.instance.listMethods();
      methods.assignAll(list);
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMethod(String id) async {
    try {
      await ApiPaymentService.instance.deleteMethod(id);
      methods.removeWhere((m) => m.id == id);
      // Re-load to sync potential default-change state from server side
      await loadMethods();
      Get.snackbar('Success', 'Payment method removed successfully.',
          snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiPaymentService.extractError(e),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> setDefault(String id) async {
    try {
      isLoading.value = true;
      await ApiPaymentService.instance.setDefaultMethod(id);
      await loadMethods();
      Get.snackbar('Success', 'Default payment method updated.',
          snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiPaymentService.extractError(e),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
