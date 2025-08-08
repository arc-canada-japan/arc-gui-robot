import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Locale? _locale;
  bool _preservePackagePaths = false;
  String _rosPath = "ros2";

  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  bool get preservePackagePaths => _preservePackagePaths;
  String get rosPath => _rosPath;

  SettingsProvider() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale');

    if (langCode != null) {
      _locale = Locale(langCode);
    } else {
      // Use system locale if supported, otherwise fallback to English
      final systemLang = window.locale.languageCode;
      const supportedLangs = ['en', 'ja', 'fr'];

      _locale = supportedLangs.contains(systemLang)
          ? Locale(systemLang)
          : const Locale('en');
    }

    final isDark = prefs.getBool('darkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    _preservePackagePaths = prefs.getBool('preservePackagePaths') ?? false;

    _rosPath = prefs.getString("rosPath") ?? "ros2";

    notifyListeners();
  }

  void toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', isDark);
    notifyListeners();
  }

  void changeLanguage(String languageCode) async {
    _locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languageCode);
    notifyListeners();
  }

  void togglePreservePaths(bool value) async {
    _preservePackagePaths = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('preservePackagePaths', value);
    notifyListeners();
  }

  void changeRosPath(String rosPath) async {
    _rosPath = rosPath;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rosPath', rosPath);
    notifyListeners();
  }
}
