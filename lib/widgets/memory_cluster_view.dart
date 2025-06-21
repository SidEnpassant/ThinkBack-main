import 'package:flutter/material.dart';
import 'package:thinkback4/widgets/memory_card.dart';
import '../models/memory_model.dart';

class MemoryClusterView extends StatelessWidget {
  final String clusterTitle;
  final List<dynamic> memories; // Accepts Memory or MemoryModel

  const MemoryClusterView({
    super.key,
    required this.clusterTitle,
    required this.memories,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          '$clusterTitle - ${memories.length} memories',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: memories.map((memory) => MemoryCard(memory: memory)).toList(),
      ),
    );
  }
}
