import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/shows_controller.dart';

class ShowsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ShowsController());
  }
}
