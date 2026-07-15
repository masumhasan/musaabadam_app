import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/payout_history_controller.dart';

class PayoutHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PayoutHistoryController>(() => PayoutHistoryController());
  }
}
