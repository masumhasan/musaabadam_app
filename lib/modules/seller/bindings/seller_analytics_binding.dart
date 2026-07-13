import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_analytics_controller.dart';

class SellerAnalyticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerAnalyticsController>(() => SellerAnalyticsController());
  }
}
