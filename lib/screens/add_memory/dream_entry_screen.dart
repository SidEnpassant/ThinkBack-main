import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memory_entry_provider.dart';

class DreamEntryScreen extends StatelessWidget {
  const DreamEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryEntryProvider(),
      child: const _DreamEntryBody(),
    );
  }
}

class _DreamEntryBody extends StatelessWidget {
  const _DreamEntryBody();

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
          'Dream Entry',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            // Template prompts
            _PromptField(
              label: 'Where were you?',
              value: provider.dreamWhere,
              onChanged: provider.setDreamWhere,
            ),
            const SizedBox(height: 16),
            _PromptField(
              label: 'Who appeared?',
              value: provider.dreamWho,
              onChanged: provider.setDreamWho,
            ),
            const SizedBox(height: 16),
            _PromptField(
              label: 'How did you feel?',
              value: provider.dreamFeel,
              onChanged: provider.setDreamFeel,
            ),
            const SizedBox(height: 32),
            // Post Entry Action Sheet
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tags',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _TagsField(
                      tags: provider.tags,
                      onChanged: provider.setTags,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mood',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    _MoodSlider(
                      mood: provider.mood,
                      onChanged: provider.setMood,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PromptField extends StatefulWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;
  const _PromptField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  State<_PromptField> createState() => _PromptFieldState();
}

class _PromptFieldState extends State<_PromptField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(covariant _PromptField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.text = widget.value;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      controller: _controller,
    );
  }
}

class _MoodSlider extends StatelessWidget {
  final String mood;
  final ValueChanged<String> onChanged;
  const _MoodSlider({required this.mood, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'emoji': '😴', 'label': 'Sleepy'},
      {'emoji': '😊', 'label': 'Happy'},
      {'emoji': '😱', 'label': 'Surprised'},
      {'emoji': '😢', 'label': 'Sad'},
      {'emoji': '🤔', 'label': 'Curious'},
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
          moods
              .map(
                (m) => GestureDetector(
                  onTap: () => onChanged(m['label']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          mood == m['label']
                              ? Colors.blueAccent.withOpacity(0.15)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(m['emoji']!, style: const TextStyle(fontSize: 28)),
                        const SizedBox(height: 2),
                        Text(
                          m['label']!,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                mood == m['label']
                                    ? Colors.blueAccent
                                    : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}

class _TagsField extends StatefulWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;
  const _TagsField({required this.tags, required this.onChanged});

  @override
  State<_TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<_TagsField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.tags.join(", "));
    _controller.addListener(() {
      widget.onChanged(_controller.text.split(","));
    });
  }

  @override
  void didUpdateWidget(covariant _TagsField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tags.join(",") != widget.tags.join(",")) {
      _controller.text = widget.tags.join(", ");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'People, Topic, Location',
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      controller: _controller,
    );
  }
}
