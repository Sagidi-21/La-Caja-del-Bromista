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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Iniciar el temporizador para la transición automática
    _timer = Timer(Duration(milliseconds: (widget.duration * 1000).toInt()), () {
      _jumpToCall();
    });
  }

  Future<void> _jumpToCall() async {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    
    int retries = 0;
    bool accepted = false;

    while (retries < 3 && !accepted && mounted) {
      // Lanzamos la pantalla de llamada y esperamos el resultado
      // Usamos push en lugar de pushReplacement para poder capturar el retorno
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IncomingCallScreen(
            callerName: widget.callerName,
            avatarPath: widget.avatarPath,
            videoPath: widget.videoPath,
          ),
        ),
      );

      // Si el resultado es true, es que la llamada se completó o aceptó (según lógica)
      // En este caso, si result es null o false, es que colgaron/rechazaron
      if (result == true) {
        accepted = true;
        break; 
      }

      retries++;
      if (retries < 3 && mounted) {
        // Esperar 5 segundos antes del siguiente intento
        await Future.delayed(const Duration(seconds: 5));
      }
    }

    // Una vez terminados los reintentos o aceptada, volvemos atrás (al TrojanScreen)
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
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
              GestureDetector(
                onTap: _jumpToCall, // Salto inmediato al pulsar Play
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    width: double.infinity,
                    color: Colors.grey[900],
                    child: const Icon(Icons.play_circle_fill, size: 80, color: Colors.white70),
                  ),
                ),
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
                  "ÚLTIMA HORA: VALENCIA",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 10),
                const Text(
                  "¡PÁNICO EN VALENCIA! Captan un objeto no identificado sobrevolando el Nou Mestalla.",
                  style: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text("Por Redacción Levante", style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const Spacer(),
                    const Text("Hace 2 minutos", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
                const Divider(height: 40),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/Ovni.png',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Vecinos de la zona de Benicalap han reportado hace escasos minutos el avistamiento de un objeto discoidal de grandes dimensiones suspendido sobre las obras del futuro estadio del Valencia CF. Las imágenes, captadas por un testigo directo, están colapsando las redes sociales. Según los expertos, el fenómeno es inexplicable...",
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
          GestureDetector(
            onTap: _jumpToCall, // Salto inmediato al pulsar el botón de premio
            child: Container(
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
