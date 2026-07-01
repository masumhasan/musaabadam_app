import 'package:get/get.dart';
import 'package:musaab_adam/modules/home/controllers/invite_controller.dart';

class InviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InviteController>(() => InviteController());
  }
}
