import 'package:flutter/material.dart';

/// STATE GLOBAL 2: UserProvider
/// Mengelola informasi pengguna (username, email, status login) secara global
/// menggunakan ChangeNotifier dari library provider.
class UserProvider extends ChangeNotifier {
  String _username = '';
  String _email = '';
  bool _isLoggedIn = false;

  // Getter
  String get username => _username;
  String get email => _email;
  bool get isLoggedIn => _isLoggedIn;

  // Method untuk login & menyimpan info user ke state global
  void login(String username, {String? email}) {
    _username = username;
    _email = email ?? (username.contains('@') ? username : '$username@gmail.com');
    _isLoggedIn = true;

    // notifyListeners() memberitahu widget yang memantau state ini
    // agar memperbarui UI (contoh: Drawer, Greeting di Home, dll)
    notifyListeners();
  }

  // Method untuk logout & mereset info user
  void logout() {
    _username = '';
    _email = '';
    _isLoggedIn = false;

    // notifyListeners() mereset tampilan UI yang memantau status login
    notifyListeners();
  }

  // Method opsional untuk memperbarui username
  void updateUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }
}
