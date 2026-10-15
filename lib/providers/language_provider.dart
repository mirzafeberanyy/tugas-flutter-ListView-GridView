import 'package:flutter/material.dart';

/// Pilihan bahasa yang didukung oleh aplikasi
enum AppLanguage {
  indonesia,
  english,
  gayo,
}

/// STATE GLOBAL 3: LanguageProvider
/// Mengelola bahasa aplikasi secara global dengan 3 bahasa:
/// 1. Bahasa Indonesia
/// 2. English
/// 3. Bahasa Daerah Gayo (Aceh)
class LanguageProvider extends ChangeNotifier {
  AppLanguage _currentLanguage = AppLanguage.indonesia;

  AppLanguage get currentLanguage => _currentLanguage;

  // Kode bahasa singkat (misal untuk Locale)
  String get languageCode {
    switch (_currentLanguage) {
      case AppLanguage.indonesia:
        return 'id';
      case AppLanguage.english:
        return 'en';
      case AppLanguage.gayo:
        return 'gay';
    }
  }

  // Nama bahasa yang ditampilkan kepada pengguna
  String get languageName {
    switch (_currentLanguage) {
      case AppLanguage.indonesia:
        return 'Bahasa Indonesia';
      case AppLanguage.english:
        return 'English';
      case AppLanguage.gayo:
        return 'Basa Gayo';
    }
  }

  // Method untuk mengganti bahasa
  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      // Memberitahu seluruh widget yang 'listen' agar melakukan rebuild dengan teks bahasa baru
      notifyListeners();
    }
  }

  // Kamus terjemahan untuk 3 bahasa
  static const Map<AppLanguage, Map<String, String>> _translations = {
    AppLanguage.indonesia: {
      'app_title': 'Tugas UI Flutter',
      'login_page': 'Halaman Login',
      'sign_in': 'Sign In',
      'username': 'Username',
      'password': 'Password',
      'forgot_password': 'Lupa Kata Sandi?',
      'login_button': 'Login',
      'no_account': 'Belum punya akun?',
      'home': 'Beranda',
      'welcome_drawer': 'Selamat Datang',
      'greeting': 'Halo',
      'dark_mode': 'Mode Gelap',
      'logout': 'Logout',
      'language': 'Bahasa',
      'select_language': 'Pilih Bahasa',
      'global_state_title': 'Status State Global (Provider):',
      'state_user_title': 'State 1: UserProvider',
      'state_theme_title': 'State 2: ThemeProvider',
      'state_lang_title': 'State 3: LanguageProvider',
      'status_logged_in': 'Telah Login',
      'status_guest': 'Belum Login',
      'input_username_hint': 'Harap isi username terlebih dahulu',
    },
    AppLanguage.english: {
      'app_title': 'Flutter UI Task',
      'login_page': 'Login Page',
      'sign_in': 'Sign In',
      'username': 'Username',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'login_button': 'Login',
      'no_account': 'Don\'t have an account?',
      'home': 'Home',
      'welcome_drawer': 'Welcome',
      'greeting': 'Hello',
      'dark_mode': 'Dark Mode',
      'logout': 'Logout',
      'language': 'Language',
      'select_language': 'Select Language',
      'global_state_title': 'Global State Status (Provider):',
      'state_user_title': 'State 1: UserProvider',
      'state_theme_title': 'State 2: ThemeProvider',
      'state_lang_title': 'State 3: LanguageProvider',
      'status_logged_in': 'Logged In',
      'status_guest': 'Not Logged In',
      'input_username_hint': 'Please enter a username first',
    },
    AppLanguage.gayo: {
      'app_title': 'Tugas UI Flutter',
      'login_page': 'Laman Masuk',
      'sign_in': 'Tama / Masuk',
      'username': 'Gelen Pengguna',
      'password': 'Kata Sandi',
      'forgot_password': 'Kekelupaen Kata Sandi?',
      'login_button': 'Tama',
      'no_account': 'Gere ara akun?',
      'home': 'Umah',
      'welcome_drawer': 'Selamat Roh',
      'greeting': 'Kune Kabere',
      'dark_mode': 'Mode Gelap',
      'logout': 'Taringen',
      'language': 'Basa',
      'select_language': 'Pilih Basa',
      'global_state_title': 'Kahanan State Global (Provider):',
      'state_user_title': 'State 1: UserProvider',
      'state_theme_title': 'State 2: ThemeProvider',
      'state_lang_title': 'State 3: LanguageProvider',
      'status_logged_in': 'Nge Masuk',
      'status_guest': 'Gere ilen Masuk',
      'input_username_hint': 'Tolong isien gelen pengguna mampat',
    },
  };

  // Helper method untuk mendapatkan string terjemahan sesuai bahasa aktif
  String tr(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }
}
