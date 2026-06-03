import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/services/theme_language_service.dart';
import 'package:musaab_adam/main_app.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage
  await GetStorage.init();

  // Initialize Services
  await Get.putAsync(() => ThemeLanguageService().init());

  // Initialize Controllers
  Get.put(AuthController(), permanent: true);
  Get.putAsync( (){ return RoleService().init();}, permanent: true);

  runApp(const MainApp());
}