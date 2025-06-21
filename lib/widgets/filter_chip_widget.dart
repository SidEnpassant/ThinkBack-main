import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip('Mood', Icons.sentiment_satisfied_alt),
          _buildChip('Time', Icons.access_time),
          _buildChip('Tags', Icons.label),
          _buildChip('Type', Icons.memory),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        onPressed: () {
          // Handle filter logic
        },
      ),
    );
  }
}
