import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class CortaPeloScreen extends StatefulWidget {
  const CortaPeloScreen({super.key});

  @override
  State<CortaPeloScreen> createState() => _CortaPeloScreenState();
}

class _CortaPeloScreenState extends State<CortaPeloScreen> {
  bool _isActive = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  void _toggleCortaPelo() async {
    setState(() {
      _isActive = !_isActive;
    });

    if (_isActive) {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('sounds/Sonido_CortaPelo.mp3'));
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(pattern: [0, 1000], intensities: [255, 255], repeat: 0);
      }
    } else {
      await _audioPlayer.stop();
      Vibration.cancel();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    Vibration.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/CortaPelo_fondo.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.black87,
                child: const Center(
                  child: Text("CortaPelo_fondo.png", style: TextStyle(color: Colors.red)),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // Título
                Positioned(
                  top: -18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/images/CortaPelo.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        "CORTAPELO",
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                // Botón volver
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Botón central de encendido
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: _toggleCortaPelo,
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            if (_isActive)
                              BoxShadow(
                                color: Colors.greenAccent.withOpacity(0.6),
                                blurRadius: 30,
                                spreadRadius: 5,
                              )
                            else
                              BoxShadow(
                                color: Colors.transparent,
                                blurRadius: 30,
                                spreadRadius: 5,
                              ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/images/Boton_CortaPelo.png',
                          width: 350,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 350,
                            height: 350,
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(Icons.power_settings_new, size: 80, color: Colors.white),
                            ),
                          ),
                        ),
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
}
