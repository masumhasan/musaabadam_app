import 'package:get/get.dart';
import 'package:musaab_adam/modules/profile/controllers/other_user_profile_controller.dart';

class OtherUserProfileBinding extends Bindings {
  @override
  void dependencies() {
    final String userId = Get.arguments as String;
    Get.lazyPut<OtherUserProfileController>(
      () => OtherUserProfileController(userId: userId),
      tag: userId,
    );
  }
}
