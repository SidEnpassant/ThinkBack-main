import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../widgets/memory_card.dart';
import '../widgets/bottom_nav_bar.dart';
import '../screens/add_memory/voice_entry_screen.dart';
import '../screens/add_memory/text_entry_screen.dart';
import '../screens/add_memory/dream_entry_screen.dart';
import '../models/memory_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:thinkback4/widgets/stamp_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _HomeScreenBody();
  }
}

class _HomeScreenBody extends StatefulWidget {
  const _HomeScreenBody();

  @override
  State<_HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<_HomeScreenBody> {
  bool _wellbeingModalShown = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<HomeProvider>(context, listen: false).fetchMemories(),
    );
  }

  @override
  void didUpdateWidget(covariant _HomeScreenBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    _wellbeingModalShown = false;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    // Show wellbeing modal if data is available and not already shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_wellbeingModalShown && mounted && provider.insight != null) {
        final insightToShow = provider.insight!;
        _wellbeingModalShown = true;
        _showWellbeingDialog(context, insightToShow);
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Hey ${provider.currentUserName} 👋, what's on your mind today?",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.errorMessage != null
              ? Center(child: Text(provider.errorMessage!))
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _QuickActionButton(
                          icon: Icons.mic,
                          label: 'Record',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const VoiceEntryScreen(),
                              ),
                            );
                          },
                        ),
                        _QuickActionButton(
                          icon: Icons.edit,
                          label: 'Write',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const TextEntryScreen(),
                              ),
                            );
                          },
                        ),
                        // _QuickActionButton(
                        //   icon: Icons.nightlight_round,
                        //   label: 'Dream',
                        //   onPressed: () {
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //         builder: (context) => const DreamEntryScreen(),
                        //       ),
                        //     );
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.memories.length,
                      itemBuilder: (context, index) {
                        final memoryModel = provider.memories[index];
                        // Map API MemoryModel to old Memory class
                        Mood mood = Mood.Joy;
                        switch (memoryModel.mood.toLowerCase()) {
                          case 'joy':
                          case 'happy':
                            mood = Mood.Joy;
                            break;
                          case 'regret':
                            mood = Mood.Regret;
                            break;
                          case 'curious':
                            mood = Mood.Curious;
                            break;
                          case 'sad':
                          case 'melancholic':
                            mood = Mood.Sad;
                            break;
                          case 'grateful':
                            mood = Mood.Grateful;
                            break;
                          case 'angry':
                            mood = Mood.Angry;
                            break;
                        }
                        final memory = Memory(
                          id: memoryModel.id,
                          title: memoryModel.title,
                          snippet: memoryModel.aiSummary,
                          mood: mood,
                          timestamp: memoryModel.createdAt,
                          location: memoryModel.location,
                          audioUrl:
                              memoryModel.type == 'voice'
                                  ? memoryModel.audioUrl
                                  : null,
                        );
                        return MemoryCard(
                          memory: memory,
                          imageUrl: memoryModel.imageUrl,
                        );
                      },
                    ),
                  ),
                ],
              ),
    );
  }

  void _showWellbeingDialog(BuildContext context, WellbeingInsight insight) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StampDialog(
          imageUrl: insight.imageUrl,
          suggestion: insight.suggestion,
          trend: insight.trend,
          onOk: () async {
            await Provider.of<HomeProvider>(
              context,
              listen: false,
            ).markWellbeingAsSeen(insight.id);
            if (context.mounted) Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class _MemoryCard extends StatelessWidget {
  final MemoryModel memory;
  final String? imageUrl;
  const _MemoryCard({required this.memory, this.imageUrl});

  String _moodEmoji(String mood) {
    switch (mood.toLowerCase()) {
      case 'joy':
      case 'happy':
        return '😊';
      case 'melancholic':
      case 'sad':
        return '😢';
      case 'nostalgic':
        return '🕰️';
      case 'curious':
        return '🤔';
      case 'excited':
        return '🤩';
      case 'calm':
        return '😌';
      case 'reflective':
        return '🧠';
      default:
        return '📝';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  memory.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                Text(
                  _moodEmoji(memory.mood),
                  style: const TextStyle(fontSize: 20),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              memory.aiSummary,
              style: const TextStyle(color: Colors.black54, fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  _formatDate(memory.createdAt),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const Spacer(),
                if (imageUrl != null && imageUrl!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.image, color: Colors.blueAccent),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => Dialog(child: Image.network(imageUrl!)),
                      );
                    },
                  ),
                if (memory.type == 'voice' &&
                    memory.audioUrl != null &&
                    memory.audioUrl!.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.green),
                    onPressed: () {
                      // You can implement audio playback here
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 28),
          onPressed: onPressed,
          style: IconButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
