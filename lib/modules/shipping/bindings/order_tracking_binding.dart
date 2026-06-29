import 'package:get/get.dart';
import 'package:musaab_adam/modules/shipping/controllers/order_tracking_controller.dart';

class OrderTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderTrackingController>(() => OrderTrackingController());
  }
}
