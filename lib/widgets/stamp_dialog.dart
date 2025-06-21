import 'package:flutter/material.dart';

class StampDialog extends StatelessWidget {
  final String imageUrl;
  final String suggestion;
  final String trend;
  final VoidCallback onOk;

  const StampDialog({
    super.key,
    required this.imageUrl,
    required this.suggestion,
    required this.trend,
    required this.onOk,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0), // Stamp border color
          borderRadius: BorderRadius.circular(2),
        ),
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Full-width Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    return progress == null
                        ? child
                        : const SizedBox(
                          height: 240,
                          child: Center(child: CircularProgressIndicator()),
                        );
                  },
                ),
              ),
              // Suggestion Text
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 16.0,
                ),
                child: Text(
                  suggestion,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Bottom Label for Trend
              Container(
                color: const Color(0xFFD9534F),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  trend.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                  ),
                ),
              ),
              // OK Button
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextButton(onPressed: onOk, child: const Text('OK')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
