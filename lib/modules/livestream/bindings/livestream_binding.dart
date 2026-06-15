import 'package:get/get.dart';
import '../controllers/livestream_controller.dart';

class LivestreamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LivestreamController());
  }
}
