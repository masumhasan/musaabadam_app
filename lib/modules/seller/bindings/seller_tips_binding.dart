import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_tips_controller.dart';

class SellerTipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SellerTipsController());
  }
}
