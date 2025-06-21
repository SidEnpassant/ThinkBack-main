import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thinkback4/models/future_jar_model.dart';
import 'package:thinkback4/providers/future_jar_provider.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';

class AddFutureJarScreen extends StatefulWidget {
  const AddFutureJarScreen({super.key});

  @override
  _AddFutureJarScreenState createState() => _AddFutureJarScreenState();
}

class _AddFutureJarScreenState extends State<AddFutureJarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime? _selectedDate;
  List<XFile> _pickedFiles = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFiles() async {
    final List<XFile> result = await _picker.pickMultipleMedia();

    if (result.isNotEmpty) {
      setState(() {
        _pickedFiles.addAll(result);
      });
    }
  }

  void _removeFile(XFile file) {
    setState(() {
      _pickedFiles.remove(file);
    });
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: DateTime(now.year + 100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveJar() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an unlock date.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      final newJar = FutureJar(
        id: Random().nextDouble().toString(), // Simple unique ID
        title: _titleController.text,
        message: _messageController.text,
        unlockDate: _selectedDate!,
        category:
            _categoryController.text.isNotEmpty
                ? _categoryController.text
                : null,
        attachments: _pickedFiles,
      );

      Provider.of<FutureJarProvider>(context, listen: false).addJar(newJar);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Add to Your Future',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          TextButton(
            onPressed: _saveJar,
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., Advice for my future self',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  hintText: 'Write a letter to your future self...',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category (Optional)',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., For your wedding day',
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No unlock date chosen'
                          : 'Unlocks on: ${DateFormat.yMd().format(_selectedDate!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: const Text('CHOOSE DATE'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Attachments section
              OutlinedButton.icon(
                onPressed: _pickFiles,
                icon: const Icon(Icons.attach_file),
                label: const Text('Attach Files'),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children:
                    _pickedFiles
                        .map(
                          (file) => Chip(
                            label: Text(file.name),
                            onDeleted: () => _removeFile(file),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
