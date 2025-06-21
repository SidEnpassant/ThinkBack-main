import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_model.dart';
import '../services/auth_service.dart';

class LoginProvider with ChangeNotifier {
  String email = '';
  String password = '';
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? errorMessage;
  String? token;
  Map<String, dynamic>? user;

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> login() async {
    errorMessage = null;
    if (!email.endsWith('@gmail.com')) {
      errorMessage = 'Email must be a valid @gmail.com address.';
      notifyListeners();
      return;
    }
    if (password.isEmpty) {
      errorMessage = 'Password cannot be empty.';
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      final loginModel = LoginModel(email: email, password: password);
      final response = await AuthService().login(loginModel);
      token = response.token;
      user = response.user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      await prefs.setString('user', user != null ? user.toString() : '');
      errorMessage = null;
      debugPrint('Login successful. Token: $token');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    isLoading = false;
    notifyListeners();
  }
}
