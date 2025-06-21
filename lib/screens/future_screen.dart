import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thinkback4/providers/future_jar_provider.dart';
import 'package:thinkback4/widgets/future_jar_card.dart';
import 'package:thinkback4/screens/add_future_jar_screen.dart';

class FutureScreen extends StatelessWidget {
  const FutureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FutureJarProvider(),
      child: const _FutureScreenBody(),
    );
  }
}

class _FutureScreenBody extends StatelessWidget {
  const _FutureScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FutureJarProvider>(context);
    final jars = provider.jars;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Your Future Jars",
          style: TextStyle(color: Colors.black87),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: jars.length,
        itemBuilder: (context, index) {
          final jar = jars[index];
          final daysLeft = provider.daysUntilUnlock(jar.unlockDate);
          return FutureJarCard(jar: jar, daysLeft: daysLeft);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddFutureJarScreen(),
              ),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
