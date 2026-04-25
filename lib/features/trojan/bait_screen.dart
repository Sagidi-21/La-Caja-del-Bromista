import 'package:flutter/material.dart';
import 'dart:async';
import 'incoming_call_screen.dart';

class BaitScreen extends StatefulWidget {
  final String type;
  final double duration;
  final String callerName;
  final String avatarPath;
  final String videoPath;

  const BaitScreen({
    super.key,
    required this.type,
    required this.duration,
    required this.callerName,
    required this.avatarPath,
    required this.videoPath,
  });

  @override
  State<BaitScreen> createState() => _BaitScreenState();
}

class _BaitScreenState extends State<BaitScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Iniciar el temporizador para la transición automática
    _timer = Timer(Duration(milliseconds: (widget.duration * 1000).toInt()), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IncomingCallScreen(
              callerName: widget.callerName,
              avatarPath: widget.avatarPath,
              videoPath: widget.videoPath,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.type == 'Viral' ? Colors.black : Colors.white,
      body: _buildBaitContent(),
    );
  }

  Widget _buildBaitContent() {
    switch (widget.type) {
      case 'Viral':
        return _buildViralBait();
      case 'Noticia':
        return _buildNewsBait();
      case 'Sorteo':
        return _buildGiftBait();
      default:
        return _buildViralBait();
    }
  }

  // DISEÑO 1: VÍDEO VIRAL
  Widget _buildViralBait() {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                aspectRatio: 16 / 9,
                color: Colors.grey[900],
                child: const Icon(Icons.play_circle_fill, size: 80, color: Colors.white70),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "¡TIENES QUE VER ESTO! 😱",
                      style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "4.2M visualizaciones • Hace 2 horas",
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const CircleAvatar(backgroundColor: Colors.red, radius: 15),
                        const SizedBox(width: 10),
                        const Text("ViralWorld TV", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                          child: const Text("SUSCRIBIRSE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: Row(
            children: const [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(width: 20),
              Icon(Icons.search, color: Colors.white),
            ],
          ),
        ),
      ],
    );
  }

  // DISEÑO 2: NOTICIA DE ÚLTIMA HORA
  Widget _buildNewsBait() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, bottom: 15, left: 20, right: 20),
            color: const Color(0xFFC62828),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("MUNDO ACTUAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1.5)),
                Icon(Icons.menu, color: Colors.white),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ÚLTIMA HORA",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Fenómeno inexplicable captado en vídeo: El suceso que conmociona a las redes sociales hoy mismo.",
                  style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text("Por Redacción Mundo", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const Spacer(),
                    const Text("Hace 5 minutos", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Divider(height: 40),
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Fuentes locales confirman que el vídeo fue grabado hace escasas horas. Según los testigos presenciales, lo que empezó como una broma terminó en algo que nadie puede explicar. El vídeo completo se ha filtrado y puedes verlo a continuación...",
                  style: TextStyle(color: Colors.black87, fontSize: 16, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // DISEÑO 3: SORTEO / REGALO
  Widget _buildGiftBait() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.card_giftcard, size: 100, color: Colors.amber),
          const SizedBox(height: 30),
          const Text(
            "¡ENHORABUENA! 🎉",
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Has sido seleccionado para recibir un Cheque Regalo de 500€ por ser un usuario activo en tu zona.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 18, height: 1.4),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text("RECLAMAR PREMIO", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(width: 10),
                Icon(Icons.arrow_forward, color: Colors.black),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "La oferta caduca en: 01:54",
            style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
