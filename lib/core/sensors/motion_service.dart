import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';
import '../audio/audio_service.dart';

class MotionService {
  static bool _isListening = false;
  static int _lastTriggerTime = 0;
  static const int _cooldownMs = 500; // Evitar disparos múltiples en un solo golpe
  static const double _whipThreshold = 25.0;

  static void startWhipDetection() {
    if (_isListening) return;
    _isListening = true;

    accelerometerEvents.listen((AccelerometerEvent event) {
      // Calculamos la magnitud del vector aceleración (G-force bruta)
      double totalForce = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      
      int now = DateTime.now().millisecondsSinceEpoch;

      if (totalForce > _whipThreshold && (now - _lastTriggerTime) > _cooldownMs) {
        _lastTriggerTime = now;
        AudioService.play('whip.mp3');
      }
    });
  }

  static void stopWhipDetection() {
    // En una implementación real, guardaríamos el stream subscription para cancelarlo.
    _isListening = false;
  }
}
