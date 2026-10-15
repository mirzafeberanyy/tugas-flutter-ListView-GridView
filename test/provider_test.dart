import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_tugas/providers/theme_provider.dart';
import 'package:ui_tugas/providers/user_provider.dart';
import 'package:ui_tugas/providers/language_provider.dart';

void main() {
  group('ThemeProvider Unit Test', () {
    test('Initial theme harus Light Mode (isDarkMode = false)', () {
      final themeProvider = ThemeProvider();
      expect(themeProvider.isDarkMode, false);
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('toggleTheme() harus membalik nilai isDarkMode dan memicu listener', () {
      final themeProvider = ThemeProvider();
      bool listenerNotified = false;
      themeProvider.addListener(() {
        listenerNotified = true;
      });

      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, true);
      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(listenerNotified, true);

      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, false);
      expect(themeProvider.themeMode, ThemeMode.light);
    });
  });

  group('UserProvider Unit Test', () {
    test('Initial state user harus kosong dan belum login', () {
      final userProvider = UserProvider();
      expect(userProvider.username, '');
      expect(userProvider.email, '');
      expect(userProvider.isLoggedIn, false);
    });

    test('login() harus mengupdate username, email, dan isLoggedIn', () {
      final userProvider = UserProvider();
      bool listenerNotified = false;
      userProvider.addListener(() {
        listenerNotified = true;
      });

      userProvider.login('ahmad');
      expect(userProvider.username, 'ahmad');
      expect(userProvider.email, 'ahmad@gmail.com');
      expect(userProvider.isLoggedIn, true);
      expect(listenerNotified, true);
    });

    test('logout() harus mereset semua data pengguna', () {
      final userProvider = UserProvider();
      userProvider.login('ahmad');

      userProvider.logout();
      expect(userProvider.username, '');
      expect(userProvider.email, '');
      expect(userProvider.isLoggedIn, false);
    });
  });

  group('LanguageProvider Unit Test', () {
    test('Initial language harus Bahasa Indonesia', () {
      final langProvider = LanguageProvider();
      expect(langProvider.currentLanguage, AppLanguage.indonesia);
      expect(langProvider.languageCode, 'id');
      expect(langProvider.languageName, 'Bahasa Indonesia');
      expect(langProvider.tr('login_button'), 'Login');
      expect(langProvider.tr('greeting'), 'Halo');
    });

    test('Mengganti bahasa ke English', () {
      final langProvider = LanguageProvider();
      bool listenerNotified = false;
      langProvider.addListener(() {
        listenerNotified = true;
      });

      langProvider.setLanguage(AppLanguage.english);
      expect(langProvider.currentLanguage, AppLanguage.english);
      expect(langProvider.languageCode, 'en');
      expect(langProvider.languageName, 'English');
      expect(langProvider.tr('greeting'), 'Hello');
      expect(listenerNotified, true);
    });

    test('Mengganti bahasa ke Bahasa Gayo', () {
      final langProvider = LanguageProvider();
      langProvider.setLanguage(AppLanguage.gayo);

      expect(langProvider.currentLanguage, AppLanguage.gayo);
      expect(langProvider.languageCode, 'gay');
      expect(langProvider.languageName, 'Basa Gayo');
      expect(langProvider.tr('greeting'), 'Kune Kabere');
      expect(langProvider.tr('welcome_drawer'), 'Selamat Roh');
      expect(langProvider.tr('home'), 'Umah');
      expect(langProvider.tr('logout'), 'Taringen');
    });
  });
}
