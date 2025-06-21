import 'package:flutter/material.dart';
import '../models/memory_model.dart';

class RecallProvider with ChangeNotifier {
  String _searchQuery = '';
  List<Memory> _filteredMemories = [];
  final List<Memory> _allMemories = [
    Memory(
      id: '1',
      title: 'College Move-in',
      snippet:
          'Unpacking boxes in the dorm room, feeling a mix of excitement and nervousness. Dad was there to help.',
      mood: Mood.Joy,
      timestamp: DateTime(2023, 3, 10),
      location: 'Campus Dorms',
    ),
    Memory(
      id: '2',
      title: 'First Day of Classes',
      snippet:
          'Walking through the crowded campus, trying to find my lecture hall. A bit overwhelming but thrilling.',
      mood: Mood.Curious,
      timestamp: DateTime(2023, 3, 12),
      location: 'University Campus',
    ),
    Memory(
      id: '5',
      title: 'Late-night Study Session',
      snippet:
          'Cramming for the finals with friends. We were all so tired but motivated.',
      mood: Mood.Grateful,
      timestamp: DateTime(2023, 5, 20),
      location: 'Library',
    ),
    Memory(
      id: '6',
      title: 'Beach Trip with Dad',
      snippet:
          'A sunny day at the beach with Dad, building sandcastles and enjoying the waves.',
      mood: Mood.Joy,
      timestamp: DateTime(2023, 7, 15),
      location: 'Sunny Beach',
    ),
  ];

  RecallProvider() {
    _filteredMemories = _allMemories;
  }

  String get searchQuery => _searchQuery;
  List<Memory> get filteredMemories => _filteredMemories;

  Map<String, List<Memory>> get memoryClusters {
    final clusters = <String, List<Memory>>{};
    for (var memory in _filteredMemories) {
      final clusterKey =
          memory.title.contains("College") ? "College Days" : "Family Time";
      if (clusters[clusterKey] == null) {
        clusters[clusterKey] = [];
      }
      clusters[clusterKey]!.add(memory);
    }
    return clusters;
  }

  void search(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredMemories = _allMemories;
    } else {
      _filteredMemories =
          _allMemories.where((memory) {
            final queryLower = query.toLowerCase();
            return memory.title.toLowerCase().contains(queryLower) ||
                memory.snippet.toLowerCase().contains(queryLower) ||
                (memory.location?.toLowerCase().contains(queryLower) ?? false);
          }).toList();
    }
    notifyListeners();
  }
}
