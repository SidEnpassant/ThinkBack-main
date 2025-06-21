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
