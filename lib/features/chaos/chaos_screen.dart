import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/audio/audio_service.dart';
import '../../shared/shared_sidebar.dart';

class ChaosScreen extends StatefulWidget {
  const ChaosScreen({super.key});

  @override
  State<ChaosScreen> createState() => _ChaosScreenState();
}

class _ChaosScreenState extends State<ChaosScreen>
    with TickerProviderStateMixin {
  late AnimationController _glitchCtrl;
  late AnimationController _rotCtrl;
  late Animation<double> _rotAnim;

  bool _chaosModeActive = false;
  int _triggerCount = 0;
  final Random _rng = Random();

  // Los sonidos disponibles en el pool
  static const List<String> _sounds = [
    'fart.mp3',
    'whip.mp3',
    'boom.mp3',
    'clap.mp3',
  ];

  // Sugerencias del Chaos Assistant
  static const List<String> _suggestions = [
    'Espera a que alguien coja tu móvil y déjalo en modo LÁTIGO.',
    'Temporizador 60s en el baño. Clásico infalible.',
    'Pedo en reunión. Mantén contacto visual.',
    'Modo Látigo en el cine. Peligroso pero épico.',
    'Boom en el ascensor. Cara de póker obligatoria.',
  ];
  int _currentSuggestion = 0;

  @override
  void initState() {
    super.initState();
    _glitchCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _rotCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();
    _rotAnim = Tween(begin: 0.0, end: 2 * pi).animate(_rotCtrl);
  }

  @override
  void dispose() {
    _glitchCtrl.dispose();
    _rotCtrl.dispose();
    super.dispose();
  }

  void _triggerChaos() async {
    if (_chaosModeActive) return;
    setState(() {
      _chaosModeActive = true;
      _triggerCount++;
      _currentSuggestion = _rng.nextInt(_suggestions.length);
    });

    // Glitch flash
    _glitchCtrl.forward(from: 0);

    // Sonido aleatorio
    final sound = _sounds[_rng.nextInt(_sounds.length)];
    await AudioService.play(sound);

    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) setState(() => _chaosModeActive = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Column(
          children: [
            // ── TopAppBar ─────────────────────────────────────────
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
                    Image.asset(
                      'assets/images/jester_box.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Header ──────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('CHAOS ENGINE',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFFD873FF),
                                  letterSpacing: 3,
                                )),
                            const SizedBox(height: 4),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w900,
                                  fontSize: 36,
                                  letterSpacing: -2,
                                  color: Colors.white,
                                ),
                                children: [
                                  TextSpan(text: 'MODO '),
                                  TextSpan(
                                    text: 'CAOS',
                                    style: TextStyle(color: Color(0xFFDDFFAE)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        // Trigger count badge
                        Transform.rotate(
                          angle: 0.035,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF262626),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFD873FF).withOpacity(0.3),
                                  blurRadius: 0,
                                  offset: const Offset(3, 3),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$_triggerCount',
                                  style: const TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    fontWeight: FontWeight.w900,
                                    fontSize: 32,
                                    color: Color(0xFFD873FF),
                                    letterSpacing: -2,
                                  ),
                                ),
                                const Text('DETONACIONES',
                                    style: TextStyle(
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 7,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF767575),
                                      letterSpacing: 1,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ── Big CHAOS button ─────────────────────────────
                    Center(child: _ChaosButton(active: _chaosModeActive, onTap: _triggerChaos, rotAnim: _rotAnim)),
                    const SizedBox(height: 32),

                    // ── Chaos tip ────────────────────────────────────
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: _ChaosAssistantTip(
                        key: ValueKey(_currentSuggestion),
                        tip: _suggestions[_currentSuggestion],
                        onNext: () => setState(() =>
                            _currentSuggestion = (_currentSuggestion + 1) % _suggestions.length),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Quick Triggers Row ───────────────────────────
                    const Text('DETONADORES RÁPIDOS',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF767575),
                          letterSpacing: 3,
                        )),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _QuickTrigger(emoji: '💨', label: 'PEDO', file: 'fart.mp3')),
                        const SizedBox(width: 10),
                        Expanded(child: _QuickTrigger(emoji: '⚡', label: 'LÁTIGO', file: 'whip.mp3', rotate: -1.0)),
                        const SizedBox(width: 10),
                        Expanded(child: _QuickTrigger(emoji: '💀', label: 'BOOM', file: 'boom.mp3')),
                        const SizedBox(width: 10),
                        Expanded(child: _QuickTrigger(emoji: '👏', label: 'CLAP', file: 'clap.mp3', rotate: 1.0)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Danger Level ─────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF131313),
                        borderRadius: BorderRadius.circular(8),
                        border: const Border(
                          top: BorderSide(color: Color(0xFFFF7E3F), width: 3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('NIVEL DE PELIGRO',
                                  style: TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFF7E3F),
                                    letterSpacing: 2,
                                  )),
                              Text(
                                _triggerCount == 0
                                    ? 'INOFENSIVO'
                                    : _triggerCount < 3
                                        ? 'MOLESTO'
                                        : _triggerCount < 7
                                            ? 'PELIGROSO'
                                            : '☠ LEGENDARIO',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: _triggerCount < 3
                                      ? const Color(0xFF767575)
                                      : _triggerCount < 7
                                          ? const Color(0xFFFF7E3F)
                                          : const Color(0xFFDDFFAE),
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (_triggerCount / 10).clamp(0.0, 1.0),
                              backgroundColor: const Color(0xFF262626),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _triggerCount < 3
                                    ? const Color(0xFF767575)
                                    : _triggerCount < 7
                                        ? const Color(0xFFFF7E3F)
                                        : const Color(0xFFDDFFAE),
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Subwidgets ────────────────────────────────────────────────────────────

class _ChaosButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final Animation<double> rotAnim;
  const _ChaosButton({required this.active, required this.onTap, required this.rotAnim});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active ? const Color(0xFFD873FF) : const Color(0xFF1A1919),
          boxShadow: active
              ? [
                  const BoxShadow(
                    color: Color(0xFFD873FF),
                    blurRadius: 60,
                    spreadRadius: 4,
                  )
                ]
              : [
                  BoxShadow(
                    color: const Color(0xFFDDFFAE).withOpacity(0.15),
                    blurRadius: 40,
                  )
                ],
          border: Border.all(
            color: active ? const Color(0xFFDDFFAE) : const Color(0xFF262626),
            width: 3,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Rotating ring
            AnimatedBuilder(
              animation: rotAnim,
              builder: (_, __) => Transform.rotate(
                angle: rotAnim.value,
                child: Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (active ? const Color(0xFFDDFFAE) : const Color(0xFF484847))
                          .withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                active 
                  ? const Icon(Icons.flash_on, size: 80, color: Color(0xFF0E0E0E))
                  : Image.asset(
                      'assets/images/detonator.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                const SizedBox(height: 8),
                Text(
                  active ? '¡BOOM!' : 'CAOS',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    letterSpacing: -1,
                    color: active ? const Color(0xFF0E0E0E) : const Color(0xFFDDFFAE),
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

class _ChaosAssistantTip extends StatelessWidget {
  final String tip;
  final VoidCallback onNext;
  const _ChaosAssistantTip({super.key, required this.tip, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1919),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: const Border(left: BorderSide(color: Color(0xFFDDFFAE), width: 4)),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFDDFFAE).withOpacity(0.3)),
              image: const DecorationImage(
                image: AssetImage('assets/images/jester_box.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ASISTENTE CAÓTICO',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk', fontSize: 8,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD873FF), letterSpacing: 2,
                    )),
                const SizedBox(height: 4),
                Text(tip,
                    style: const TextStyle(
                      fontFamily: 'Manrope', fontSize: 13,
                      color: Colors.white, height: 1.4,
                    )),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onNext,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.refresh, color: Color(0xFFDDFFAE), size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickTrigger extends StatefulWidget {
  final String emoji;
  final String label;
  final String file;
  final double rotate;
  const _QuickTrigger({
    required this.emoji,
    required this.label,
    required this.file,
    this.rotate = 0,
  });

  @override
  State<_QuickTrigger> createState() => _QuickTriggerState();
}

class _QuickTriggerState extends State<_QuickTrigger> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        AudioService.play(widget.file);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Transform.rotate(
        angle: widget.rotate * pi / 180,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 75),
          padding: const EdgeInsets.symmetric(vertical: 14),
          transform: _pressed ? (Matrix4.identity()..translate(0.0, 3.0)) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1919),
            borderRadius: BorderRadius.circular(8),
            boxShadow: _pressed
                ? []
                : const [BoxShadow(color: Colors.black, offset: Offset(0, 3), blurRadius: 0)],
          ),
          child: Column(
            children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(height: 4),
              Text(widget.label,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 8,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF767575),
                    letterSpacing: 1,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
