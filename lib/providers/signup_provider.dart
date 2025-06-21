import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/register_model.dart';
import '../services/auth_service.dart';

class SignupProvider with ChangeNotifier {
  String fullName = '';
  String email = '';
  String password = '';
  String verifyPassword = '';
  bool isPasswordVisible = false;
  bool isVerifyPasswordVisible = false;
  bool isLoading = false;
  String? errorMessage;
  String? token;
  Map<String, dynamic>? user;

  void setFullName(String value) {
    fullName = value;
    notifyListeners();
  }

  void setEmail(String value) {
    email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    password = value;
    notifyListeners();
  }

  void setVerifyPassword(String value) {
    verifyPassword = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void toggleVerifyPasswordVisibility() {
    isVerifyPasswordVisible = !isVerifyPasswordVisible;
    notifyListeners();
  }

  Future<void> signup() async {
    errorMessage = null;
    if (!email.endsWith('@gmail.com')) {
      errorMessage = 'Email must be a valid @gmail.com address.';
      notifyListeners();
      return;
    }
    if (password.isEmpty || verifyPassword.isEmpty) {
      errorMessage = 'Password fields cannot be empty.';
      notifyListeners();
      return;
    }
    if (password != verifyPassword) {
      errorMessage = 'Passwords do not match.';
      notifyListeners();
      return;
    }
    isLoading = true;
    notifyListeners();
    try {
      final registerModel = RegisterModel(
        name: fullName,
        email: email,
        password: password,
      );
      final response = await AuthService().register(registerModel);
      token = response.token;
      user = response.user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      await prefs.setString('user', user != null ? user.toString() : '');
      errorMessage = null;
      debugPrint('Register successful. Token: $token');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> googleSignup() async {
    errorMessage = null;
    isLoading = true;
    notifyListeners();
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(
            clientId:
                '609971466122-82l6j3ge5ol4guhkj9n8i11miv532f9e.apps.googleusercontent.com',
          ).signIn();
      if (googleUser == null) {
        errorMessage = 'Google sign in cancelled.';
        isLoading = false;
        notifyListeners();
        return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        errorMessage = 'Google sign in failed: No idToken.';
        isLoading = false;
        notifyListeners();
        return;
      }
      final response = await AuthService().googleSignIn(idToken);
      token = response.token;
      user = response.user;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      await prefs.setString('user', user != null ? user.toString() : '');
      errorMessage = null;
      debugPrint('Google Register successful. Token: $token');
    } catch (e) {
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    }
    isLoading = false;
    notifyListeners();
  }
}
