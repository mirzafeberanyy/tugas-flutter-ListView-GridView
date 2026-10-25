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

  // Kode bahasa singkat
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

  // Nama bahasa tanpa emotikon/emoji
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

  // Label singkat untuk dropdown
  String get shortCode {
    switch (_currentLanguage) {
      case AppLanguage.indonesia:
        return 'ID';
      case AppLanguage.english:
        return 'EN';
      case AppLanguage.gayo:
        return 'GAY';
    }
  }

  void setLanguage(AppLanguage language) {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
  }

  // Kamus terjemahan untuk 3 bahasa bertema Football Fans & Achievements
  static const Map<AppLanguage, Map<String, String>> _translations = {
    AppLanguage.indonesia: {
      'app_title': 'FootyStars Hub',
      'app_subtitle': 'Portal Eksklusif Penggemar Bintang Sepak Bola Dunia',
      'login_page': 'Halaman Masuk',
      'sign_in': 'Masuk ke Fan Hub',
      'username': 'Username atau Email',
      'password': 'Kata Sandi',
      'forgot_password': 'Lupa kata sandi?',
      'login_button': 'Masuk Sekarang',
      'no_account': 'Belum memiliki akun fans? Gabung sekarang',
      'home': 'Beranda Fans',
      'welcome_drawer': 'Selamat Datang',
      'greeting': 'Halo',
      'dark_mode': 'Mode Gelap',
      'logout': 'Keluar Akun',
      'language': 'Bahasa',
      'select_language': 'Pilih Bahasa',
      'global_state_title': 'Status State Global (Provider):',
      'state_user_title': 'State 1: UserProvider',
      'state_theme_title': 'State 2: ThemeProvider',
      'state_lang_title': 'State 3: LanguageProvider',
      'status_logged_in': 'Telah Login',
      'status_guest': 'Tamu / Belum Login',
      'input_username_hint': 'Harap isi username atau email Anda',
      'search_hint': 'Cari pemain bintang, klub, atau negara...',
      'categories': 'Kategori Posisi',
      'cat_all': 'Semua',
      'cat_forward': 'Penyerang',
      'cat_midfield': 'Gelandang',
      'cat_defender': 'Bek',
      'cat_keeper': 'Kiper',
      'featured_grid': 'Sorotan Bintang (GridView)',
      'featured_grid_sub': 'Kartu pemain bintang dunia terfavorit',
      'all_list': 'Daftar Roster Pemain (ListView)',
      'all_list_sub': 'Profil lengkap, statistik, dan prestasi',
      'trophies_title': 'Prestasi & Trofi Utama',
      'stats_title': 'Statistik Karier Resmi',
      'vote_goat': 'Beri Vote Pemain Favorit',
      'vote_success': 'Vote penggemar berhasil ditambahkan!',
      'matches': 'Pertandingan',
      'goals': 'Gol',
      'assists': 'Assist',
      'rating': 'Rating FIFA',
      'player_profile': 'Profil Pemain',
      'fan_support': 'Dukungan Fans',
    },
    AppLanguage.english: {
      'app_title': 'FootyStars Hub',
      'app_subtitle': 'Exclusive Portal for Global Football Fans',
      'login_page': 'Login Page',
      'sign_in': 'Sign In to Fan Hub',
      'username': 'Username or Email',
      'password': 'Password',
      'forgot_password': 'Forgot password?',
      'login_button': 'Log In',
      'no_account': 'Don\'t have a fan account? Join now',
      'home': 'Fan Home',
      'welcome_drawer': 'Welcome',
      'greeting': 'Hello',
      'dark_mode': 'Dark Mode',
      'logout': 'Log Out',
      'language': 'Language',
      'select_language': 'Select Language',
      'global_state_title': 'Global State Status (Provider):',
      'state_user_title': 'State 1: UserProvider',
      'state_theme_title': 'State 2: ThemeProvider',
      'state_lang_title': 'State 3: LanguageProvider',
      'status_logged_in': 'Logged In',
      'status_guest': 'Guest / Not Logged In',
      'input_username_hint': 'Please enter your username or email',
      'search_hint': 'Search star player, club, or country...',
      'categories': 'Position Categories',
      'cat_all': 'All',
      'cat_forward': 'Forward',
      'cat_midfield': 'Midfield',
      'cat_defender': 'Defender',
      'cat_keeper': 'Goalkeeper',
      'featured_grid': 'Featured Stars (GridView)',
      'featured_grid_sub': 'Top world-class icons curated for fans',
      'all_list': 'Player Roster (ListView)',
      'all_list_sub': 'Comprehensive profiles, stats & achievements',
      'trophies_title': 'Key Trophies & Achievements',
      'stats_title': 'Official Career Statistics',
      'vote_goat': 'Vote as Fan Favorite',
      'vote_success': 'Fan vote recorded successfully!',
      'matches': 'Matches',
      'goals': 'Goals',
      'assists': 'Assists',
      'rating': 'FIFA Rating',
      'player_profile': 'Player Profile',
      'fan_support': 'Fan Support',
    },
    AppLanguage.gayo: {
      'app_title': 'FootyStars Hub',
      'app_subtitle': 'Laman Bintang Pemain Bola Sedunia',
      'login_page': 'Laman Masuk',
      'sign_in': 'Tama / Masuk Akun Fans',
      'username': 'Gelen Pengguna / Email',
      'password': 'Kata Sandi',
      'forgot_password': 'Kekelupaen kata sandi?',
      'login_button': 'Tama Seleso',
      'no_account': 'Gere ilen ara akun? Gabung janyut',
      'home': 'Umah Fans',
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
      'search_hint': 'Kelen pemain bintang atawa klub...',
      'categories': 'Kategori Posisi',
      'cat_all': 'Kerne',
      'cat_forward': 'Penyerang',
      'cat_midfield': 'Gelandang',
      'cat_defender': 'Penjaga / Bek',
      'cat_keeper': 'Kiper',
      'featured_grid': 'Pemain Bintang (GridView)',
      'featured_grid_sub': 'Pemain nomor wahid sedunia',
      'all_list': 'Daftar Pemain (ListView)',
      'all_list_sub': 'Data prestasi mampat pemain bola',
      'trophies_title': 'Prestasi & Piala Keramat',
      'stats_title': 'Catatan Statistik Karier',
      'vote_goat': 'Pilih Pemain Paling Mantap',
      'vote_success': 'Pilihan penggemar nge sukses ikukumpul!',
      'matches': 'Tanding',
      'goals': 'Gol',
      'assists': 'Assist',
      'rating': 'Rating',
      'player_profile': 'Profil Pemain',
      'fan_support': 'Dukungen Fans',
    },
  };

  String tr(String key) {
    return _translations[_currentLanguage]?[key] ?? key;
  }
}
