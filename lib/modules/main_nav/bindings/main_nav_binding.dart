import 'package:get/get.dart';

import '../../home/controllers/home_screen_controller.dart';
import '../controllers/categories_controller.dart';
import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<HomeScreenController>(() => HomeScreenController());
  }
}