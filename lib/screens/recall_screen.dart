import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkback4/widgets/memory_cluster_view.dart';
import '../providers/recall_provider.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/memory_card.dart';

class RecallScreen extends StatelessWidget {
  const RecallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _RecallScreenBody();
  }
}

class _RecallScreenBody extends StatelessWidget {
  const _RecallScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecallProvider>(context);
    final memories = provider.filteredMemories;

    return Scaffold(
      appBar: AppBar(title: const Text('Recall & Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => provider.search(value),
              decoration: InputDecoration(
                hintText: '“Show all memories with Dad in March 2023”',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          const FilterChipWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: memories.length,
              itemBuilder: (context, index) {
                final memory = memories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: MemoryCard(memory: memory),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
