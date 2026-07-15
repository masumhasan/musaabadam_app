import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_tip_service.dart';

class SellerTipsController extends GetxController {
  final RxList<Map<String, dynamic>> tips = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadTips();
  }

  Future<void> loadTips() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final list = await ApiTipService.instance.getReceivedTips();
      tips.assignAll(list);
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  double get totalTipsAmount {
    return tips.fold(0.0, (sum, item) {
      final amt = item['amount'] ?? 0.0;
      return sum + (amt is num ? amt.toDouble() : 0.0);
    });
  }
}
