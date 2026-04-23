# 🃏 The Joker's Box — MVP Técnico

## 🎯 Objetivo MVP

Construir una app funcional en 5–7 días con:

* 4 sonidos principales
* 1 trigger por sensor
* 1 sistema simple de sugerencias (Chaos Assistant)
* UI rápida tipo "botonera"

---

# 🧱 Stack Tecnológico

## Recomendado:

* **Frontend:** Flutter
* **Audio:** audioplayers
* **Sensores:** sensors_plus
* **Estado:** simple (Provider o Riverpod)

---

# 📁 Estructura de Carpetas

```
lib/
│
├── main.dart
│
├── core/
│   ├── audio/
│   │   ├── audio_service.dart
│   │   └── sound_model.dart
│   │
│   ├── sensors/
│   │   └── motion_service.dart
│   │
│   ├── timer/
│   │   └── timer_service.dart
│   │
│   └── chaos/
│       └── chaos_engine.dart
│
├── features/
│   ├── soundboard/
│   │   ├── soundboard_screen.dart
│   │   └── sound_button.dart
│   │
│   ├── prank_modes/
│   │   ├── fart_timer.dart
│   │   ├── broken_screen.dart
│   │   └── whip_mode.dart
│   │
│   └── assistant/
│       └── chaos_widget.dart
│
├── shared/
│   ├── theme.dart
│   └── constants.dart
│
└── assets/
    ├── sounds/
    └── images/
```

---

# 🔊 Audio Service (core del producto)

```dart
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> play(String path) async {
    await _player.play(AssetSource(path));
  }

  Future<void> playWithVolume(String path, double volume) async {
    await _player.setVolume(volume);
    await _player.play(AssetSource(path));
  }
}
```

---

# 📱 Botón de Sonido (UI base)

```dart
import 'package:flutter/material.dart';
import '../../core/audio/audio_service.dart';

class SoundButton extends StatelessWidget {
  final String label;
  final String soundPath;

  const SoundButton({
    required this.label,
    required this.soundPath,
  });

  @override
  Widget build(BuildContext context) {
    final audio = AudioService();

    return ElevatedButton(
      onPressed: () => audio.play(soundPath),
      child: Text(label),
    );
  }
}
```

---

# 🕒 Timer Service (pedo programado)

```dart
import 'dart:async';

class TimerService {
  void triggerAfter(int seconds, Function callback) {
    Timer(Duration(seconds: seconds), () {
      callback();
    });
  }
}
```

Uso:

```dart
timerService.triggerAfter(10, () {
  audioService.play("sounds/fart.mp3");
});
```

---

# 📳 Motion Service (látigo)

```dart
import 'package:sensors_plus/sensors_plus.dart';

class MotionService {
  void listenForWhip(Function onWhip) {
    accelerometerEvents.listen((event) {
      double force = event.x.abs() + event.y.abs() + event.z.abs();

      if (force > 25) {
        onWhip();
      }
    });
  }
}
```

---

# 🤖 Chaos Engine (reglas simples pero efectivas)

```dart
class ChaosEngine {

  String suggest(double noiseLevel, int inactivitySeconds) {

    if (noiseLevel < 20) {
      return "fart";
    }

    if (noiseLevel > 70) {
      return "applause";
    }

    if (inactivitySeconds > 60) {
      return "finisher";
    }

    return "random";
  }
}
```

---

# 🎛️ Pantalla Principal (Soundboard MVP)

```dart
import 'package:flutter/material.dart';
import 'sound_button.dart';

class SoundboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Joker's Box")),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          SoundButton(label: "💨 Fart", soundPath: "sounds/fart.mp3"),
          SoundButton(label: "👏 Clap", soundPath: "sounds/clap.mp3"),
          SoundButton(label: "💀 Finisher", soundPath: "sounds/boom.mp3"),
          SoundButton(label: "⚡ Whip", soundPath: "sounds/whip.mp3"),
        ],
      ),
    );
  }
}
```

---

# 🧪 MVP Scope (NO te pases de esto)

Incluye SOLO:

* 4 sonidos
* 1 timer
* 1 motion trigger
* 1 pantalla

NO incluyas:

* login
* backend
* animaciones complejas
* IA real

---

# 🔥 Sonidos MÁS VIRALES (esto es lo importante)

Si fallas aquí, la app muere.

## Tier S (imprescindibles)

* Pedo realista (no cartoon)
* Pedo silencioso + explosivo (delay)
* Golpe seco tipo "vine boom"
* Aplauso irónico (slow clap)

## Tier A

* Látigo
* Risa malvada
* "Bruh" sound
* Sirena policía corta

## Tier B

* Grito terror
* Cristal roto
* Error Windows
* Boo (abucheo)

---

# 🎯 Cómo hacerlos virales

* Duración: 0.5s – 2s
* Ataque inmediato (sin fade in)
* Volumen alto (pero no distorsionado)
* Reconocibles en <300ms

---

# 🚀 Siguiente paso recomendado

1. Construir MVP en 3 días
2. Testear con amigos (IMPORTANTE)
3. Medir:

   * qué sonido repiten
   * cuándo lo usan
4. Iterar SOLO sobre eso

---

# 💡 Insight clave

La app no va de sonidos.

Va de:
👉 timing social
👉 incomodidad controlada
👉 recompensa inmediata

Si eso funciona → tienes algo viral.
