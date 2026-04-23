import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class RecorderService {
  final _audioRecorder = AudioRecorder();
  String? _lastPath;

  Future<bool> hasPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> startRecording() async {
    if (await _audioRecorder.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();
      final tempPath = p.join(directory.path, 'temp_recording.m4a');
      
      const config = RecordConfig();
      
      await _audioRecorder.start(config, path: tempPath);
    }
  }

  Future<String?> stopRecording() async {
    final path = await _audioRecorder.stop();
    _lastPath = path;
    return path;
  }

  Future<String?> saveRecording(String category) async {
    if (_lastPath == null) return null;

    final directory = await getApplicationDocumentsDirectory();
    final customSoundsDir = Directory(p.join(directory.path, 'custom_sounds'));
    if (!await customSoundsDir.exists()) {
      await customSoundsDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final fileName = 'custom_${category.toLowerCase()}_$timestamp.m4a';
    final newPath = p.join(customSoundsDir.path, fileName);

    final file = File(_lastPath!);
    if (await file.exists()) {
      await file.copy(newPath);
      // Opcional: borrar el temporal
      await file.delete();
      return newPath;
    }
    
    return null;
  }

  void dispose() {
    _audioRecorder.dispose();
  }
}
