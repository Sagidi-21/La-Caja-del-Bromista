import 'package:flutter/material.dart';
import 'dart:ui';

class TrojanScreen extends StatefulWidget {
  const TrojanScreen({super.key});

  @override
  State<TrojanScreen> createState() => _TrojanScreenState();
}

class _TrojanScreenState extends State<TrojanScreen> {
  // Estado para los selectores (por ahora solo visual)
  String _selectedDisguise = 'Misterio';
  double _delaySeconds = 5.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── FONDO: GATO INFORMÁTICO ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/Gato_informatico.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay oscuro para dar contraste y legibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── HEADER CON BOTÓN VOLVER Y TÍTULO "HACKER" ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Image.asset(
                        'assets/images/Hacker.png',
                        height: 120, // Ajustable
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          "HACKER LAB",
                          style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── CONTENIDO SCROLLABLE ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SECCIÓN 1: DISFRAZ
                        _buildGlassCard(
                          title: "1. El Cebo (Disfraz del Link)",
                          icon: Icons.masks,
                          color: Colors.purpleAccent,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _buildChoiceChip('Viral', Icons.local_fire_department),
                              _buildChoiceChip('Noticia', Icons.article),
                              _buildChoiceChip('Sorteo', Icons.card_giftcard),
                              _buildChoiceChip('Misterio', Icons.help_outline),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SECCIÓN 2: CARGA ÚTIL
                        _buildGlassCard(
                          title: "2. La Trampa (Carga Útil)",
                          icon: Icons.bug_report,
                          color: Colors.redAccent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.image, color: Colors.white),
                                title: const Text('Imagen Víctima', style: TextStyle(color: Colors.white)),
                                trailing: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.5)),
                                  child: const Text('SELECCIONAR', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.mic, color: Colors.white),
                                title: const Text('Audio Susto', style: TextStyle(color: Colors.white)),
                                trailing: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent.withOpacity(0.5)),
                                  child: const Text('GRABAR', style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text("Retraso de activación:", style: TextStyle(color: Colors.white70)),
                              Slider(
                                value: _delaySeconds,
                                min: 0,
                                max: 15,
                                divisions: 15,
                                activeColor: Colors.redAccent,
                                label: "${_delaySeconds.toInt()} seg",
                                onChanged: (val) => setState(() => _delaySeconds = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SECCIÓN 3: EJECUCIÓN
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.precision_manufacturing, color: Colors.white),
                          label: const Text(
                            "PREPARAR TRAMPA",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FF00).withOpacity(0.6), // Verde Neón oscuro
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: const BorderSide(color: Color(0xFF00FF00), width: 2),
                            shadowColor: const Color(0xFF00FF00),
                            elevation: 10,
                          ),
                        ),
                        const SizedBox(height: 15),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.send, color: Colors.white),
                          label: const Text("COPIAR Y ENVIAR POR WHATSAPP", style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            side: BorderSide(color: Colors.white.withOpacity(0.3)),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // SECCIÓN 4: PANEL DE CONTROL
                        _buildGlassCard(
                          title: "Radar de Víctimas",
                          icon: Icons.radar,
                          color: Colors.greenAccent,
                          child: const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                "No hay trampas activas.",
                                style: TextStyle(color: Colors.white54, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
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

  // Widget helper para las tarjetas tipo "Glassmorphism"
  Widget _buildGlassCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 20),
              child,
            ],
          ),
        ),
      ),
    );
  }

  // Widget helper para los "Chips" de selección del disfraz
  Widget _buildChoiceChip(String label, IconData icon) {
    final bool isSelected = _selectedDisguise == label;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: isSelected ? Colors.black : Colors.white),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) setState(() => _selectedDisguise = label);
      },
      selectedColor: Colors.purpleAccent,
      backgroundColor: Colors.white.withOpacity(0.1),
      side: BorderSide(color: isSelected ? Colors.purpleAccent : Colors.white24),
    );
  }
}
