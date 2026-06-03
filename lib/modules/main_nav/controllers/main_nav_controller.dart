import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/modules/profile/screens/account_screen.dart';
import 'package:musaab_adam/modules/activity/screens/activity_screen.dart';
import 'package:musaab_adam/modules/main_nav/screens/categories_screen.dart';
import 'package:musaab_adam/modules/seller/screens/seller_hub_screen.dart';
import 'package:musaab_adam/modules/seller_verification/screens/become_a_seller_screen.dart';

import '../../home/screens/home_screen.dart';

class MainNavController extends GetxController{

  static MainNavController get to => Get.find<MainNavController>();

  RxInt currentIndex = 0.obs;
  final RoleService roleService = Get.find<RoleService>();
  late Role role;
  late List<Widget> screens;

  @override
  void onInit() {

    role = roleService.getUpdatedRole();
    screens = [
      HomeScreen(),
      CategoriesScreen(),
      role == Role.seller ? SellerHubScreen() : BecomeASellerScreen(),
      ActivityScreen(),
      AccountScreen()
    ];
    super.onInit();
  }

  void changeIndex(int newIndex){
    currentIndex.value = newIndex;
  }

}