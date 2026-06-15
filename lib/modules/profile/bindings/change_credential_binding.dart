import 'package:get/get.dart';
import '../controllers/change_credential_controller.dart';

class ChangeCredentialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeCredentialController());
  }
}
