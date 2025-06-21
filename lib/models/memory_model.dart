import 'package:flutter/material.dart';

enum Mood { Joy, Regret, Curious, Sad, Grateful, Angry }

class Memory {
  final String id;
  final String title;
  final String snippet;
  final Mood mood;
  final DateTime timestamp;
  final String? location;
  final String? audioUrl;

  Memory({
    required this.id,
    required this.title,
    required this.snippet,
    required this.mood,
    required this.timestamp,
    this.location,
    this.audioUrl,
  });
}

class MemoryModel {
  final String id;
  final String userId;
  final String title;
  final String type;
  final String description;
  final String? imageUrl;
  final String? audioUrl;
  final String aiSummary;
  final String mood;
  final String location;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemoryModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.type,
    required this.description,
    this.imageUrl,
    this.audioUrl,
    required this.aiSummary,
    required this.mood,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['_id'],
      userId: json['userId'],
      title: json['title'],
      type: json['type'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      aiSummary: json['aiSummary'],
      mood: json['mood'],
      location: json['location'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
