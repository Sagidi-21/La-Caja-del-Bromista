import 'package:flutter/material.dart';
import 'dart:ui';
import 'joke_detail_screen.dart';

class JokeSelectionScreen extends StatelessWidget {
  const JokeSelectionScreen({super.key});

  Future<void> _onJokeSelected(BuildContext context, String category, Color themeColor) async {
    final String? selectedSound = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => JokeDetailScreen(
          category: category,
          themeColor: themeColor,
        ),
      ),
    );

    if (selectedSound != null && context.mounted) {
      Navigator.pop(context, selectedSound);
    }
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
              'assets/images/gato_bufon.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay gradiente
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Text(
                        "LA CAJA",
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(width: 48), // Balance para el botón back
                    ],
                  ),
                ),

                const Text(
                  "ELIGE TU BROMO",
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.white54,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 40),

                // Grid de Cajas
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        _buildJokeBox(
                          context: context,
                          title: "PEDOS",
                          color: const Color(0xFFFF3D00), // Naranja neón
                          icon: Icons.air,
                          onTap: () => _onJokeSelected(context, "PEDOS", const Color(0xFFFF3D00)),
                        ),
                        _buildJokeBox(
                          context: context,
                          title: "CRISTALES",
                          color: const Color(0xFF00E5FF), // Cyan neón
                          icon: Icons.flare,
                          onTap: () => _onJokeSelected(context, "CRISTALES", const Color(0xFF00E5FF)),
                        ),
                        _buildJokeBox(
                          context: context,
                          title: "GRITOS",
                          color: const Color(0xFFFFD600), // Oro neón
                          icon: Icons.record_voice_over,
                          onTap: () => _onJokeSelected(context, "GRITOS", const Color(0xFFFFD600)),
                        ),
                        _buildJokeBox(
                          context: context,
                          title: "GOLPES",
                          color: const Color(0xFFAA00FF), // Púrpura neón
                          icon: Icons.gavel,
                          onTap: () => _onJokeSelected(context, "GOLPES", const Color(0xFFAA00FF)),
                        ),
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

  Widget _buildJokeBox({
    required BuildContext context,
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: color.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 1,
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
