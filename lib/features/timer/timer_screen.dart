import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/audio/audio_service.dart';
import 'joke_selection_screen.dart';
import 'jumpscare_screen.dart';
import '../trojan/trojan_screen.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with SingleTickerProviderStateMixin {
  int _delaySeconds = 10;
  int _remainingSeconds = 10;
  bool _isRunning = false;
  bool _stealthMode = false;
  Timer? _countdownTimer;

  bool _hasBeenScared = false;
  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;

  @override
  void initState() {
    super.initState();
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _arrowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeOut,
    ));
  }

  static const List<Map<String, dynamic>> _sounds = [
    {'label': 'Bocina Explosiva', 'file': 'boom.mp3', 'icon': Icons.campaign},
    {'label': 'Pedo Clásico', 'file': 'fart.mp3', 'icon': Icons.air},
    {'label': 'Látigo Letal', 'file': 'whip.mp3', 'icon': Icons.bolt},
    {'label': 'Aplauso Falso', 'file': 'clap.mp3', 'icon': Icons.front_hand},
    {'label': 'Pedo Atómico', 'file': 'pedo1.mp3', 'icon': Icons.cloud},
    {'label': 'Pedo Silvante', 'file': 'pedo2.mp3', 'icon': Icons.music_note},
    {'label': 'Pedo Trompeta', 'file': 'pedo3.mp3', 'icon': Icons.bug_report},
    {'label': 'Pedo Largo', 'file': 'pedo4.mp3', 'icon': Icons.timer},
    {'label': 'Pedo Seco', 'file': 'pedo5.mp3', 'icon': Icons.dry_cleaning},
    {'label': 'Pedo Explosivo', 'file': 'pedo6.mp3', 'icon': Icons.cyclone},
    {'label': 'Pedo Musical', 'file': 'pedo7.mp3', 'icon': Icons.audiotrack},
    {'label': 'Pedo Rebotante', 'file': 'pedo8.mp3', 'icon': Icons.sports_basketball},
    {'label': 'Pedo Final', 'file': 'pedo9.mp3', 'icon': Icons.flag},
    {'label': 'Momento Bruh', 'file': 'bruh.mp3', 'icon': Icons.sentiment_very_satisfied},
  ];
  int _selectedSound = 0;
  String? _selectedSoundPath;
  String _selectedSoundLabel = 'SIN BROMA ACTIVADA';
  Color _selectedSoundColor = const Color(0xFF666666); // Gris por defecto

  void _increment() {
    if (_isRunning) return;
    setState(() {
      _delaySeconds = (_delaySeconds + 5).clamp(5, 300);
      _remainingSeconds = _delaySeconds;
    });
  }

  void _decrement() {
    if (_isRunning) return;
    setState(() {
      _delaySeconds = (_delaySeconds - 5).clamp(5, 300);
      _remainingSeconds = _delaySeconds;
    });
  }

  void _toggleTimer() async {
    if (_selectedSoundPath == null) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const JumpscareScreen()),
      );
      if (mounted) {
        setState(() {
          _hasBeenScared = true;
        });
      }
      return;
    }
    
    if (_remainingSeconds == 0) return;
    
    if (_isRunning) {
      _countdownTimer?.cancel();
      setState(() {
        _isRunning = false;
        _remainingSeconds = _delaySeconds;
      });
      return;
    }

    setState(() {
      _isRunning = true;
      _remainingSeconds = _delaySeconds;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 1) {
        t.cancel();
        AudioService.playSmart(_selectedSoundPath!);
        setState(() {
          _isRunning = false;
          _remainingSeconds = _delaySeconds;
        });
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }


  void _showSoundPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1919),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: Color(0xFFD873FF), width: 3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 6,
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(height: 24),
            const Text(
              "ELIGE TU ARMA",
              style: TextStyle(fontFamily: 'Manrope', fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFDDFFAE)),
            ),
            const SizedBox(height: 24),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _sounds.length,
                itemBuilder: (context, index) {
                  final s = _sounds[index];
                  final isSel = _selectedSound == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSound = index;
                        _selectedSoundPath = _sounds[index]['file'];
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFFDDFFAE) : const Color(0xFF2C2C2C),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSel ? Colors.white : Colors.white10, width: 2),
                        boxShadow: isSel ? const [BoxShadow(color: Colors.black, offset: Offset(2, 2))] : null,
                      ),
                      child: Row(
                        children: [
                          Icon(s['icon'] as IconData, size: 20, color: isSel ? Colors.black : Colors.white70),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              s['label'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: isSel ? Colors.black : Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _arrowController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── FONDO DE PANTALLA (GATO BUFÓN) ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/gato_bufon.png',
              fit: BoxFit.cover,
            ),
          ),
          
          // Overlay de degradado para profundidad
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                    Colors.transparent, // Eliminamos el negro del fondo
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Stack(
              children: [
                // ── TÍTULO GIGANTE CENTRADO Y BOTÓN ──
                // ── TÍTULO GIGANTE CENTRADO ──
                Positioned(
                  top: -35,
                  left: 5,
                  right: 5,
                  child: Center(
                    child: Image.asset(
                      'assets/images/Titulo.png',
                      width: MediaQuery.of(context).size.width * 0.90,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Text(
                        "TEMPORIZADOR DE LA RISA",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),

                // ── BOTÓN ACCESO HACKER LAB ──
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.bug_report, color: Colors.greenAccent, size: 35),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TrojanScreen()),
                      );
                    },
                  ),
                ),

                // ── BOTÓN SELECCIONA TU BROMA (INDEPENDIENTE) ──
                Positioned(
                  top: 70,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const JokeSelectionScreen()),
                          );
                          if (result != null && result is Map) {
                            setState(() {
                              _hasBeenScared = false;
                              _selectedSoundPath = result['path'] as String;
                              _selectedSoundLabel = result['label'] as String;
                              if (result.containsKey('color')) {
                                _selectedSoundColor = Color(result['color'] as int);
                              }
                            });
                          }
                        },
                      child: Image.asset(
                        'assets/images/Elige_tu_broma.png',
                        width: 250, 
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          "Imagen no encontrada",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),

                if (_hasBeenScared && _selectedSoundPath == null)
                  Positioned(
                    top: 150, // Debajo de ELIGE TU BROMA
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedBuilder(
                        animation: _arrowAnimation,
                        builder: (context, child) {
                          // Traslación hacia arriba: de 40 a 0
                          final dy = 40.0 * (1.0 - _arrowAnimation.value);
                          // Opacidad: aparece suave, se mantiene y desaparece al final
                          final opacity = _arrowAnimation.value < 0.2 
                              ? _arrowAnimation.value * 5.0 
                              : (_arrowAnimation.value > 0.8 ? (1.0 - _arrowAnimation.value) * 5.0 : 1.0);
                          return Opacity(
                            opacity: opacity.clamp(0.0, 1.0),
                            child: Transform.translate(
                              offset: Offset(0, dy),
                              child: const Icon(
                                Icons.arrow_upward_rounded,
                                color: Color(0xFFFF00FF),
                                size: 80,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 10, offset: Offset(2, 2))
                                ]
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: _buildTimerBox(),
                    ),
                  ),
                ),
                
                // Indicador de modo silencioso (NINJA)
                if (_isRunning)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: GestureDetector(
                      onTap: () => setState(() => _stealthMode = !_stealthMode),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: _stealthMode ? const Color(0xFFD873FF) : Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Row(
                          children: [
                            Icon(_stealthMode ? Icons.visibility_off : Icons.visibility, size: 18, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              _stealthMode ? "MODO NINJA" : "MODO VISIBLE",
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

              ],
            ),
          ),

          // ── BOTÓN "PRESIONA PARA ARMAR" EN LA PARTE INFERIOR (Fuera de SafeArea para bajarlo más) ──
          if (!_isRunning)
            Positioned(
              bottom: -60, // Ajuste final solicitado
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _toggleTimer,
                  child: Image.asset(
                    'assets/images/Presiona_para_Armar.png',
                    width: 280, 
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),

          // Pantalla de Apagón
          if (_stealthMode && _isRunning)
            Positioned.fill(
              child: GestureDetector(
                onLongPress: () => setState(() => _stealthMode = false),
                child: Container(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimerBox() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final w = totalWidth * 0.8; // La dinamita mantiene su tamaño visual (0.9 * 0.8 = 0.72)
        // Display de la dinamita: ~38% desde arriba
        final displayTop = w * 0.38;
        final fontSize   = w * 0.12;

        return Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // ── IMAGEN DE DINAMITA ──
            Image.asset(
              'assets/images/Dinamita.png',
              width: w,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: w, height: w * 0.6,
                color: Colors.red.withOpacity(0.3),
                child: const Center(child: Text("Dinamita.png no encontrada", style: TextStyle(color: Colors.white))),
              ),
            ),

            // ── BOTONES DE AJUSTE DE TIEMPO ──
            if (!_isRunning) ...[
              Positioned(
                left: 0, // Pegado al borde izquierdo del contenedor de 90%
                top: displayTop + (w * 0.02) + 5,
                child: _buildTimeAdjButton(
                  icon: Icons.remove,
                  onTap: _decrement,
                  size: w * 0.16,
                ),
              ),
              Positioned(
                right: 0, // Pegado al borde derecho del contenedor de 90%
                top: displayTop + (w * 0.02) + 5,
                child: _buildTimeAdjButton(
                  icon: Icons.add,
                  onTap: _increment,
                  size: w * 0.16,
                ),
              ),
            ],

            // ── PANTALLA DIGITAL SUPERPUESTA ──
            Positioned(
              top: displayTop + 6, // Ajuste fino hacia abajo
              child: Padding(
                padding: const EdgeInsets.only(left: 10), // Ajuste fino a la derecha
                child: Text(
                  "${(_remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}",
                style: GoogleFonts.vt323(
                  fontSize: fontSize,
                  color: const Color(0xFFFFAA00),
                  letterSpacing: w * 0.012,
                  shadows: const [
                    Shadow(color: Color(0xFFFFAA00), blurRadius: 6),
                    Shadow(color: Color(0xFFFF6600), blurRadius: 16),
                    Shadow(color: Color(0xFFFFAA00), blurRadius: 30),
                  ],
                ),
                ),
              ),
            ),
            // ── ETIQUETA DE SONIDO ELEGIDO (SOBRE LA DINAMITA) ──
            Positioned(
              top: displayTop - (w * 0.15) - 30, // Subido 30 px total
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _selectedSoundColor, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: _selectedSoundColor.withOpacity(0.3), blurRadius: 10),
                  ],
                ),
                child: Text(
                  _selectedSoundLabel.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: w * 0.045,
                    fontWeight: FontWeight.w900,
                    color: _selectedSoundColor,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTimeAdjButton({required IconData icon, required VoidCallback onTap, double size = 36}) {
    return GestureDetector(
      onTap: () {
        // Feedback táctil/visual simple
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFFF9500),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(2, 2)),
          ],
        ),
        child: Icon(icon, color: Colors.black, size: size * 0.55),
      ),
    );
  }


  Widget _buildTNTTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1919),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: const Text(
        "TNT",
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white),
      ),
    );
  }
}
