import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/memory_entry_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../services/memory_service.dart';
import '../navigation_container.dart';

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
  late TextEditingController _descController;
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  File? _selectedImage;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<MemoryEntryProvider>(context, listen: false);
    _descController = TextEditingController(text: provider.textEntry);
    _descController.addListener(() {
      provider.setTextEntry(_descController.text);
    });
    _titleController = TextEditingController(text: provider.title);
    _titleController.addListener(() {
      provider.setTitle(_titleController.text);
    });
    _locationController = TextEditingController(text: provider.location);
    _locationController.addListener(() {
      provider.setLocation(_locationController.text);
    });
  }

  @override
  void dispose() {
    _descController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
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
            // Title Field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Location Field
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Description Field
            Expanded(
              child: TextField(
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                style: const TextStyle(fontSize: 18),
                controller: _descController,
              ),
            ),
            const SizedBox(height: 16),
            // Image Picker
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Attach Image'),
                ),
                const SizedBox(width: 12),
                if (_selectedImage != null)
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (_isUploading ||
                            _titleController.text.isEmpty ||
                            _descController.text.isEmpty ||
                            _locationController.text.isEmpty)
                        ? null
                        : () async {
                          setState(() {
                            _isUploading = true;
                            _errorMessage = null;
                          });
                          try {
                            await MemoryService().uploadTextMemory(
                              title: _titleController.text,
                              description: _descController.text,
                              location: _locationController.text,
                              imageFile: _selectedImage,
                            );
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => NavigationContainer(),
                              ),
                              (route) => false,
                            );
                          } catch (e) {
                            setState(() {
                              _errorMessage = e.toString().replaceFirst(
                                'Exception: ',
                                '',
                              );
                            });
                          } finally {
                            setState(() {
                              _isUploading = false;
                            });
                          }
                        },
                child:
                    _isUploading
                        ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text('Upload'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
