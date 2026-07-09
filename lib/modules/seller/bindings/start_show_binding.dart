import 'package:get/get.dart';
import '../controllers/start_show_controller.dart';

class StartShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StartShowController());
  }
}
