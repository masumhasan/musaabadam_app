import 'package:get/get.dart';
import '../controllers/legal_content_controller.dart';

class LegalContentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LegalContentController());
  }
}
