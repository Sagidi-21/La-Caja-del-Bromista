# 🃏 La Caja del Bromista (Joker's Box)

Este proyecto es una aplicación de bromas ultra-rápida construida con Flutter.

## 🚀 Pasos para empezar en tu máquina local

Si al ejecutar comandos de Flutter recibes el error `command not found`, sigue estos pasos para configurar tu entorno en Windows:

### 1. Instalación de Flutter
1. Descarga el SDK desde [flutter.dev](https://docs.flutter.dev/get-started/install/windows).
2. Extráelo en una ruta sin espacios, por ejemplo: `C:\src\flutter`.
3. **MUITO IMPORTANTE**: Añade `C:\src\flutter\bin` a tus **Variables de Entorno del Sistema** (dentro de `Path`).

### 2. Verificación
Abre una terminal nueva y ejecuta:
```bash
flutter doctor
```
Esto te guiará sobre qué herramientas (Android Studio, SDKs) necesitas terminar de configurar.

### 3. Poner en marcha la app
Una vez configurado Flutter:
1. Navega a esta carpeta: `cd "La Caja del Bromista"`
2. Ejecuta:
   ```bash
   flutter create .
   flutter pub get
   flutter run
   ```

## 📂 Organización del Proyecto
- `lib/core/audio`: Manejo de baja latencia con pooling de reproductores.
- `lib/core/sensors`: Lógica del modo látigo con acelerómetro.
- `lib/features/soundboard`: Interfaz de usuario táctil acelerada.
- `lib/shared/theme`: Estética Premium Dark con acentos neón.

## 🔊 Sonidos Requeridos
Coloca los archivos `.mp3` en la carpeta `assets/sounds/`:
- `fart.mp3`
- `whip.mp3`
- `boom.mp3`
- `clap.mp3`
- `bruh.mp3`
