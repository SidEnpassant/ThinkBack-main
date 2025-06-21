import 'package:flutter/material.dart';
import 'package:thinkback4/models/future_jar_model.dart';

class FutureJarCard extends StatelessWidget {
  final FutureJar jar;
  final int daysLeft;

  const FutureJarCard({super.key, required this.jar, required this.daysLeft});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white, // Match MemoryCard style
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Jar Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.ac_unit, // Placeholder Icon
                color: Colors.blueAccent,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),
            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    jar.title,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Opens in $daysLeft days",
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                  ),
                ],
              ),
            ),
            // Lock and Attachment Icons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (jar.attachments.isNotEmpty)
                  const Icon(Icons.attachment, color: Colors.grey, size: 20),
                if (jar.attachments.isNotEmpty) const SizedBox(width: 8),
                const Icon(Icons.lock_outline, color: Colors.grey, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
