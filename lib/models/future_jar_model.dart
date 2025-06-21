import 'package:image_picker/image_picker.dart';

class FutureJar {
  final String id;
  final String title;
  final String message;
  final DateTime unlockDate;
  final String? category;
  final List<XFile> attachments;

  FutureJar({
    required this.id,
    required this.title,
    required this.message,
    required this.unlockDate,
    this.category,
    this.attachments = const [],
  });
}
