import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/audio/audio_service.dart';
import '../../core/sensors/motion_service.dart';
import '../../shared/shared_sidebar.dart';

class WhipScreen extends StatefulWidget {
  const WhipScreen({super.key});

  @override
  State<WhipScreen> createState() => _WhipScreenState();
}

class _WhipScreenState extends State<WhipScreen>
    with TickerProviderStateMixin {
  bool _motionEnabled = true;
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    if (_motionEnabled) MotionService.startWhipDetection();
  }

  void _toggleMotion(bool val) {
    setState(() => _motionEnabled = val);
    if (val) {
      MotionService.startWhipDetection();
    } else {
      MotionService.stopWhipDetection();
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Stack(
          children: [
            // ── Dot grid background ─────────────────────────────────
            Positioned.fill(
              child: CustomPaint(painter: _DotGridPainter()),
            ),

            Column(
              children: [
                // ── TopAppBar ───────────────────────────────────────
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1A1919), Colors.transparent],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        const Icon(Icons.mood, color: Color(0xFFDDFFAE), size: 28),
                        const SizedBox(width: 8),
                        const Text("JOKER'S BOX",
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                              color: Color(0xFFDDFFAE),
                              letterSpacing: -1.5,
                            )),
                      ]),
                  Builder(
                    builder: (ctx) => GestureDetector(
                      onTap: () => Scaffold.of(ctx).openEndDrawer(),
                      child: const Icon(Icons.settings, color: Color(0xFFD873FF), size: 28),
                    ),
                  ),
                    ],
                  ),
                ),

                // ── Status + Toggle row ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _motionEnabled ? 'STATUS: READY' : 'STATUS: OFFLINE',
                            style: TextStyle(
                              fontFamily: 'SpaceGrotesk',
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: _motionEnabled
                                  ? const Color(0xFFFF7E3F)
                                  : const Color(0xFF767575),
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: _motionEnabled ? 48 : 16,
                            height: 3,
                            decoration: BoxDecoration(
                              color: _motionEnabled
                                  ? const Color(0xFFA5FD00)
                                  : const Color(0xFF484847),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      // Toggle card
                      Transform.rotate(
                        angle: 0.017, // 1 deg
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1919),
                            borderRadius: BorderRadius.circular(12),
                            border: const Border(
                              left: BorderSide(color: Color(0xFFFE6500), width: 4),
                            ),
                            boxShadow: const [
                              BoxShadow(color: Colors.black54, blurRadius: 20),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text('MOTION TRIGGER',
                                  style: const TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFADAAAB),
                                    letterSpacing: 2,
                                  )),
                              const SizedBox(width: 12),
                              _NeonSwitch(
                                value: _motionEnabled,
                                onChanged: _toggleMotion,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Central whip area ───────────────────────────────
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            color: _motionEnabled ? const Color(0xFFC3F400) : const Color(0xFF27272A),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 6),
                            boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(10, 10))],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Indiana Illustration
                              ClipOval(
                                child: Opacity(
                                  opacity: _motionEnabled ? 1.0 : 0.3,
                                  child: Image.asset(
                                    'assets/images/indiana.png',
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Text('🤠', style: TextStyle(fontSize: 100)),
                                  ),
                                ),
                              ),
                              if (_motionEnabled)
                                Positioned(
                                  bottom: 20,
                                  child: Transform.rotate(
                                    angle: -0.15,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF5AF9),
                                        border: Border.all(color: Colors.black, width: 4),
                                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(6, 6))],
                                      ),
                                      child: const Text("¡FUSTIGAR!", style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900, color: Colors.black, fontSize: 20)),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 48),

                        // "SWING YOUR PHONE" text
                        Text(
                          'SWING YOUR\nPHONE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 48,
                            height: 0.9,
                            color: _motionEnabled
                                ? const Color(0xFFDDFFAE)
                                : const Color(0xFF484847),
                            letterSpacing: -2,
                            fontStyle: FontStyle.italic,
                            shadows: _motionEnabled
                                ? [
                                    const Shadow(
                                      color: Color(0xFFDDFFAE),
                                      blurRadius: 12,
                                    )
                                  ]
                                : [],
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(width: 32, height: 1, color: const Color(0xFF484847)),
                            const SizedBox(width: 16),
                            const Text('SHAKE TO CRACK',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11,
                                  color: Color(0xFFD873FF),
                                  letterSpacing: 4,
                                )),
                            const SizedBox(width: 16),
                            Container(width: 32, height: 1, color: const Color(0xFF484847)),
                          ],
                        ),

                        const SizedBox(height: 32),

                        // ── Data readouts ─────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            children: [
                              Expanded(
                                child: Transform.rotate(
                                  angle: -0.017,
                                  child: _DataCard(
                                    label: 'G-Force Sensitivity',
                                    value: '8.4',
                                    unit: 'm/s²',
                                    valueColor: const Color(0xFFDDFFAE),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Transform.translate(
                                  offset: const Offset(0, 16),
                                  child: Transform.rotate(
                                    angle: 0.017,
                                    child: _DataCard(
                                      label: 'Impact Velocity',
                                      value: 'MAX',
                                      unit: '',
                                      valueColor: const Color(0xFFFF7E3F),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Subwidgets ──────────────────────────────────────────────────────────────

// Eliminado _WhipButton como solicitó el usuario
class _NeonSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _NeonSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? const Color(0xFF9900CE) : const Color(0xFF262626),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 22 : 2,
              top: 2,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? const Color(0xFFDDFFAE) : const Color(0xFF767575),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DataCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color valueColor;
  const _DataCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131313),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(),
              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 8,
                fontWeight: FontWeight.w700,
                color: Color(0xFFADAAAB),
                letterSpacing: 1.5,
              )),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    color: valueColor,
                  ),
                ),
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                      color: valueColor.withOpacity(0.5),
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

/// Fondo de puntos tipo circuito
class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFDDFFAE).withOpacity(0.05)
      ..strokeWidth = 1;
    const spacing = 24.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 0.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
