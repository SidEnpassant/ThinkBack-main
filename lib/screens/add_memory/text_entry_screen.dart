import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memory_entry_provider.dart';

class TextEntryScreen extends StatelessWidget {
  const TextEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MemoryEntryProvider(),
      child: const _TextEntryBody(),
    );
  }
}

class _TextEntryBody extends StatefulWidget {
  const _TextEntryBody();

  @override
  State<_TextEntryBody> createState() => _TextEntryBodyState();
}

class _TextEntryBodyState extends State<_TextEntryBody> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MemoryEntryProvider>(context, listen: false);
    _controller = TextEditingController(text: provider.textEntry);
    _controller.addListener(() {
      provider.setTextEntry(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          'Text Entry',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // AI Suggestions
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children:
                    provider.aiSuggestions
                        .map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ActionChip(
                              label: Text(s),
                              onPressed: () {
                                _controller.text = s;
                              },
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 24),
            // Text Field
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Write your memory...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                style: const TextStyle(fontSize: 18),
                controller: _controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
