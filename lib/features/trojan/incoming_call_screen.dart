import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'fake_call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callerName;
  final String avatarPath;
  final String videoPath;

  const IncomingCallScreen({
    super.key,
    required this.callerName,
    required this.avatarPath,
    required this.videoPath,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  VideoPlayerController? _preloadedVideoController;
  bool _isAccepted = false; // Bandera para saber si hemos aceptado la llamada

  @override
  void initState() {
    super.initState();
    _playRingtone();
    _prepareVideo(); // Empezamos a cargar el video aquí
  }

  Future<void> _playRingtone() async {
    try {
      // Configuramos el audio de forma asíncrona para no bloquear la UI
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
      _audioPlayer.play(AssetSource('sounds/whatsapp_incoming.mp3'), volume: 1.0);
    } catch (e) {
      debugPrint("Error al reproducir el tono: $e");
    }
  }

  void _prepareVideo() {
    _preloadedVideoController = VideoPlayerController.asset(widget.videoPath);
    _preloadedVideoController?.initialize().then((_) {
      // El video ya está listo en memoria, pero no lo reproducimos aún
      setState(() {});
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    
    // Si NO hemos aceptado la llamada, tenemos que liberar el vídeo aquí
    if (!_isAccepted) {
      _preloadedVideoController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── FONDO DESENFOCADO (LA FOTO) ──
          Positioned.fill(
            child: Image.asset(
              widget.avatarPath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: const Color(0xFF075E54)),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone_in_talk, color: Colors.white70, size: 16),
                          SizedBox(width: 8),
                          Text(
                            "VIDEOLLAMADA DE WHATSAPP",
                            style: TextStyle(
                              color: Colors.white70,
                              letterSpacing: 1.5,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.callerName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                // AVATAR CENTRAL (Círculo)
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white12, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      widget.avatarPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 100, color: Colors.white24),
                    ),
                  ),
                ),

                // CONTROLES INFERIORES
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    children: [
                      const Text(
                        "Desliza hacia arriba para aceptar",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Botón Rechazar
                          Column(
                            children: [
                              _buildCallButton(
                                icon: Icons.call_end,
                                color: Colors.red,
                                onTap: () {
                                  _audioPlayer.stop();
                                  Navigator.pop(context, false);
                                },
                              ),
                              const SizedBox(height: 8),
                              const Text("Rechazar", style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                          // Botón Aceptar
                          Column(
                            children: [
                              _buildCallButton(
                                icon: Icons.videocam,
                                color: Colors.green,
                                onTap: () {
                                  _audioPlayer.stop();
                                  setState(() => _isAccepted = true); // Marcamos como aceptada
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FakeCallScreen(
                                        videoPath: widget.videoPath,
                                        callerName: widget.callerName,
                                        preloadedController: _preloadedVideoController,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              const Text("Aceptar", style: TextStyle(color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 35),
      ),
    );
  }
}
