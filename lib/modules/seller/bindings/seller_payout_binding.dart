import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_payout_controller.dart';

class SellerPayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerPayoutController>(() => SellerPayoutController());
  }
}
