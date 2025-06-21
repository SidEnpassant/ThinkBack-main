import 'package:flutter/material.dart';
import '../models/memory_model.dart';
import '../services/memory_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WellbeingInsight {
  final String id;
  final String trend;
  final String suggestion;
  final String imageUrl;
  WellbeingInsight({
    required this.id,
    required this.trend,
    required this.suggestion,
    required this.imageUrl,
  });
  factory WellbeingInsight.fromJson(Map<String, dynamic> json) {
    return WellbeingInsight(
      id: json['_id'] ?? '',
      trend: json['trend'] ?? '',
      suggestion: json['suggestion'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class HomeProvider extends ChangeNotifier {
  List<MemoryModel> _memories = [];
  bool isLoading = false;
  String? errorMessage;
  WellbeingInsight? wellbeingInsight;
  bool wellbeingLoading = false;
  String? userName;

  List<MemoryModel> get memories => _memories;
  WellbeingInsight? get insight => wellbeingInsight;
  bool get isWellbeingLoading => wellbeingLoading;
  String get currentUserName => userName ?? 'there';

  Future<void> fetchMemories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _loadUserData();
      await fetchWellbeingInsight();
      _memories = await MemoryService().fetchAllMemories();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchWellbeingInsight() async {
    wellbeingLoading = true;
    wellbeingInsight = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No auth token found');
      final response = await http.get(
        Uri.parse('https://thinkbackbackend.onrender.com/api/wellbeing'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['data'] != null) {
        wellbeingInsight = WellbeingInsight.fromJson(data['data']);
      } else {
        wellbeingInsight = null;
      }
    } catch (e) {
      wellbeingInsight = null;
    }
    wellbeingLoading = false;
    notifyListeners();
  }

  Future<void> markWellbeingAsSeen(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No auth token found');
      final response = await http.delete(
        Uri.parse(
          'https://thinkbackbackend.onrender.com/api/wellbeing/$id/seen',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        // Log error but don't block UI
        debugPrint('Failed to mark wellbeing as seen: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error marking wellbeing as seen: $e');
    }
  }

  void archiveMemory(String id) {
    _memories.removeWhere((memory) => memory.id == id);
    notifyListeners();
    // Here you would add logic to call an API to archive the memory
  }

  void editMemory(String id) {
    // Logic to navigate to an edit screen or show an edit dialog
    print('Editing memory $id');
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString('userName');
    notifyListeners();
  }
}
