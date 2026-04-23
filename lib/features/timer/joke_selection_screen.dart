import 'package:flutter/material.dart';

class JokeSelectionScreen extends StatefulWidget {
  const JokeSelectionScreen({super.key});

  @override
  State<JokeSelectionScreen> createState() => _JokeSelectionScreenState();
}

class _JokeSelectionScreenState extends State<JokeSelectionScreen> {
  final Map<String, bool> _pressed = {};

  void _selectJoke(String label, int soundIndex, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text("PREPARANDO: $label", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        duration: const Duration(milliseconds: 1000),
      ),
    );
    // Esperamos un momento para que se vea la animación y el snackbar antes de volver
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) Navigator.pop(context, soundIndex);
    });
  }

  Widget _buildCajaButton(String assetNormal, String assetIntensa, String label, Color color, int soundIndex) {
    final bool isPressed = _pressed[label] ?? false;
    final String currentAsset = isPressed
        ? 'assets/images/$assetIntensa'
        : 'assets/images/$assetNormal';

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 24, // Letra más grande
            fontWeight: FontWeight.w900,
            color: color,
            letterSpacing: 1.2,
            shadows: [
              Shadow(color: Colors.black, offset: const Offset(2, 2), blurRadius: 4),
              Shadow(color: color.withOpacity(0.5), blurRadius: 10),
            ],
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTapDown: (_) => setState(() => _pressed[label] = true),
          onTapUp: (_) {
            setState(() => _pressed[label] = false);
            _selectJoke(label, soundIndex, color);
          },
          onTapCancel: () => setState(() => _pressed[label] = false),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: SizedBox(
              key: ValueKey(currentAsset),
              width: isPressed ? 130 : 120, // Iconos más grandes
              height: isPressed ? 130 : 120,
              child: Image.asset(
                currentAsset,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120, height: 120,
                  color: color.withOpacity(0.3),
                  child: Center(child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 10))),
                ),
              ),
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
          // FONDO DEL GATO PENSATIVO
          Positioned.fill(
            child: Image.asset(
              'assets/images/Gato_pensativo.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // OVERLAY DEGRADADO
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                // BOTÓN DE ATRÁS
                Positioned(
                  top: 10,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // TÍTULO
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25, left: 50, right: 20),
                    child: Text(
                      "SELECCIONA TU BROMA",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: MediaQuery.of(context).size.width * 0.08,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFFFF00FF),
                        fontStyle: FontStyle.italic,
                        letterSpacing: -1,
                        shadows: [
                          Shadow(color: Colors.black.withOpacity(0.8), offset: const Offset(4, 4), blurRadius: 10),
                          const Shadow(color: Color(0xFFFF00FF), blurRadius: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                // CAJAS DE SELECCIÓN
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 40, right: 20, left: 60),
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white12, width: 1),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildCajaButton('Caja_roja_normal.png', 'Caja_roja_intensa.png', 'PEDOS', Colors.redAccent, 1), // fart.mp3
                        const SizedBox(height: 20),
                        _buildCajaButton('Caja_azul_normal.png', 'Caja_azul_intensa.png', 'CRISTALES', Colors.blueAccent, 0), // boom.mp3
                        const SizedBox(height: 20),
                        _buildCajaButton('Caja_oro_normal.png', 'Caja_oro_intensa.png', 'GRITOS', Colors.amber, 3), // clap.mp3
                        const SizedBox(height: 20),
                        _buildCajaButton('Caja_morada_normal.png', 'Caja_morada_intensa.png', 'GOLPES', Colors.purpleAccent, 2), // whip.mp3
                      ],
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
