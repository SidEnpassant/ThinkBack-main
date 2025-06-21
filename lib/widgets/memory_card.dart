import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:just_audio/just_audio.dart';
import '../models/memory_model.dart';
import '../providers/home_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class MemoryCard extends StatefulWidget {
  final dynamic memory; // Accepts Memory or MemoryModel
  final String? imageUrl;

  const MemoryCard({super.key, required this.memory, this.imageUrl});

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard> {
  AudioPlayer? _audioPlayer;
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String url) async {
    try {
      debugPrint('Trying to play audio: $url');
      _audioPlayer?.dispose();
      _audioPlayer = AudioPlayer();
      await _audioPlayer!.setUrl(url);
      await _audioPlayer!.play();
      setState(() => _isPlaying = true);
      _audioPlayer!.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      debugPrint('Audio play error: $e');
      setState(() => _isPlaying = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to play audio')));
    }
  }

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

  String _formatIST(DateTime utcDate) {
    final local = utcDate.toLocal();
    final formatter = DateFormat('hh:mm:ss a, dd MMM yyyy');
    return formatter.format(local) + ' IST';
  }

  @override
  Widget build(BuildContext context) {
    final memory = widget.memory;
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    // Support both Memory and MemoryModel
    final String id = memory.id;
    final String title = memory.title;
    final String snippet =
        memory is MemoryModel ? memory.description : memory.snippet;
    final mood =
        memory is MemoryModel ? memory.mood : describeEnum(memory.mood);
    final DateTime timestamp =
        memory is MemoryModel ? memory.createdAt : memory.timestamp;
    final String? location = memory.location;

    return Dismissible(
      key: Key(id),
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
          homeProvider.archiveMemory(id);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('${title} archived')));
        } else {
          homeProvider.editMemory(id);
          // Since we don't have an edit screen, we'll just show a message.
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Edit action for ${title}')));
          // We need to call notifyListeners to rebuild the widget and prevent empty space
          homeProvider.notifyListeners();
        }
      },
      child: GestureDetector(
        onLongPress: () {
          // Tagging functionality
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Tagging ${title}')));
        },
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: BoxDecoration(
              color: _getMoodColor(
                memory is MemoryModel ? _parseMood(mood) : memory.mood,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snippet,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Chip(
                                avatar: Text(
                                  _getMoodEmoji(
                                    memory is MemoryModel
                                        ? _parseMood(mood)
                                        : memory.mood,
                                  ),
                                ),
                                label: Text(mood),
                                backgroundColor: Colors.white.withOpacity(0.5),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Chip(
                                  label: Text(
                                    '${_formatIST(timestamp)}${location != null ? ' · $location' : ''}',
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  backgroundColor: Colors.white.withOpacity(
                                    0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (memory.audioUrl != null)
                          IconButton(
                            icon: Icon(
                              _isPlaying
                                  ? Icons.stop_circle
                                  : Icons.play_circle_fill,
                            ),
                            onPressed:
                                _isPlaying
                                    ? () async {
                                      await _audioPlayer?.stop();
                                      setState(() => _isPlaying = false);
                                    }
                                    : () => _playAudio(memory.audioUrl!),
                          ),
                        if ((memory is MemoryModel &&
                                memory.imageUrl != null &&
                                memory.imageUrl!.isNotEmpty) ||
                            (widget.imageUrl != null &&
                                widget.imageUrl!.isNotEmpty))
                          IconButton(
                            icon: const Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                            ),
                            onPressed: () {
                              final url =
                                  memory is MemoryModel &&
                                          memory.imageUrl != null &&
                                          memory.imageUrl!.isNotEmpty
                                      ? memory.imageUrl!
                                      : widget.imageUrl!;
                              showDialog(
                                context: context,
                                builder:
                                    (_) => Dialog(child: Image.network(url)),
                              );
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

  Mood _parseMood(String mood) {
    switch (mood) {
      case 'Joy':
        return Mood.Joy;
      case 'Regret':
        return Mood.Regret;
      case 'Curious':
        return Mood.Curious;
      case 'Sad':
        return Mood.Sad;
      case 'Grateful':
        return Mood.Grateful;
      case 'Angry':
        return Mood.Angry;
      default:
        return Mood.Joy;
    }
  }
}
