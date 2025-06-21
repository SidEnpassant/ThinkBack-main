import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/memory_model.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

class MemoryService {
  static const String _allMemoriesUrl =
      'https://thinkbackbackend.onrender.com/api/memory/all';

  Future<List<MemoryModel>> fetchAllMemories() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No auth token found');
    }
    final response = await http.get(
      Uri.parse(_allMemoriesUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> memoriesJson = data['data'];
      return memoriesJson.map((json) => MemoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch memories');
    }
  }

  Future<MemoryModel> uploadVoiceMemory({
    required String title,
    required String location,
    required File voiceFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No auth token found');
    }
    final fileExists = await voiceFile.exists();
    final fileSize = fileExists ? await voiceFile.length() : 0;
    debugPrint('--- UploadVoiceMemory Debug Info ---');
    debugPrint('Authorization header: Bearer $token');
    debugPrint('File path: ${voiceFile.path}');
    debugPrint('File exists: $fileExists');
    debugPrint('File size: $fileSize bytes');
    debugPrint('Title: $title');
    debugPrint('Location: $location');
    debugPrint('-------------------------------');
    final uri = Uri.parse(
      'https://thinkbackbackend.onrender.com/api/memory/voice',
    );
    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['title'] = title
          ..fields['location'] = location
          ..files.add(
            await http.MultipartFile.fromPath(
              'voice',
              voiceFile.path,
              contentType: MediaType('audio', 'wav'),
            ),
          );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return MemoryModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to upload voice memory: ' + response.body);
    }
  }

  Future<MemoryModel> uploadTextMemory({
    required String title,
    required String description,
    required String location,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No auth token found');
    }
    final uri = Uri.parse(
      'https://thinkbackbackend.onrender.com/api/memory/text',
    );
    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['title'] = title
          ..fields['description'] = description
          ..fields['location'] = location;
    if (imageFile != null) {
      String ext = imageFile.path.split('.').last.toLowerCase();
      MediaType contentType;
      if (ext == 'jpg' || ext == 'jpeg') {
        contentType = MediaType('image', 'jpeg');
      } else {
        contentType = MediaType('image', 'png');
      }
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: contentType,
        ),
      );
    }
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return MemoryModel.fromJson(data['data']);
    } else {
      throw Exception('Failed to upload text memory: ' + response.body);
    }
  }
}
