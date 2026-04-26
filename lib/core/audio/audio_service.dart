import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // En web no podemos pre-cargar con setSource+resume — usamos instancias nuevas por cada play.
  // En mobile mantenemos instancias frescas para máxima fiabilidad.

  static const List<String> _mvpSounds = [
    'fart.mp3',
    'whip.mp3',
    'boom.mp3',
    'clap.mp3',
    'bruh.mp3',
  ];

  /// Inicializa el servicio (ahora simplificado).
  static Future<void> init() async {
    // No necesitamos pre-cargar si usamos instancias frescas para máxima fiabilidad.
    return;
  }

  /// Reproduce el sonido. Compatible con web y mobile.
  static Future<void> play(String soundName) async {
    try {
      final player = AudioPlayer();
      // Configuramos el asset source
      final source = AssetSource('sounds/$soundName');
      
      // Reproducimos
      await player.play(source);
      
      // Liberamos el player cuando termine la reproducción para evitar fugas de memoria
      player.onPlayerComplete.listen((_) {
        player.dispose();
      });
    } catch (e) {
      debugPrint("Error reproduciendo sonido $soundName: $e");
    }
  }

  /// Reproduce un archivo desde una ruta local (para grabaciones).
  static Future<void> playFromFile(String filePath) async {
    final player = AudioPlayer();
    await player.play(DeviceFileSource(filePath));
    player.onPlayerComplete.listen((_) => player.dispose());
  }

  /// Reproduce un sonido detectando si es asset o archivo local.
  static Future<void> playSmart(String source) async {
    if (source.contains('/') || source.contains('\\')) {
      await playFromFile(source);
    } else {
      await play(source);
    }
  }

  /// Para uso en timers (sonido programado con delay).
  static void playWithDelay(String source, int seconds) {
    Timer(Duration(seconds: seconds), () => playSmart(source));
  }
}

