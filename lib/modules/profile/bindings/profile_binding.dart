import 'package:get/get.dart';
import 'package:musaab_adam/modules/profile/controllers/profile_shows_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileShowsController>(() => ProfileShowsController());
  }
}
