import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../core/audio/audio_service.dart';

class JokeDetailScreen extends StatefulWidget {
  final String category;
  final Color themeColor;

  const JokeDetailScreen({
    super.key,
    required this.category,
    required this.themeColor,
  });

  @override
  State<JokeDetailScreen> createState() => _JokeDetailScreenState();
}

class _JokeDetailScreenState extends State<JokeDetailScreen> {
  final Map<String, List<Map<String, String>>> _categorySounds = {
    'PEDOS': [
      {'label': 'Pedo Realista', 'file': 'fart.mp3'},
      {'label': 'Pedo Atómico', 'file': 'pedo1.mp3'},
      {'label': 'Pedo Silvante', 'file': 'pedo2.mp3'},
      {'label': 'Pedo Trompeta', 'file': 'pedo3.mp3'},
      {'label': 'Pedo Largo', 'file': 'pedo4.mp3'},
      {'label': 'Pedo Seco', 'file': 'pedo5.mp3'},
      {'label': 'Pedo Explosivo', 'file': 'pedo6.mp3'},
      {'label': 'Pedo Musical', 'file': 'pedo7.mp3'},
      {'label': 'Pedo Rebotante', 'file': 'pedo8.mp3'},
      {'label': 'Pedo Final', 'file': 'pedo9.mp3'},
    ],
    'CRISTALES': [
      {'label': 'Rotura Fina', 'file': 'Cristales_rotos_1.mp3'},
      {'label': 'Rotura Pesada', 'file': 'Cristales_rotos_2.mp3'},
      {'label': 'Impacto Cristal', 'file': 'Cristales_rotos_3.mp3'},
      {'label': 'Explosión Boom', 'file': 'boom.mp3'},
    ],
    'GRITOS': [
      {'label': 'Grito Pánico 1', 'file': 'grito_miedo_1.mp3'},
      {'label': 'Grito Pánico 2', 'file': 'grito_miedo_2.mp3'},
      {'label': 'Grito Pánico 3', 'file': 'grito_miedo_3.mp3'},
      {'label': 'Grito Pánico 4', 'file': 'grito_miedo_4.mp3'},
    ],
    'GOLPES': [
      {'label': 'Látigo Letal', 'file': 'whip.mp3'},
      {'label': 'Aplauso Irónico', 'file': 'clap.mp3'},
      {'label': 'Efecto Bruh', 'file': 'bruh.mp3'},
    ],
  };

  List<Map<String, String>> _allSounds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllSounds();
  }

  Future<void> _loadAllSounds() async {
    final List<Map<String, String>> sounds = List.from(_categorySounds[widget.category] ?? []);
    
    try {
      final directory = await getApplicationDocumentsDirectory();
      final customSoundsDir = Directory(p.join(directory.path, 'custom_sounds'));
      
      if (await customSoundsDir.exists()) {
        final List<FileSystemEntity> files = customSoundsDir.listSync();
        for (var file in files) {
          if (file is File && file.path.endsWith('.m4a')) {
            final fileName = p.basename(file.path);
            // Formato: custom_categoria_timestamp.m4a
            if (fileName.contains(widget.category.toLowerCase())) {
              sounds.add({
                'label': 'Grabación ${sounds.length - (_categorySounds[widget.category]?.length ?? 0) + 1}',
                'file': file.path,
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error cargando grabaciones: $e");
    }

    setState(() {
      _allSounds = sounds;
      _isLoading = false;
    });
  }

  String _getBackgroundImage() {
    switch (widget.category) {
      case 'PEDOS': return 'assets/images/Gato_Pedo.png';
      case 'CRISTALES': return 'assets/images/Gato_Cristales.png';
      case 'GRITOS': return 'assets/images/Gato_Susto.png';
      case 'GOLPES': return 'assets/images/Gato_Golpes.png';
      default: return 'assets/images/gato_bufon.png';
    }
  }

  void _selectSound(String source, String label) {
    AudioService.playSmart(source);
    // Pequeño delay para que el usuario oiga el inicio del sonido antes de volver
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) Navigator.pop(context, source);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final sounds = _allSounds;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              _getBackgroundImage(),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          ),
          
          // Dark Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        widget.category,
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: widget.themeColor,
                          letterSpacing: -1.5,
                          shadows: [
                            Shadow(color: widget.themeColor.withOpacity(0.5), blurRadius: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Text(
                  "SELECCIONA TU ARMA",
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.white54,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 20),

                // Sounds List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                    itemCount: sounds.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final s = sounds[index];
                      return GestureDetector(
                        onTap: () => _selectSound(s['file']!, s['label']!),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white12, width: 1),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: widget.themeColor.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.play_arrow, color: widget.themeColor, size: 20),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      s['label']!,
                                      style: const TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right, color: Colors.white24),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
