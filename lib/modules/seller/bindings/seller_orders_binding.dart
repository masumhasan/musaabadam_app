import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_orders_controller.dart';

class SellerOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellerOrdersController>(() => SellerOrdersController());
  }
}
