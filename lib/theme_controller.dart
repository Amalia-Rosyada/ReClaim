import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  // Key untuk menyimpan pilihan tema di SharedPreferences.
  static const String _themeKey = 'app_theme_mode';

  // Tema default aplikasi adalah Terang.
  ThemeMode _themeMode = ThemeMode.light;

  // Mengambil tema yang sedang digunakan.
  ThemeMode get themeMode => _themeMode;

  // Memuat pilihan tema yang sebelumnya tersimpan.
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final savedTheme = prefs.getString(_themeKey);

    if (savedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    notifyListeners();
  }

  // Mengubah tema dan menyimpan pilihan pengguna.
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _themeKey,
      mode == ThemeMode.dark ? 'dark' : 'light',
    );

    notifyListeners();
  }

  // Memeriksa apakah tema yang digunakan adalah Gelap.
  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
