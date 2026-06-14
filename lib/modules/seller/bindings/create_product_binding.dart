import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/create_product_controller.dart';

class CreateProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateProductController());
  }
}
