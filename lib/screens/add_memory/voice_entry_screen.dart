import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../../providers/memory_entry_provider.dart';
import 'dart:io';
import '../../services/memory_service.dart';
import '../navigation_container.dart';

class VoiceEntryScreen extends StatefulWidget {
  const VoiceEntryScreen({super.key});

  @override
  State<VoiceEntryScreen> createState() => _VoiceEntryScreenState();
}

class _VoiceEntryScreenState extends State<VoiceEntryScreen> {
  late final AudioRecorder _recorder;
  String? _recordedFilePath;
  bool _isRecording = false;
  bool _isPaused = false;
  Duration _recordDuration = Duration.zero;
  Timer? _timer;
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  bool _isUploading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _recorder = AudioRecorder();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied.')),
      );
      return;
    }
    final dir = await getTemporaryDirectory();
    final filePath =
        '${dir.path}/voice_entry_${DateTime.now().millisecondsSinceEpoch}.wav';
    debugPrint('Recording with encoder: wav (.wav)');
    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: filePath,
    );
    setState(() {
      _isRecording = true;
      _isPaused = false;
      _recordedFilePath = null;
      _recordDuration = Duration.zero;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final seconds = _recordDuration.inSeconds + 1;
      if (seconds >= 60) {
        await _stopRecording();
      } else {
        setState(() {
          _recordDuration = Duration(seconds: seconds);
        });
      }
    });
  }

  Future<void> _pauseRecording() async {
    await _recorder.pause();
    setState(() {
      _isPaused = true;
    });
    _timer?.cancel();
  }

  Future<void> _resumeRecording() async {
    await _recorder.resume();
    setState(() {
      _isPaused = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final seconds = _recordDuration.inSeconds + 1;
      if (seconds >= 60) {
        await _stopRecording();
      } else {
        setState(() {
          _recordDuration = Duration(seconds: seconds);
        });
      }
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _isPaused = false;
      _recordedFilePath = path;
    });
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
          'Voice Entry',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: provider.setTitle,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: provider.setLocation,
            ),
            const SizedBox(height: 24),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child:
                    _isRecording
                        ? const Icon(
                          Icons.mic,
                          size: 64,
                          color: Colors.redAccent,
                        )
                        : const Icon(
                          Icons.graphic_eq,
                          size: 64,
                          color: Colors.blueAccent,
                        ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _recordDuration.toString().split('.').first.padLeft(8, "0"),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 24),
                if (!_isRecording && _recordedFilePath == null)
                  IconButton(
                    icon: const Icon(
                      Icons.fiber_manual_record,
                      color: Colors.red,
                      size: 32,
                    ),
                    onPressed: _startRecording,
                  ),
                if (_isRecording && !_isPaused)
                  IconButton(
                    icon: const Icon(Icons.pause, size: 32),
                    onPressed: _pauseRecording,
                  ),
                if (_isRecording && _isPaused)
                  IconButton(
                    icon: const Icon(Icons.play_arrow, size: 32),
                    onPressed: _resumeRecording,
                  ),
                if (_isRecording)
                  IconButton(
                    icon: const Icon(Icons.stop, size: 32),
                    onPressed: _stopRecording,
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isRecording)
              const Text(
                'Recording... (max 1 minute)',
                style: TextStyle(color: Colors.redAccent),
              ),
            if (!_isRecording && _recordedFilePath != null)
              const Text('Recording complete.'),
            const SizedBox(height: 24),
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
                            _locationController.text.isEmpty ||
                            _recordedFilePath == null)
                        ? null
                        : () async {
                          setState(() {
                            _isUploading = true;
                            _errorMessage = null;
                          });
                          try {
                            await MemoryService().uploadVoiceMemory(
                              title: _titleController.text,
                              location: _locationController.text,
                              voiceFile: File(_recordedFilePath!),
                            );
                            if (!mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const NavigationContainer(),
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
