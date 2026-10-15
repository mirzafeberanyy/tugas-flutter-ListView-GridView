import 'package:flutter/material.dart';

/// STATE GLOBAL 1: ThemeProvider
/// Mengelola tema aplikasi (Light Mode & Dark Mode) secara global
/// menggunakan ChangeNotifier dari library provider.
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  // Getter untuk mengetahui apakah saat ini Dark Mode aktif
  bool get isDarkMode => _isDarkMode;

  // Getter untuk ThemeMode yang digunakan oleh MaterialApp
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  // Method untuk mengubah / toggle tema antara Light dan Dark
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    // notifyListeners() memberitahu semua widget yang 'listen'
    // ke ThemeProvider untuk melakukan rebuild
    notifyListeners();
  }

  // Method untuk menetapkan tema secara eksplisit
  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      notifyListeners();
    }
  }
}
