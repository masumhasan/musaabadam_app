import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/services/theme_language_service.dart';
import 'package:musaab_adam/main_app.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Get.putAsync(() => ThemeLanguageService().init());
  await Get.putAsync(() => RoleService().init(), permanent: true);

  Get.put(AuthController(), permanent: true);

  runApp(const MainApp());
}
