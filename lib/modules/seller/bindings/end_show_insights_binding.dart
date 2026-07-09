import 'package:get/get.dart';
import '../controllers/end_show_insights_controller.dart';

class EndShowInsightsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EndShowInsightsController());
  }
}
