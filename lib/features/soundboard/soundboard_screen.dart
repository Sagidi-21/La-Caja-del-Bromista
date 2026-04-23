import 'package:flutter/material.dart';
import 'dart:math';
import '../../core/audio/audio_service.dart';
import '../../core/sensors/motion_service.dart';
import '../../shared/shared_sidebar.dart';

class SoundboardScreen extends StatefulWidget {
  const SoundboardScreen({super.key});

  @override
  State<SoundboardScreen> createState() => _SoundboardScreenState();
}

class _SoundboardScreenState extends State<SoundboardScreen> {
  @override
  void initState() {
    super.initState();
    MotionService.startWhipDetection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // TopAppBar
            SliverToBoxAdapter(
              child: Container(
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
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/jester_box.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "JOKER'S BOX",
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 26,
                            color: Color(0xFFDDFFAE),
                            letterSpacing: -1.5,
                          ),
                        ),
                      ],
                    ),
                    Builder(
                      builder: (ctx) => GestureDetector(
                        onTap: () => Scaffold.of(ctx).openEndDrawer(),
                        child: const Icon(Icons.settings, color: Color(0xFFD873FF), size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([

                  // Status row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('SYSTEM STATUS',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk', fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFD873FF),
                                letterSpacing: 3,
                              )),
                          Row(children: [
                            _PulseDot(),
                            const SizedBox(width: 8),
                            const Text('Armed & Ready',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk', fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFDDFFAE),
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: -1,
                                )),
                          ]),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('VOLTAGE',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk', fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF767575),
                                letterSpacing: 3,
                              )),
                          const Text('9.4V',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk', fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF7E3F),
                                fontStyle: FontStyle.italic,
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Sound Grid 2x2
                  // Sound Grid (Reduced Size Wrap)
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: [
                      _SoundCard(
                        label: 'Fart',
                        icon: Icons.air,
                        accentColor: const Color(0xFFA5FD00),
                        shadowColor: const Color(0xFFA5FD00),
                        code: '01',
                        onTap: () => AudioService.play('fart.mp3'),
                      ),
                      _SoundCard(
                        label: 'Clap',
                        icon: Icons.front_hand,
                        accentColor: const Color(0xFF9900CE),
                        shadowColor: const Color(0xFF9900CE),
                        code: '02',
                        onTap: () => AudioService.play('clap.mp3'),
                        rotationDeg: 1.0,
                      ),
                      _SoundCard(
                        label: 'Kill',
                        icon: Icons.sports_kabaddi,
                        accentColor: const Color(0xFFFE6500),
                        shadowColor: const Color(0xFFFE6500),
                        code: '03',
                        onTap: () => AudioService.play('boom.mp3'),
                        rotationDeg: -1.0,
                      ),
                      _SoundCard(
                        label: 'Whip',
                        icon: Icons.bolt,
                        accentColor: const Color(0xFFA5FD00),
                        shadowColor: const Color(0xFFA5FD00),
                        code: '04',
                        onTap: () => AudioService.play('whip.mp3'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Chaos Assistant
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF262626),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: const Border(
                        left: BorderSide(color: Color(0xFFDDFFAE), width: 4),
                      ),
                      boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 24)],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF000000),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFDDFFAE).withOpacity(0.3)),
                          ),
                          child: const Icon(Icons.smart_toy, color: Color(0xFFDDFFAE), size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CHAOS ASSISTANT',
                                  style: TextStyle(
                                    fontFamily: 'SpaceGrotesk', fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: const Color(0xFFD873FF),
                                    letterSpacing: 2,
                                  )),
                              const SizedBox(height: 4),
                              RichText(text: const TextSpan(
                                style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 15, color: Colors.white, height: 1.3),
                                children: [
                                  TextSpan(text: 'Psst... it\'s too quiet.\n'),
                                  TextSpan(text: 'Try the FART.',
                                      style: TextStyle(color: Color(0xFFDDFFAE), fontStyle: FontStyle.italic)),
                                ],
                              )),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => AudioService.play('fart.mp3'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFA5FD00),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(
                                color: const Color(0xFFA5FD00).withOpacity(0.3),
                                blurRadius: 12, offset: const Offset(0, 4),
                              )],
                            ),
                            child: const Text('PLAY',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk', fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0E0E0E),
                                  letterSpacing: -0.5,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Subwidgets ──────────────────────────────────────────────────────────────

class _PulseDot extends StatefulWidget {
  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(
            color: Color(0xFFDDFFAE),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _SoundCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color accentColor;
  final Color shadowColor;
  final String code;
  final VoidCallback onTap;
  final double rotationDeg;

  const _SoundCard({
    required this.label,
    required this.icon,
    required this.accentColor,
    required this.shadowColor,
    required this.code,
    required this.onTap,
    this.rotationDeg = 0,
  });

  @override
  State<_SoundCard> createState() => _SoundCardState();
}

class _SoundCardState extends State<_SoundCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final angle = widget.rotationDeg * (3.14159 / 180);
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: Transform.rotate(
        angle: angle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 75),
          width: 90, height: 90,
          transform: _pressed
              ? (Matrix4.identity()..translate(0.0, 4.0))
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1919),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: _pressed
                ? []
                : [BoxShadow(color: widget.shadowColor, offset: const Offset(4, 4), blurRadius: 0)],
          ),
          child: Stack(
            children: [
              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: widget.accentColor, size: 32),
                    const SizedBox(height: 4),
                    Text(widget.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        )),
                  ],
                ),
              ),
              // Badge code
              Positioned(
                top: 4, right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(widget.code,
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk', fontSize: 6,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF767575),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
