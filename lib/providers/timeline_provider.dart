import 'package:flutter/material.dart';
import '../models/milestone_model.dart';

class TimelineProvider with ChangeNotifier {
  List<Milestone> _milestones = [];

  List<Milestone> get milestones => _milestones;

  TimelineProvider() {
    _fetchMilestones();
  }

  void _fetchMilestones() {
    // Simulate fetching data
    _milestones = [
      Milestone(
        id: '1',
        title: 'Graduation',
        date: DateTime(2022, 5, 20),
        type: MilestoneType.graduation,
        icon: Icons.school,
      ),
      Milestone(
        id: '2',
        title: 'First Job',
        date: DateTime(2022, 8, 1),
        type: MilestoneType.jobOffer,
        icon: Icons.work,
      ),
      Milestone(
        id: '3',
        title: 'Trip to Japan',
        date: DateTime(2023, 4, 10),
        type: MilestoneType.travel,
        icon: Icons.airplanemode_active,
      ),
      Milestone(
        id: '4',
        title: 'Project Phoenix',
        date: DateTime(2023, 10, 28),
        type: MilestoneType.project,
        icon: Icons.code,
      ),
      Milestone(
        id: '5',
        title: 'Breakup',
        date: DateTime(2024, 2, 14),
        type: MilestoneType.breakup,
        icon: Icons.heart_broken,
      ),
    ];
    // Sort milestones by date
    _milestones.sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }
}
