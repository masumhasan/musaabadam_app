import 'package:get/get.dart';
import '../controllers/replay_controller.dart';

class ReplayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReplayController());
  }
}
