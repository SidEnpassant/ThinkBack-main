import 'package:flutter/material.dart';
import '../models/memory_model.dart';

class HomeProvider with ChangeNotifier {
  List<Memory> _memories = [];

  List<Memory> get memories => _memories;

  HomeProvider() {
    _fetchMemories();
  }

  void _fetchMemories() {
    // Simulate fetching data
    _memories = [
      Memory(
        id: '1',
        title: 'A walk in the park',
        snippet:
            'Remembering the sunny afternoon spent at the central park, feeling the gentle breeze...',
        mood: Mood.Joy,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        location: 'Central Park, NY',
      ),
      Memory(
        id: '2',
        title: 'Missed opportunity',
        snippet:
            'That time I could have spoken up but didn\'t. It still bothers me sometimes, a lesson in courage.',
        mood: Mood.Regret,
        timestamp: DateTime.now().subtract(const Duration(days: 15)),
        location: 'Office Meeting',
      ),
      Memory(
        id: '3',
        title: 'The confusing dream',
        snippet:
            'I dreamt of a city with floating buildings and cats that could talk. What could it mean?',
        mood: Mood.Curious,
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        audioUrl: 'https://example.com/audio.mp3',
        location: 'Dreamscape',
      ),
      Memory(
        id: '4',
        title: 'A walk in the park',
        snippet:
            'Remembering the sunny afternoon spent at the central park, feeling the gentle breeze...',
        mood: Mood.Joy,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        location: 'Central Park, NY',
      ),
    ];
    notifyListeners();
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
}
