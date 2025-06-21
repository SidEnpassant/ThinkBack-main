import 'package:flutter/material.dart';

enum MilestoneType {
  graduation,
  breakup,
  jobOffer,
  birth,
  travel,
  project,
  custom,
}

class Milestone {
  final String id;
  final String title;
  final String? description;
  final DateTime date;
  final MilestoneType type;
  final IconData icon;

  Milestone({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.type,
    required this.icon,
  });
}
