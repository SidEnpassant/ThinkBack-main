import 'package:flutter/material.dart';

class MemoryEntryProvider extends ChangeNotifier {
  // Common
  String title = '';
  String summary = '';
  String mood = '';
  List<String> tags = [];

  // Voice mode
  bool isRecording = false;
  bool isPaused = false;
  Duration recordDuration = Duration.zero;
  bool transcriptionEnabled = false;
  String transcription = '';

  // Text mode
  String textEntry = '';
  List<String> aiSuggestions = [
    'Feeling nostalgic?',
    'Want to reflect on someone?',
  ];

  // Dream mode
  String dreamWhere = '';
  String dreamWho = '';
  String dreamFeel = '';

  void startRecording() {
    isRecording = true;
    isPaused = false;
    recordDuration = Duration.zero;
    notifyListeners();
  }

  void pauseRecording() {
    isPaused = true;
    notifyListeners();
  }

  void resumeRecording() {
    isPaused = false;
    notifyListeners();
  }

  void stopRecording() {
    isRecording = false;
    isPaused = false;
    notifyListeners();
  }

  void setTranscription(String value) {
    transcription = value;
    notifyListeners();
  }

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setSummary(String value) {
    summary = value;
    notifyListeners();
  }

  void setMood(String value) {
    mood = value;
    notifyListeners();
  }

  void setTags(List<String> value) {
    tags = value;
    notifyListeners();
  }

  void setTextEntry(String value) {
    textEntry = value;
    notifyListeners();
  }

  void setDreamWhere(String value) {
    dreamWhere = value;
    notifyListeners();
  }

  void setDreamWho(String value) {
    dreamWho = value;
    notifyListeners();
  }

  void setDreamFeel(String value) {
    dreamFeel = value;
    notifyListeners();
  }
}
