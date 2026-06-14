import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/seller_inventory_controller.dart';

class SellerInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SellerInventoryController());
  }
}
