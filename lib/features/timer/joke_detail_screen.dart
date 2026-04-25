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
      case 'CRISTALES': return 'assets/images/Gato_Cristales.jpeg';
      case 'GRITOS': return 'assets/images/Gato_Susto.jpeg';
      case 'GOLPES': return 'assets/images/Gato_Golpes.jpeg';
      default: return 'assets/images/Gato_pensativo.jpeg';
    }
  }

  void _playSound(String source) {
    AudioService.playSmart(source);
  }

  void _loadSound(String source, String label) {
    if (mounted) Navigator.pop(context, {'path': source, 'label': label});
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final sounds = _allSounds;
    final int totalPages = (sounds.length / 2).ceil();

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
          
          // Overlay mucho más suave para iluminar la pantalla
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── HEADER CENTRADO ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      // ── TÍTULO CON IMAGEN PERSONALIZADA ──
                      Image.asset(
                        'assets/images/titulo_${widget.category.toLowerCase()}.png',
                        height: 140, // Altura para que destaque
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          // Si la imagen no existe o falla, volvemos al texto por seguridad
                          return Text(
                            widget.category,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: widget.themeColor,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(color: Colors.black, offset: const Offset(2, 2), blurRadius: 4),
                                Shadow(color: widget.themeColor.withOpacity(0.5), blurRadius: 15),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const Spacer(), // <--- Deja el centro libre para ver el fondo

                // ── LISTADO PAGINADO (DE 2 EN 2) ──
                SizedBox(
                  height: 250, // Altura ajustada para dos tarjetas y el contador
                  child: PageView.builder(
                    itemCount: totalPages,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    itemBuilder: (context, pageIndex) {
                      final startIndex = pageIndex * 2;
                      final endIndex = (startIndex + 2) > sounds.length ? sounds.length : startIndex + 2;
                      final pageSounds = sounds.sublist(startIndex, endIndex);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ...pageSounds.map((s) => _buildSoundCard(s)),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ── CONTADOR DE PÁGINAS ──
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${_currentPage + 1} / $totalPages",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundCard(Map<String, String> s) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _playSound(s['file']!),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    s['label']!,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _loadSound(s['file']!, s['label']!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: widget.themeColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: widget.themeColor.withOpacity(0.5), width: 1.5),
                    ),
                    child: const Text(
                      "CARGAR",
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
