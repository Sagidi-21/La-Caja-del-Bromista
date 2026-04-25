import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FakeCallScreen extends StatefulWidget {
  final String videoPath;
  final String callerName;
  final VideoPlayerController? preloadedController;

  const FakeCallScreen({
    super.key,
    required this.videoPath,
    this.callerName = "Desconocida",
    this.preloadedController,
  });

  @override
  State<FakeCallScreen> createState() => _FakeCallScreenState();
}

class _FakeCallScreenState extends State<FakeCallScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();

    if (widget.preloadedController != null) {
      _controller = widget.preloadedController!;
      _isVideoInitialized = true;
      _controller.setLooping(true);
      _controller.play();
    } else {
      _controller = VideoPlayerController.asset(widget.videoPath)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isVideoInitialized = true;
            });
            _controller.setLooping(true);
            _controller.play();
          }
        }).catchError((error) {
          debugPrint("Error inicializando video: $error");
        });
    }
  }

  @override
  void dispose() {
    if (widget.preloadedController == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── CAPA 1: EL VÍDEO (PANTALLA COMPLETA) ──
          if (_isVideoInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            const Center(child: CircularProgressIndicator(color: Colors.teal)),

          // ── CAPA 2: INTERFAZ WHATSAPP (UI Falsa) ──
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // HEADER (Nombre y opciones)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.expand_more, color: Colors.white, size: 30),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.lock, color: Colors.grey, size: 12),
                              SizedBox(width: 5),
                              Text(
                                "Cifrado de extremo a extremo",
                                style: TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            widget.callerName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "00:14", // Tiempo falso
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.person_add, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // BOTTOM CONTROLS
                Padding(
                  padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // CÁMARA LOCAL FALSA
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: 100,
                          height: 140,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white24, width: 1),
                          ),
                          child: const Center(
                            child: Icon(Icons.person, color: Colors.white38, size: 50),
                          ),
                        ),
                      ),
                      
                      // BOTONERA DE WHATSAPP
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildActionButton(Icons.cameraswitch, Colors.white24),
                            _buildActionButton(Icons.videocam_off, Colors.white24),
                            _buildActionButton(Icons.mic_off, Colors.white24),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.call_end, color: Colors.white, size: 30),
                              ),
                            ),
                          ],
                        ),
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

  Widget _buildActionButton(IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 28),
    );
  }
}
