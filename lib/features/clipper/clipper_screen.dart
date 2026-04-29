import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class ClipperScreen extends StatefulWidget {
  const ClipperScreen({super.key});

  @override
  State<ClipperScreen> createState() => _ClipperScreenState();
}

class _ClipperScreenState extends State<ClipperScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isActive = false;
  Timer? _vibrationTimer;

  @override
  void dispose() {
    _stopClipper();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startClipper() async {
    if (_isActive) return;
    setState(() => _isActive = true);
    
    // Configurar sonido en bucle infinito
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('sounds/Sonido_CortaPelo.mp3'));

    // Vibración de motor: pesada y constante
    _vibrationTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      HapticFeedback.heavyImpact();
    });
  }

  void _stopClipper() {
    if (!_isActive) return;
    setState(() => _isActive = false);
    _audioPlayer.stop();
    _vibrationTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo de pantalla dinámico
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/CortaPelo_fondo.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(_isActive ? 0.3 : 0.6),
                BlendMode.darken,
              ),
            ),
          ),
        ),
        
        SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Título
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Hero(
                    tag: 'clipper_title',
                    child: Image.asset(
                      'assets/images/CortaPelo.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Botón central de la maquinilla
                GestureDetector(
                  onTapDown: (_) => _startClipper(),
                  onTapUp: (_) => _stopClipper(),
                  onTapCancel: () => _stopClipper(),
                  child: AnimatedScale(
                    scale: _isActive ? 1.1 : 1.0,
                    duration: const Duration(milliseconds: 100),
                    child: Container(
                      width: 240,
                      height: 240,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _isActive 
                                ? Colors.cyanAccent.withOpacity(0.6) 
                                : Colors.black45,
                            blurRadius: _isActive ? 60 : 30,
                            spreadRadius: _isActive ? 15 : 0,
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/images/Boton_CortaPelo.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),

                // Indicador visual de estado
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    children: [
                      Text(
                        _isActive ? "CORTANDO..." : "LISTO PARA LA BROMA",
                        style: GoogleFonts.orbitron(
                          color: _isActive ? Colors.redAccent : Colors.cyanAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Mantén pulsado el motor",
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
