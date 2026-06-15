import 'package:get/get.dart';
import '../controllers/rehearsal_controller.dart';

class RehearsalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RehearsalController());
  }
}
