import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_payment_service.dart';
import 'package:musaab_adam/data/models/payment/wallet_model.dart';

class WalletController extends GetxController {
  final ApiPaymentService _apiService = ApiPaymentService.instance;

  final RxBool isLoading = false.obs;
  final RxBool isLedgerLoading = false.obs;
  final Rx<WalletModel?> wallet = Rx<WalletModel?>(null);
  final RxList<Map<String, dynamic>> ledgerEntries = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshWallet();
  }

  Future<void> refreshWallet() async {
    isLoading.value = true;
    try {
      final res = await _apiService.getWallet();
      wallet.value = res;
      await fetchLedger();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch wallet details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLedger() async {
    isLedgerLoading.value = true;
    try {
      final entries = await _apiService.getWalletLedger(page: 1, limit: 50);
      ledgerEntries.assignAll(entries);
    } catch (e) {
      // Optional fallback if ledger fetch fails
    } finally {
      isLedgerLoading.value = false;
    }
  }

  Future<void> cashOut() async {
    final availableAmt = wallet.value?.available ?? 0.0;
    if (availableAmt < 10.0) {
      Get.snackbar('Minimum Cash Out', 'You must have at least £10.00 available to cash out.');
      return;
    }

    isLoading.value = true;
    try {
      await _apiService.requestPayout(amount: availableAmt);
      Get.snackbar('Success', 'Cash out request submitted successfully! Funds will process shortly.',
          snackPosition: SnackPosition.BOTTOM);
      await refreshWallet();
    } catch (e) {
      Get.snackbar('Error', 'Failed to process cash out request: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
