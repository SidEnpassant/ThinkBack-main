import 'package:image_picker/image_picker.dart';

class FutureJar {
  final String id;
  final String title;
  final String message;
  final String imageUrl;
  final DateTime unlockDate;
  final String? category;
  final List<XFile> attachments;

  FutureJar({
    required this.id,
    required this.title,
    required this.message,
    required this.imageUrl,
    required this.unlockDate,
    this.category,
    this.attachments = const [],
  });

  factory FutureJar.fromJson(Map<String, dynamic> json) {
    return FutureJar(
      id: json['_id'],
      title: json['title'] ?? 'No Title',
      message: json['message'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      unlockDate: DateTime.parse(json['unlockDate']),
      category: json['category'],
    );
  }
}
