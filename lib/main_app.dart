import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/localization/app_translations.dart';
import 'package:musaab_adam/core/services/theme_language_service.dart';
import 'package:musaab_adam/core/theme/app_theme.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the service
    final themeLangService = ThemeLanguageService.to;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          // Theme Integration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeLangService.themeMode,

          // Localization Integration
          translations: AppTranslations(),
          locale: Locale(themeLangService.currentLanguage.split('_')[0], themeLangService.currentLanguage.split('_')[1]),
          fallbackLocale: const Locale('en', 'US'),

          // Routing
          getPages: AppPages.pages,
          initialRoute: AppRoutes.signInScreen,
        );
      },
    );
  }
}