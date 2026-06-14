import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/services/theme_language_service.dart';
import 'package:musaab_adam/main_app.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  await Get.putAsync(() => ThemeLanguageService().init());
  await Get.putAsync(() => RoleService().init(), permanent: true);

  Get.put(AuthController(), permanent: true);

  _initDeepLinks();

  runApp(const MainApp());
}

void _initDeepLinks() {
  final appLinks = AppLinks();

  appLinks.uriLinkStream.listen((uri) {
    _handleDeepLink(uri);
  });

  // Handle cold-start deep link
  appLinks.getInitialLink().then((uri) {
    if (uri != null) _handleDeepLink(uri);
  });
}

void _handleDeepLink(Uri uri) {
  if (uri.scheme != 'bidsrush') return;

  if (uri.host == 'account-verified') {
    Get.toNamed(AppRoutes.accountVerifiedScreen);
  }
}
