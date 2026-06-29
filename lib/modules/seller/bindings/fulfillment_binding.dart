import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/fulfillment_controller.dart';

class FulfillmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FulfillmentController>(() => FulfillmentController());
  }
}
