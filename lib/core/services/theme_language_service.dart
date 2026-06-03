import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeLanguageService extends GetxService {
  static ThemeLanguageService get to => Get.find();

  final _storage = GetStorage();
  final _themeKey = 'isDarkMode';
  final _langKey = 'appLanguage';

  Future<ThemeLanguageService> init() async {
    return this;
  }

  // --- Theme Management ---
  bool get isDarkMode => _storage.read(_themeKey) ?? false;

  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    Get.changeThemeMode(isDarkMode ? ThemeMode.light : ThemeMode.dark);
    _storage.write(_themeKey, !isDarkMode);
  }

  // --- Localization Management ---
  String get currentLanguage => _storage.read(_langKey) ?? 'en_US';

  void updateLanguage(String langCode) {
    var locale = Locale(langCode.split('_')[0], langCode.split('_')[1]);
    Get.updateLocale(locale);
    _storage.write(_langKey, langCode);
  }
}