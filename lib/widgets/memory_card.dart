import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/memory_model.dart';
import '../providers/home_provider.dart';

class MemoryCard extends StatelessWidget {
  final Memory memory;

  const MemoryCard({super.key, required this.memory});

  Color _getMoodColor(Mood mood) {
    switch (mood) {
      case Mood.Joy:
        return Colors.green.withOpacity(0.2);
      case Mood.Regret:
        return Colors.orange.withOpacity(0.2);
      case Mood.Curious:
        return Colors.purple.withOpacity(0.2);
      case Mood.Sad:
        return Colors.blue.withOpacity(0.2);
      case Mood.Grateful:
        return Colors.pink.withOpacity(0.2);
      case Mood.Angry:
        return Colors.red.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  String _getMoodEmoji(Mood mood) {
    switch (mood) {
      case Mood.Joy:
        return '😊';
      case Mood.Regret:
        return '😟';
      case Mood.Curious:
        return '🤔';
      case Mood.Sad:
        return '😢';
      case Mood.Grateful:
        return '🙏';
      case Mood.Angry:
        return '😠';
      default:
        return '😐';
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    return Dismissible(
      key: Key(memory.id),
      background: Container(
        color: Colors.blueAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.edit, color: Colors.white),
            Text('Edit', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.archive, color: Colors.white),
            Text('Archive', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          homeProvider.archiveMemory(memory.id);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${memory.title} archived')));
        } else {
          homeProvider.editMemory(memory.id);
          // Since we don't have an edit screen, we'll just show a message.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Edit action for ${memory.title}')),
          );
          // We need to call notifyListeners to rebuild the widget and prevent empty space
          homeProvider.notifyListeners();
        }
      },
      child: GestureDetector(
        onLongPress: () {
          // Tagging functionality
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Tagging ${memory.title}')));
        },
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(color: _getMoodColor(memory.mood)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memory.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      memory.snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Chip(
                              avatar: Text(_getMoodEmoji(memory.mood)),
                              label: Text(memory.mood.name),
                              backgroundColor: Colors.white.withOpacity(0.5),
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                '${timeago.format(memory.timestamp)} ${memory.location != null ? '· ${memory.location}' : ''}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.5),
                            ),
                          ],
                        ),
                        if (memory.audioUrl != null)
                          IconButton(
                            icon: const Icon(Icons.play_circle_fill),
                            onPressed: () {
                              // Play audio logic
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
