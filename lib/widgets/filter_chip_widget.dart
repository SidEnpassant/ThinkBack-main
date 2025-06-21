import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recall_provider.dart';

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
          _buildChip(context, 'Mood', Icons.sentiment_satisfied_alt),
          _buildChip(context, 'Time', Icons.access_time),
          // _buildChip(context, 'Tags', Icons.label),
          // _buildChip(context, 'Type', Icons.memory),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ActionChip(
        avatar: Icon(icon, size: 18),
        label: Text(label),
        onPressed: () async {
          // Mood filter
          if (label == 'Mood') {
            final moods = [
              'Joy',
              'Regret',
              'Curious',
              'Sad',
              'Grateful',
              'Angry',
              null,
            ];
            final selected = await showDialog<String?>(
              context: context,
              builder:
                  (ctx) => SimpleDialog(
                    title: const Text('Select Mood'),
                    children:
                        moods
                            .map(
                              (mood) => SimpleDialogOption(
                                child: Text(mood ?? 'All'),
                                onPressed: () => Navigator.pop(ctx, mood),
                              ),
                            )
                            .toList(),
                  ),
            );
            if (selected != null || selected == null) {
              Provider.of<RecallProvider>(
                context,
                listen: false,
              ).setMoodFilter(selected);
            }
          }
          // Date filter
          if (label == 'Time') {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (picked != null) {
              Provider.of<RecallProvider>(
                context,
                listen: false,
              ).setTimeRange(picked.start, picked.end);
            }
          }
        },
      ),
    );
  }
}
