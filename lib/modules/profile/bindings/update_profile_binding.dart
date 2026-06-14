import 'package:get/get.dart';
import 'package:musaab_adam/modules/profile/controllers/update_profile_controller.dart';

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(UpdateProfileController());
  }
}
