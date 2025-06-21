import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thinkback4/providers/timeline_provider.dart';
import 'package:thinkback4/models/milestone_model.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TimelineProvider(),
      child: const _TimelineScreenBody(),
    );
  }
}

class _TimelineScreenBody extends StatelessWidget {
  const _TimelineScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimelineProvider>(context);
    final milestones = provider.milestones;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Your Life's Timeline",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        itemCount: milestones.length,
        itemBuilder: (context, index) {
          final milestone = milestones[index];
          return _VerticalTimelineMarker(
            milestone: milestone,
            isFirst: index == 0,
            isLast: index == milestones.length - 1,
          );
        },
      ),
    );
  }
}

class _VerticalTimelineMarker extends StatelessWidget {
  final Milestone milestone;
  final bool isFirst;
  final bool isLast;

  const _VerticalTimelineMarker({
    required this.milestone,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Height for each timeline item
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // The vertical line and icon part
          SizedBox(
            width: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: 2.5,
                    color:
                        isFirst
                            ? Colors.transparent
                            : Colors.blueAccent.withOpacity(0.4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blueAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    milestone.icon,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2.5,
                    color:
                        isLast
                            ? Colors.transparent
                            : Colors.blueAccent.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
          // The content part
          Expanded(
            child: InkWell(
              onTap: () => _showMemoryReel(context, milestone),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      DateFormat('MMMM d, yyyy').format(milestone.date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      milestone.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMemoryReel(BuildContext context, Milestone milestone) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      'Memories from ${milestone.title}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: Colors.black87),
                    ),
                  ),
                  _buildMemoryListItem(
                    Icons.mic,
                    'Voice Log: Reflections',
                    Colors.lightBlueAccent,
                  ),
                  _buildMemoryListItem(
                    Icons.photo_album,
                    'Photo Album: The Celebration',
                    Colors.pinkAccent,
                  ),
                  _buildMemoryListItem(
                    Icons.bar_chart,
                    'Mood Streak: Mostly Joyful',
                    Colors.amberAccent,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.movie,
                      color: Colors.purpleAccent,
                    ),
                    title: const Text(
                      'Play Memory Reel',
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: const Icon(
                      Icons.play_arrow,
                      color: Colors.black87,
                    ),
                    onTap: () {
                      // Play curated montage
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMemoryListItem(IconData icon, String title, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: Colors.grey[800])),
    );
  }
}
