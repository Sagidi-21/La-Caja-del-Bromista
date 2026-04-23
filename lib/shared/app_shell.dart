import 'package:flutter/material.dart';
import '../features/soundboard/soundboard_screen.dart';
import '../features/timer/timer_screen.dart';
import '../features/whip/whip_screen.dart';
import '../features/chaos/chaos_screen.dart';
import 'shared_sidebar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 1; // TimerScreen por defecto

  final List<Widget> _screens = const [
    SoundboardScreen(),
    TimerScreen(),
    WhipScreen(),
    ChaosScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      // Drawer Drawer para navegación lateral
      drawer: SharedSidebar(
        currentIndex: _currentIndex,
        onNavigate: (index) {
          setState(() => _currentIndex = index);
        },
      ),
      body: Stack(
        children: [
          // Pantalla actual
          Positioned.fill(
            child: _screens[_currentIndex],
          ),
          
        ],
      ),
    );
  }
}
