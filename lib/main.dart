import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/audio/audio_service.dart';
import 'shared/theme.dart';
import 'shared/app_shell.dart';

void main() async {
  // Asegurar que el binding de Flutter esté listo
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ocultar barras de sistema para pantalla completa (Modo Inmersivo)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  
  // Pre-carga de audio (Fase B/Solid)
  await AudioService.init();
  
  runApp(const JokersBoxApp());
}

class JokersBoxApp extends StatelessWidget {
  const JokersBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Joker's Box",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AppShell(),
    );
  }
}
