import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider extends ChangeNotifier {
  // Add state variables and methods to manage profile settings here.
  // For example, for theme management:
  // String _currentTheme = 'light';
  // String get currentTheme => _currentTheme;

  // void changeTheme(String theme) {
  //   _currentTheme = theme;
  //   notifyListeners();
  // }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    notifyListeners();
  }
}
