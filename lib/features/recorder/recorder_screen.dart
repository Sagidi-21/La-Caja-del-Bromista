import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
import '../../core/audio/recorder_service.dart';
import '../../core/audio/audio_service.dart';
import '../../shared/shared_sidebar.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({super.key});

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  final RecorderService _recorderService = RecorderService();
  bool _isRecording = false;
  String? _recordedPath;
  String? _selectedCategory;
  final Map<String, bool> _pressedCajas = {};
  
  Timer? _timer;
  int _seconds = 0;

  @override
  void dispose() {
    _recorderService.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startRecording() async {
    final hasPermission = await _recorderService.hasPermission();
    if (!hasPermission) return;

    await _recorderService.startRecording();
    setState(() {
      _isRecording = true;
      _recordedPath = null;
      _seconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _seconds++);
    });
  }

  void _stopRecording() async {
    final path = await _recorderService.stopRecording();
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _recordedPath = path;
    });
  }

  void _playTest() {
    if (_recordedPath != null) {
      AudioService.playFromFile(_recordedPath!);
    }
  }

  void _saveRecording() async {
    if (_recordedPath == null || _selectedCategory == null) return;

    final newPath = await _recorderService.saveRecording(_selectedCategory!);
    if (newPath != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: _getCategoryColor(_selectedCategory!),
            content: Text("GUARDADO EN: $_selectedCategory", 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'SpaceGrotesk')),
          ),
        );
      }
      setState(() {
        _recordedPath = null;
        _selectedCategory = null; // Volvemos a la selección
      });
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'PEDOS': return Colors.redAccent;
      case 'CRISTALES': return Colors.blueAccent;
      case 'GRITOS': return Colors.amber;
      case 'GOLPES': return Colors.purpleAccent;
      default: return Colors.greenAccent;
    }
  }

  String _getBackgroundImage() {
    if (_selectedCategory == null) return 'assets/images/Gato_Grabando.png';
    switch (_selectedCategory) {
      case 'PEDOS': return 'assets/images/Gato_Pedo.png';
      case 'CRISTALES': return 'assets/images/Gato_Cristales.png';
      case 'GRITOS': return 'assets/images/Gato_Susto.png';
      case 'GOLPES': return 'assets/images/Gato_Golpes.png';
      default: return 'assets/images/Gato_Grabando.png';
    }
  }

  Widget _buildCategorySelection() {
    return Column(
      children: [
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Column(
            children: [
              _buildCajaOption('Caja_roja_normal.png', 'Caja_roja_intensa.png', 'PEDOS', Colors.redAccent),
              const SizedBox(height: 16),
              _buildCajaOption('Caja_azul_normal.png', 'Caja_azul_intensa.png', 'CRISTALES', Colors.blueAccent),
              const SizedBox(height: 16),
              _buildCajaOption('Caja_oro_normal.png', 'Caja_oro_intensa.png', 'GRITOS', Colors.amber),
              const SizedBox(height: 16),
              _buildCajaOption('Caja_morada_normal.png', 'Caja_morada_intensa.png', 'GOLPES', Colors.purpleAccent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecordingArea() {
    return Column(
      children: [
        const SizedBox(height: 40),
        // Botón de Volver
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => setState(() => _selectedCategory = null),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _isRecording ? Colors.red : Colors.white12, width: 2),
            boxShadow: [
              BoxShadow(
                color: _isRecording ? Colors.red.withOpacity(0.3) : Colors.black45,
                blurRadius: 30,
              )
            ],
          ),
          child: Column(
            children: [
              Text(
                "CATEGORÍA: $_selectedCategory",
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  color: _getCategoryColor(_selectedCategory!),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: _isRecording ? _stopRecording : _startRecording,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isRecording ? Colors.red : const Color(0xFFDDFFAE),
                    boxShadow: [
                      BoxShadow(
                        color: (_isRecording ? Colors.red : const Color(0xFFDDFFAE)).withOpacity(0.5),
                        blurRadius: 30,
                      )
                    ],
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.black,
                    size: 56,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isRecording)
                Text(
                  "00:${_seconds.toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              if (_recordedPath != null && !_isRecording) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _playTest,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text("PROBAR"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD873FF),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _saveRecording,
                      icon: const Icon(Icons.save),
                      label: const Text("GUARDAR"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDDFFAE),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCajaOption(String assetNormal, String assetIntensa, String label, Color color) {
    final bool isPressed = _pressedCajas[label] ?? false;
    final String currentAsset = isPressed
        ? 'assets/images/$assetIntensa'
        : 'assets/images/$assetNormal';

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 1.2,
            fontFamily: 'SpaceGrotesk',
            shadows: [
              Shadow(color: Colors.black, offset: const Offset(2, 2), blurRadius: 4),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTapDown: (_) => setState(() => _pressedCajas[label] = true),
          onTapUp: (_) {
            setState(() {
              _pressedCajas[label] = false;
              _selectedCategory = label;
            });
          },
          onTapCancel: () => setState(() => _pressedCajas[label] = false),
          child: SizedBox(
            width: 100,
            height: 100,
            child: Image.asset(
              currentAsset,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, st) => Icon(Icons.inventory_2, color: color, size: 50),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Imagen de fondo dinámica
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Image.asset(
                _getBackgroundImage(),
                key: ValueKey(_getBackgroundImage()),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
              ),
            ),
          ),
          
          // Overlay para legibilidad
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.8),
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
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "GRABA TU PROPIA BROMA",
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                          color: Color(0xFFDDFFAE),
                          letterSpacing: -1.0,
                        ),
                      ),
                      Builder(
                        builder: (ctx) => GestureDetector(
                          onTap: () => Scaffold.of(ctx).openEndDrawer(),
                          child: const Icon(Icons.menu, color: Color(0xFFD873FF), size: 30),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _selectedCategory == null 
                          ? _buildCategorySelection() 
                          : _buildRecordingArea(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      endDrawer: SharedSidebar(
        currentIndex: 4,
        onNavigate: (index) {
          // Navegación handled by AppShell
        },
      ),
    );
  }
}
