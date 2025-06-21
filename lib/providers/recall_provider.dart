import 'package:flutter/material.dart';
import '../models/memory_model.dart';
import '../services/memory_service.dart';

class RecallProvider with ChangeNotifier {
  String _searchQuery = '';
  String? _moodFilter;
  DateTime? _fromDate;
  DateTime? _toDate;
  List<MemoryModel> _allMemories = [];
  List<MemoryModel> _filteredMemories = [];
  bool isLoading = false;
  String? errorMessage;

  RecallProvider() {
    fetchMemories();
  }

  String get searchQuery => _searchQuery;
  String? get moodFilter => _moodFilter;
  DateTime? get fromDate => _fromDate;
  DateTime? get toDate => _toDate;
  List<MemoryModel> get filteredMemories => _filteredMemories;

  Map<String, List<MemoryModel>> get memoryClusters {
    final clusters = <String, List<MemoryModel>>{};
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

  Future<void> fetchMemories() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      _allMemories = await MemoryService().fetchAllMemories();
      applyFilters();
    } catch (e) {
      errorMessage = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  void setMoodFilter(String? mood) {
    _moodFilter = mood;
    applyFilters();
  }

  void setTimeRange(DateTime? from, DateTime? to) {
    _fromDate = from;
    _toDate = to;
    applyFilters();
  }

  void search(String query) {
    _searchQuery = query;
    applyFilters();
  }

  void applyFilters() {
    _filteredMemories =
        _allMemories.where((memory) {
          final matchesMood = _moodFilter == null || memory.mood == _moodFilter;
          final matchesFrom =
              _fromDate == null ||
              memory.createdAt.isAfter(_fromDate!) ||
              memory.createdAt.isAtSameMomentAs(_fromDate!);
          final matchesTo =
              _toDate == null ||
              memory.createdAt.isBefore(_toDate!) ||
              memory.createdAt.isAtSameMomentAs(_toDate!);
          final matchesQuery =
              _searchQuery.isEmpty ||
              memory.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              memory.description.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              memory.location.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
          return matchesMood && matchesFrom && matchesTo && matchesQuery;
        }).toList();
    notifyListeners();
  }
}
