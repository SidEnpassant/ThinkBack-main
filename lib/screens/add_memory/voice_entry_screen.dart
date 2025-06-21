import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memory_entry_provider.dart';

class VoiceEntryScreen extends StatelessWidget {
  const VoiceEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryEntryProvider(),
      child: const _VoiceEntryBody(),
    );
  }
}

class _VoiceEntryBody extends StatelessWidget {
  const _VoiceEntryBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MemoryEntryProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: const Text(
          'Voice Entry',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            // Waveform animation placeholder
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.graphic_eq,
                  size: 64,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Timer and controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  provider.recordDuration
                      .toString()
                      .split('.')
                      .first
                      .padLeft(8, "0"),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 24),
                IconButton(
                  icon: Icon(
                    provider.isPaused ? Icons.play_arrow : Icons.pause,
                    size: 32,
                  ),
                  onPressed: () {
                    if (provider.isPaused) {
                      provider.resumeRecording();
                    } else {
                      provider.pauseRecording();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.stop, size: 32),
                  onPressed: provider.stopRecording,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Transcription toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Real-time Transcription'),
                Switch(
                  value: provider.transcriptionEnabled,
                  onChanged: (val) {
                    provider.transcriptionEnabled = val;
                    provider.notifyListeners();
                  },
                ),
              ],
            ),
            if (provider.transcriptionEnabled)
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  provider.transcription.isEmpty
                      ? 'Transcription will appear here...'
                      : provider.transcription,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                ),
              ),
            const SizedBox(height: 24),
            // After recording: summarization, title, mood/tags
            if (!provider.isRecording)
              Expanded(
                child: ListView(
                  children: [
                    const Text(
                      'Auto Summarization',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Summary',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: provider.setSummary,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: provider.setTitle,
                    ),
                    const SizedBox(height: 16),
                    // Mood tag suggestions
                    const Text('Mood Tag Suggestions'),
                    Wrap(
                      spacing: 8,
                      children:
                          [
                                'Happy',
                                'Reflective',
                                'Nostalgic',
                                'Excited',
                                'Calm',
                              ]
                              .map(
                                (mood) => ChoiceChip(
                                  label: Text(mood),
                                  selected: provider.mood == mood,
                                  onSelected: (_) => provider.setMood(mood),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 16),
                    // Tag input
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Tags (comma separated)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (val) => provider.setTags(val.split(',')),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
