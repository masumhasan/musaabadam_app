import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/premier_shop_controller.dart';

class PremierShopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PremierShopController>(() => PremierShopController());
  }
}
