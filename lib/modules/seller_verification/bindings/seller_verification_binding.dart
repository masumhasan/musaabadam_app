import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller_verification/controllers/seller_verification_controller.dart';

class SellerVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SellerVerificationController());
  }
}
