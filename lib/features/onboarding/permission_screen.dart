import 'package:flutter/material.dart';
import '../../shared/theme.dart';

class PermissionScreen extends StatelessWidget {
  final VoidCallback onAccepted;
  final VoidCallback onDenied;

  const PermissionScreen({
    super.key,
    required this.onAccepted,
    required this.onDenied,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mic_none, size: 64, color: AppTheme.accentNeon),
          const SizedBox(height: 24),
          const Text(
            "MODO CAOS REQUIERE OÍDO",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.accentNeon,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            "El Asistente del Caos analiza SOLO el nivel de ruido ambiental para sugerir la mejor broma. \n\n🔒 Todo se procesa en tu dispositivo. Nada se graba ni se envía.",
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentNeon,
                foregroundColor: Colors.black,
              ),
              onPressed: onAccepted,
              child: const Text("ACTIVAR MODO CAOS 😈"),
            ),
          ),
          TextButton(
            onPressed: onDenied,
            child: const Text("AHORA NO", style: TextStyle(color: Colors.white38)),
          ),
        ],
      ),
    );
  }
}
