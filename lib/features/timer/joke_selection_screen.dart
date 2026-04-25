import 'package:flutter/material.dart';
import 'joke_detail_screen.dart';

class JokeSelectionScreen extends StatefulWidget {
  const JokeSelectionScreen({super.key});

  @override
  State<JokeSelectionScreen> createState() => _JokeSelectionScreenState();
}

class _JokeSelectionScreenState extends State<JokeSelectionScreen> {
  // Para controlar qué caja se está presionando y mostrar la versión "intensa"
  String? _pressingCategory;

  Future<void> _onJokeSelected(BuildContext context, String category, Color themeColor) async {
    final Map<String, String>? selectedSound = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => JokeDetailScreen(
          category: category,
          themeColor: themeColor,
        ),
      ),
    );

    if (selectedSound != null && context.mounted) {
      Navigator.pop(context, {
        ...selectedSound,
        'color': themeColor.value,
      });
    } else if (context.mounted) {
      // Si vuelve atrás sin seleccionar, reseteamos la caja
      setState(() => _pressingCategory = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── FONDO: GATO PENSATIVO ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/Gato_pensativo.jpeg',
              fit: BoxFit.cover,
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
                    Colors.black.withOpacity(0.3), // Más claro arriba
                    Colors.transparent,             // Limpio en el centro
                    Colors.black.withOpacity(0.4), // Sutil abajo para legibilidad
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── HEADER CON TÍTULO PREMIUM ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Image.asset(
                        'assets/images/Caja.png',
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          "LA CAJA",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 0),

                // ── LISTADO DE CAJAS ──
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    children: [
                      _buildCategoryRow(
                        context,
                        title: "PEDOS",
                        colorName: "roja",
                        themeColor: const Color(0xFFFF3D00),
                      ),
                      _buildCategoryRow(
                        context,
                        title: "CRISTALES",
                        colorName: "azul",
                        themeColor: const Color(0xFF00E5FF),
                      ),
                      _buildCategoryRow(
                        context,
                        title: "GRITOS",
                        colorName: "oro",
                        themeColor: const Color(0xFFFFD600),
                      ),
                      _buildCategoryRow(
                        context,
                        title: "GOLPES",
                        colorName: "morada",
                        themeColor: const Color(0xFFAA00FF),
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

  Widget _buildCategoryRow(BuildContext context, {
    required String title,
    required String colorName,
    required Color themeColor,
  }) {
    final bool isPressing = _pressingCategory == title;
    final String imagePath = isPressing 
        ? 'assets/images/Caja_${colorName}_intensa.png' 
        : 'assets/images/Caja_${colorName}_normal.png';

    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressingCategory = title),
        onTapUp: (_) async {
          // Esperamos el delay para que se vea el efecto, pero NO reseteamos aún
          await Future.delayed(const Duration(milliseconds: 200));
          if (mounted) {
            _onJokeSelected(context, title, themeColor);
          }
        },
        onTapCancel: () => setState(() => _pressingCategory = null),
        child: Row(
          children: [
            // Imagen de la Caja con Animación de Escala
            AnimatedScale(
              scale: isPressing ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeOutBack,
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 120, height: 120, color: Colors.grey[900],
                  child: const Icon(Icons.inventory_2, color: Colors.white24),
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Nombre del Grupo con "Cajita" de contraste
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20), // <--- ESTO ES LO QUE BAJA EL TEXTO
                child: AnimatedScale(
                  scale: isPressing ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOutBack,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: themeColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: themeColor, 
                        letterSpacing: 2,
                        shadows: [
                          Shadow(color: Colors.black, offset: const Offset(2, 2), blurRadius: 4),
                          Shadow(
                            color: themeColor.withOpacity(isPressing ? 0.9 : 0.5), 
                            blurRadius: isPressing ? 25 : 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
