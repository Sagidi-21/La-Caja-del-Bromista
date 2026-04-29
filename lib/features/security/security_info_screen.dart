import 'package:flutter/material.dart';

class SecurityInfoScreen extends StatelessWidget {
  const SecurityInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF09090B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("SEGURIDAD Y LEGAL", 
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "PROXIMIDAD Y PRIVACIDAD",
              "Esta aplicación no recopila, almacena ni comparte datos personales de los usuarios ni de sus contactos. Todas las bromas se ejecutan localmente o mediante enlaces temporales ofuscados.\n\n"
              "Transparencia IA: Todo el contenido audiovisual (imágenes, voces y vídeos) ha sido generado mediante Inteligencia Artificial. No se utilizan representaciones de personas reales. Las noticias y premios simulados son ficciones con fines humorísticos y no pretenden engañar ni suplantar servicios reales.",
              Icons.privacy_tip,
            ),
            const SizedBox(height: 20),
            _buildSection(
              "USO ÉTICO",
              "La Caja del Bromista es exclusivamente para fines de entretenimiento. El usuario es el único responsable del uso que haga de las herramientas de broma. Queda prohibido el uso para acoso o actividades ilegales.",
              Icons.gavel,
            ),
            const SizedBox(height: 20),
            _buildSection(
              "CIBERSEGURIDAD AVANZADA",
              "• Enlaces ofuscados con Base64.\n• Firmas digitales (Checksum) para evitar manipulación.\n• Protección FLAG_SECURE contra capturas de pantalla.\n• Sin dependencias en la nube (Privacidad total).",
              Icons.security,
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                "VERSIÓN 1.0.0 (RELEASE SEGURO)",
                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF18181B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFFC3F400), size: 24),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Text(content, style: const TextStyle(color: Colors.white70, height: 1.5)),
        ],
      ),
    );
  }
}
