import 'package:get/get.dart';
import 'package:musaab_adam/modules/seller/controllers/schedule_show_controller.dart';

class ScheduleShowBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScheduleShowController());
  }
}
