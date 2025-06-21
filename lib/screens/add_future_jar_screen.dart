import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thinkback4/models/future_jar_model.dart';
import 'package:thinkback4/providers/future_jar_provider.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AddFutureJarScreen extends StatefulWidget {
  const AddFutureJarScreen({super.key});

  @override
  _AddFutureJarScreenState createState() => _AddFutureJarScreenState();
}

class _AddFutureJarScreenState extends State<AddFutureJarScreen> {
  final _pageController = PageController();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  DateTime? _selectedDate;
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _errorMessage;
  int _currentPage = 0;
  final int _totalPages = 4;

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now.add(const Duration(days: 1)),
      lastDate: DateTime(now.year + 100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _saveJar() async {
    // Final validation
    if (_titleController.text.isEmpty ||
        _messageController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all required fields.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('No auth token found');
      final uri = Uri.parse(
        'https://thinkbackbackend.onrender.com/api/locked-in',
      );
      final request =
          http.MultipartRequest('POST', uri)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['title'] = _titleController.text
            ..fields['unlockDate'] =
                '${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.year}'
            ..fields['message'] = _messageController.text;

      if (_pickedImage != null) {
        String ext = _pickedImage!.path.split('.').last.toLowerCase();
        MediaType contentType =
            (ext == 'jpg' || ext == 'jpeg')
                ? MediaType('image', 'jpeg')
                : MediaType('image', 'png');
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _pickedImage!.path,
            contentType: contentType,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        if (!mounted) return;
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to add future jar: ' + response.body);
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _nextPage() {
    // Add validation before proceeding
    if (_currentPage == 0 && _titleController.text.isEmpty) return;
    if (_currentPage == 1 && _messageController.text.isEmpty) return;
    if (_currentPage == 2 && _selectedDate == null) return;

    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Create a Future Jar',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 12.0,
            ),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / _totalPages,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.blueAccent,
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStep(
                  title: 'First, give your future memory a title.',
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g., Advice for my future self',
                    ),
                    onChanged: (val) => setState(() {}),
                  ),
                ),
                _buildStep(
                  title: 'What message do you want to send?',
                  child: TextFormField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      labelText: 'Message',
                      hintText: 'Write a letter to your future self...',
                    ),
                    onChanged: (val) => setState(() {}),
                  ),
                ),
                _buildStep(
                  title: 'When should this memory unlock?',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No date chosen'
                            : DateFormat.yMMMMd().format(_selectedDate!),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _presentDatePicker,
                        child: const Text('Choose a Date'),
                      ),
                    ],
                  ),
                ),
                _buildStep(
                  title: 'Add a photo to this memory (optional).',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _pickedImage == null
                          ? OutlinedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.image),
                            label: const Text('Attach Image'),
                          )
                          : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_pickedImage!, height: 150),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildNavigation(),
        ],
      ),
    );
  }

  Widget _buildStep({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildNavigation() {
    bool isNextEnabled = true;
    if (_currentPage == 0) isNextEnabled = _titleController.text.isNotEmpty;
    if (_currentPage == 1) isNextEnabled = _messageController.text.isNotEmpty;
    if (_currentPage == 2) isNextEnabled = _selectedDate != null;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentPage > 0)
                TextButton(onPressed: _previousPage, child: const Text('Back')),
              const Spacer(),
              if (_currentPage < _totalPages - 1)
                ElevatedButton(
                  onPressed: isNextEnabled ? _nextPage : null,
                  child: const Text('Next'),
                )
              else
                ElevatedButton(
                  onPressed: _isUploading ? null : _saveJar,
                  child:
                      _isUploading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : const Text('Save'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
