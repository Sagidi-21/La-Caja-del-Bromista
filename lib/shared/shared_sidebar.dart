import 'dart:ui';
import 'package:flutter/material.dart';
import '../features/security/security_info_screen.dart';

class SharedSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const SharedSidebar({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      {'icon': Icons.volume_up, 'label': 'SONIDOS', 'index': 0},
      {'icon': Icons.timer,     'label': 'TEMPORIZADOR', 'index': 1},
      {'icon': Icons.toys,      'label': 'LÁTIGO', 'index': 2},
      {'icon': Icons.cyclone,   'label': 'CAOS', 'index': 3},
      {'icon': Icons.mic,       'label': 'GRABACIÓN', 'index': 4},
      {'icon': Icons.content_cut, 'label': 'CORTAPELO', 'index': 5},
    ];

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      width: MediaQuery.of(context).size.width * 0.80, // 80% del ancho
      child: Stack(
        children: [
          // Glassmorphism Blur Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  border: const Border(
                    right: BorderSide(color: Color(0xFFFF5AF9), width: 3),
                  ),
                ),
              ),
            ),
          ),
          // Sidebar Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Perfil de Usuario
                  Row(
                    children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFF5AF9),
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [BoxShadow(color: Color(0xFFFF5AF9), blurRadius: 15)],
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("BROMISTA #1", style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -1)),
                            Text("NIVEL: CAOS ÉPICO", style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFC3F400))),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  const Text("NAVEGACIÓN", style: TextStyle(color: Colors.white38, fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 2)),
                  const SizedBox(height: 16),

                  Expanded(
                    child: ListView.separated(
                      itemCount: navItems.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final item = navItems[i];
                        final index = item['index'] as int;
                        final isSelected = index == currentIndex;

                        return _SidebarMenuItem(
                          icon: item['icon'] as IconData,
                          title: item['label'] as String,
                          isSelected: isSelected,
                          onTap: () {
                            onNavigate(index);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),

                  // Footer Actions
                  const Divider(color: Colors.white10),
                  const SizedBox(height: 16),
                  _SidebarMenuItem(
                    icon: Icons.gavel, 
                    title: "SEGURIDAD Y LEGAL", 
                    isSelected: false, 
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecurityInfoScreen()),
                      );
                    }
                  ),
                  const SizedBox(height: 12),
                  _SidebarMenuItem(icon: Icons.settings, title: "AJUSTES", isSelected: false, onTap: () {}),
                  const SizedBox(height: 12),
                  
                  // Quick Action Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5AF9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "CERRAR MENÚ",
                        style: TextStyle(fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black, letterSpacing: 1),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SidebarMenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarMenuItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_SidebarMenuItem> createState() => _SidebarMenuItemState();
}

class _SidebarMenuItemState extends State<_SidebarMenuItem> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.isSelected ? const Color(0xFFC3F400) : const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.black, width: 3),
          boxShadow: _pressed ? [] : const [BoxShadow(color: Colors.black, offset: Offset(4, 4))],
        ),
        child: Row(
          children: [
            Icon(widget.icon, color: widget.isSelected ? Colors.black : Colors.white, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: widget.isSelected ? Colors.black : Colors.white,
                ),
              ),
            ),
            if (widget.isSelected)
              const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
