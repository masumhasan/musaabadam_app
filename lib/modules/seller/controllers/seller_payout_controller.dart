import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_payment_service.dart';
import 'package:musaab_adam/data/models/payment/wallet_model.dart';

class SellerPayoutController extends GetxController {
  final Rx<WalletModel?> wallet = Rx(null);
  final RxList<Map<String, dynamic>> payouts = <Map<String, dynamic>>[].obs;
  final RxInt currentTab = 0.obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isRequesting = false.obs;

  double get available => wallet.value?.available ?? 0;
  double get pending => wallet.value?.pending ?? 0;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final results = await Future.wait([
        ApiPaymentService.instance.getWallet(),
        ApiPaymentService.instance.listPayouts(),
      ]);
      wallet.value = results[0] as WalletModel;
      payouts.assignAll(results[1] as List<Map<String, dynamic>>);
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> requestPayout() async {
    if (isRequesting.value) return;
    if (available <= 0) {
      Get.snackbar('No balance', 'You have no funds available for payout yet.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isRequesting.value = true;
    try {
      await ApiPaymentService.instance.requestPayout();
      await load();
      Get.snackbar('Payout requested', 'Your payout is being processed.',
          snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiPaymentService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isRequesting.value = false;
    }
  }
}
