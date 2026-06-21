import 'package:get/get.dart';
import '../controllers/past_shows_controller.dart';

class PastShowsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PastShowsController());
  }
}
