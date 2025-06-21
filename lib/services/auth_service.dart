import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';
import '../models/register_model.dart';

class AuthService {
  static const String _loginUrl =
      'https://thinkbackbackend.onrender.com/api/auth/login';
  static const String _registerUrl =
      'https://thinkbackbackend.onrender.com/api/auth/register';
  static const String _googleAuthUrl =
      'https://thinkbackbackend.onrender.com/api/auth/google';

  Future<LoginResponse> login(LoginModel model) async {
    final response = await http.post(
      Uri.parse(_loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Login failed. Please try again.');
    }
  }

  Future<RegisterResponse> register(RegisterModel model) async {
    final response = await http.post(
      Uri.parse(_registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return RegisterResponse.fromJson(data);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Register failed. Please try again.');
    }
  }

  Future<LoginResponse> googleSignIn(String idToken) async {
    final response = await http.post(
      Uri.parse(_googleAuthUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return LoginResponse.fromJson(data);
    } else {
      final data = jsonDecode(response.body);
      throw Exception(
        data['message'] ?? 'Google sign in failed. Please try again.',
      );
    }
  }
}
