import 'package:flutter/material.dart';
import '../models/future_jar_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FutureJarProvider with ChangeNotifier {
  List<FutureJar> _jars = [];
  bool isLoading = false;
  String? errorMessage;

  FutureJarProvider() {
    fetchJars();
  }

  List<FutureJar> get jars => _jars;

  Future<void> fetchJars() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No auth token found');
      final response = await http.get(
        Uri.parse('https://thinkbackbackend.onrender.com/api/locked-in'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> jarsJson = data['data'];
        _jars = jarsJson.map((json) => FutureJar.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch future jars: ' + response.body);
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void addJar(FutureJar jar) {
    _jars.add(jar);
    notifyListeners();
  }

  int daysUntilUnlock(DateTime unlockDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final unlockDay = DateTime(
      unlockDate.year,
      unlockDate.month,
      unlockDate.day,
    );
    return unlockDay.difference(today).inDays;
  }
}
