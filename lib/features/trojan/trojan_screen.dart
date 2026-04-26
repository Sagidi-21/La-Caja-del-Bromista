import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'fake_call_screen.dart';
import 'incoming_call_screen.dart';
import 'bait_screen.dart';

class TrojanScreen extends StatefulWidget {
  const TrojanScreen({super.key});

  @override
  State<TrojanScreen> createState() => _TrojanScreenState();
}

class _TrojanScreenState extends State<TrojanScreen> {
  // Estado para los selectores
  String _selectedDisguise = 'Viral';
  String _selectedCategory = 'Chicas'; // Puede ser 'Chicas' o 'Chicos'
  String _selectedImage = 'Morena'; // Valor inicial coherente
  double _delaySeconds = 5.0;
  
  final TextEditingController _messageController = TextEditingController(
    text: "¡Mira esto! 😱 No te lo vas a creer:"
  );

  final List<String> _cebos = ['Viral', 'Noticia', 'Sorteo']; 

  // Mapeo de imágenes por categoría
  final Map<String, List<String>> _imageOptions = {
    'Chicas': ['Morena', 'Rubia'],
    'Chicos': ['Rubio', 'Negro'],
  };

  void _enviarWhatsApp() async {
    final urlBase = "https://lacajadelbromista.web.app/?trampa=1";
    final params = "&c=$_selectedCategory&i=$_selectedImage&d=${_delaySeconds.toInt()}&t=$_selectedDisguise";
    
    final linkFinal = urlBase + params.replaceAll(' ', '%20');
    final text = "${_messageController.text}\n$linkFinal";
    
    final whatsappUrl = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(text)}");
    
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No se pudo abrir WhatsApp. Asegúrate de tenerlo instalado.")),
      );
    }
  }

  void _copiarAlPortapapeles() {
    final urlBase = "https://lacajadelbromista.web.app/?trampa=1";
    final params = "&c=$_selectedCategory&i=$_selectedImage&d=${_delaySeconds.toInt()}&t=$_selectedDisguise";
    final linkFinal = urlBase + params.replaceAll(' ', '%20');
    
    Clipboard.setData(ClipboardData(text: linkFinal)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Enlace copiado al portapapeles! 📋"),
          backgroundColor: Colors.amber,
        ),
      );
    });
  }

  String _generateRandomPhone() {
    final random = Random();
    // Generar número español: +34 6XX XX XX XX
    int prefix = 600 + random.nextInt(100); // 600-699
    int p1 = random.nextInt(100);
    int p2 = random.nextInt(100);
    int p3 = random.nextInt(100);
    
    String f(int n) => n.toString().padLeft(2, '0');
    return "+34 $prefix ${f(p1)} ${f(p2)} ${f(p3)}";
  }

  @override
  Widget build(BuildContext context) {
    // Asegurar que la imagen seleccionada sea válida para la categoría actual
    if (!_imageOptions[_selectedCategory]!.contains(_selectedImage)) {
      _selectedImage = _imageOptions[_selectedCategory]!.first;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── FONDO: GATO INFORMÁTICO ──
          Positioned.fill(
            child: Image.asset(
              'assets/images/Gato_informatico.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          ),
          
          // Capa muy sutil para no oscurecer el fondo
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.05)),
          ),

          // BOTÓN VOLVER (Sutil con círculo de contraste)
          Positioned(
            top: 20,
            left: 10,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── HEADER ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Text(
                          "HACKER LAB",
                          style: TextStyle(color: Colors.green, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── CONTENIDO ──
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 10), // Padding superior a 0 para subir la caja
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SECCIÓN 1: DISFRAZ
                        _buildGlassCard(
                          title: "1. El Cebo (Disfraz del Link)",
                          icon: Icons.masks,
                          color: Colors.amber, // Amarillo anaranjado
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: _cebos.map((label) => Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 2),
                                    child: _buildChoiceChip(label, _getIconForCebo(label)),
                                  ),
                                )).toList(),
                              ),
                              const SizedBox(height: 10), // Reducido de 15 a 10
                              const Text(
                                "Mensaje de gancho:",
                                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _messageController,
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                maxLines: 2,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black.withOpacity(0.3),
                                  hintText: "Escribe algo para engañar a tu víctima...",
                                  hintStyle: const TextStyle(color: Colors.white24),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.amber.withOpacity(0.3)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.amber.withOpacity(0.1)),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10), // Menos espacio entre Cebo y Trampa

                        // SECCIÓN 2: CARGA ÚTIL
                        _buildGlassCard(
                          title: "2. La Trampa (Carga Útil)",
                          icon: Icons.bug_report,
                          color: Colors.red, // Rojo más intenso
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(child: _buildCategoryBtn('Chicas', Icons.face_3)),
                                  const SizedBox(width: 10),
                                  Expanded(child: _buildCategoryBtn('Chicos', Icons.face)),
                                ],
                              ),
                              const SizedBox(height: 8), // Menos espacio interno

                              // Selector de Personaje (Imagen)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.image, color: Colors.white),
                                title: const Text('Personaje (Foto)', style: TextStyle(color: Colors.white)),
                                trailing: DropdownButton<String>(
                                  value: _selectedImage,
                                  dropdownColor: Colors.black87,
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.red),
                                  underline: const SizedBox(),
                                  items: _imageOptions[_selectedCategory]!.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedImage = val);
                                  },
                                ),
                              ),
                              
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Duración del Cebo:", style: TextStyle(color: Colors.white70)),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                                    ),
                                    child: Text(
                                      "${_delaySeconds.toInt()} segundos",
                                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              Slider(
                                value: _delaySeconds,
                                min: 0,
                                max: 15,
                                divisions: 15,
                                activeColor: Colors.red,
                                inactiveColor: Colors.white10,
                                onChanged: (val) => setState(() => _delaySeconds = val),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // SECCIÓN 3: EJECUCIÓN
                        const SizedBox(height: 2), // Espacio mínimo
                        
                        // BOTÓN PRINCIPAL: ENVIAR POR WHATSAPP (CON ANIMACIÓN)
                        _PulseAnimation(
                          child: ElevatedButton.icon(
                            onPressed: _enviarWhatsApp,
                            icon: const Icon(Icons.send, color: Colors.white, size: 24),
                            label: const Text(
                              "¡ENVIAR POR WHATSAPP!",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.0),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25D366),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 8,
                              shadowColor: const Color(0xFF25D366).withOpacity(0.5),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _copiarAlPortapapeles,
                                icon: const Icon(Icons.copy, color: Colors.amber, size: 20),
                                label: const Text("COPIAR ENLACE", style: TextStyle(color: Colors.amber, fontSize: 12, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber.withOpacity(0.1),
                                  foregroundColor: Colors.amber,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  side: BorderSide(color: Colors.amber.withOpacity(0.3)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  final catPath = _selectedCategory.toLowerCase();
                                  final avatarName = "Entrante_${_selectedCategory.substring(0, _selectedCategory.length - 1)}_${_selectedImage}.png";
                                  final videoName = "${_selectedCategory.substring(0, _selectedCategory.length - 1)}_${_selectedImage}_video.mp4".toLowerCase();
                                  final videoPath = 'assets/videos/trampas/$catPath/$videoName';

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BaitScreen(
                                        type: _selectedDisguise,
                                        duration: _delaySeconds,
                                        callerName: _generateRandomPhone(),
                                        avatarPath: 'assets/images/trampas/$catPath/$avatarName',
                                        videoPath: videoPath,
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.remove_red_eye, color: Colors.white70, size: 18),
                                label: const Text("VISTA PREVIA", style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(0.05),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  side: BorderSide(color: Colors.white.withOpacity(0.2)),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15), // Reducido el espacio final
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

  IconData _getIconForCebo(String label) {
    switch (label) {
      case 'Viral': return Icons.local_fire_department;
      case 'Noticia': return Icons.article;
      case 'Sorteo': return Icons.card_giftcard;
      default: return Icons.link;
    }
  }

  // Widget helper para las tarjetas tipo "Glassmorphism"
  Widget _buildGlassCard({required String title, required IconData icon, required Color color, required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3), // Mínimo desenfoque
        child: Container(
          padding: const EdgeInsets.all(12), // Reducido de 20 a 12
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05), // Casi invisible
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.1), width: 1.0), 
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(icon, color: color, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24, height: 12), // Reducido de 20 a 12
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      labelPadding: EdgeInsets.zero,
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: isSelected ? Colors.black : Colors.white),
          const SizedBox(width: 4),
          Text(
            label, 
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white, 
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (bool selected) {
        if (selected) setState(() => _selectedDisguise = label);
      },
      selectedColor: Colors.amber,
      backgroundColor: Colors.white.withOpacity(0.05),
      side: BorderSide(color: isSelected ? Colors.amber : Colors.white24),
    );
  }

  // Botones de Categoría (Chicas / Chicos)
  Widget _buildCategoryBtn(String title, IconData icon) {
    final isSel = _selectedCategory == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSel ? Colors.red.withOpacity(0.6) : Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSel ? Colors.white : Colors.white24, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 5),
            Text(title.toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// Widget para la animación de pulso del botón
class _PulseAnimation extends StatefulWidget {
  final Widget child;
  const _PulseAnimation({required this.child});

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
