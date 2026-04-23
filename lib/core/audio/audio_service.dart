import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  // En web no podemos pre-cargar con setSource+resume — usamos instancias nuevas por cada play.
  // En mobile mantenemos el pool para baja latencia.
  static final Map<String, AudioPlayer> _playerPool = {};

  static const List<String> _mvpSounds = [
    'fart.mp3',
    'whip.mp3',
    'boom.mp3',
    'clap.mp3',
    'bruh.mp3',
  ];

  /// Inicializa el pool de reproductores (solo en plataformas nativas).
  static Future<void> init() async {
    if (kIsWeb) {
      // En web no pre-cargamos; AudioPlayer en web reproduce directamente.
      return;
    }
    for (var sound in _mvpSounds) {
      final player = AudioPlayer();
      await player.setSource(AssetSource('sounds/$sound'));
      _playerPool[sound] = player;
    }
  }

  /// Reproduce el sonido. Compatible con web y mobile.
  static Future<void> play(String soundName) async {
    if (kIsWeb) {
      // En web: cada click crea un AudioPlayer temporal y reproduce el asset.
      // AudioPlayer en web resuelve AssetSource como ruta relativa al directorio assets/.
      final player = AudioPlayer();
      await player.play(AssetSource('sounds/$soundName'));
      // Liberamos el player cuando termine
      player.onPlayerComplete.listen((_) => player.dispose());
      return;
    }

    // Mobile: pool de baja latencia
    final player = _playerPool[soundName];
    if (player != null) {
      await player.stop();
      await player.resume();
    } else {
      final newPlayer = AudioPlayer();
      await newPlayer.play(AssetSource('sounds/$soundName'));
    }
  }

  /// Para uso en timers (sonido programado con delay).
  static void playWithDelay(String soundName, int seconds) {
    Timer(Duration(seconds: seconds), () => play(soundName));
  }
}
