import 'package:get/get.dart';
import 'package:musaab_adam/modules/home/controllers/message_controller.dart';

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(() => MessageController());
  }
}
