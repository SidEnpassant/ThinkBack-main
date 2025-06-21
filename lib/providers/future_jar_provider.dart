import 'package:flutter/material.dart';
import '../models/future_jar_model.dart';

class FutureJarProvider with ChangeNotifier {
  final List<FutureJar> _jars = [
    FutureJar(
      id: '1',
      title: 'For my 30th Birthday',
      message:
          'Hope you are happy and fulfilled, and that you have traveled to at least 10 new countries. Remember the goals you set on your 25th birthday!',
      unlockDate: DateTime.now().add(const Duration(days: 1024)),
      category: 'Personal Growth',
    ),
    FutureJar(
      id: '2',
      title: 'Wedding Day Advice',
      message:
          'Don\'t forget to just enjoy the moment. Take a deep breath, look around, and soak it all in. This day is for you two.',
      unlockDate: DateTime.now().add(const Duration(days: 456)),
      category: 'For your wedding day',
    ),
    FutureJar(
      id: '3',
      title: 'If you feel like quitting your job',
      message:
          'Remember why you started this career path. Is the reason you want to quit a temporary frustration or a fundamental misalignment with your values? Take a week to think before you decide.',
      unlockDate: DateTime.now().add(const Duration(days: 90)),
    ),
  ];

  List<FutureJar> get jars => _jars;

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
