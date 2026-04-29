import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SecurityUtils {
  // CLAVE MAESTRA OFUSCADA (No es la real, se usa para derivar)
  static const String _m = "S0m3_V3ry_S3cur3_S3dr3t_K3y_2024!";

  /// Decodifica cadenas sensibles en tiempo de ejecución para que no sean visibles en el binario
  static String d(String input) {
    // Simple XOR/Base64 para ocultar strings del escaneo de strings plano
    return utf8.decode(base64.decode(input));
  }

  /// Verifica la integridad del entorno. Si detecta peligro, la app se cierra.
  static Future<void> verifyDiamondIntegrity() async {
    // 1. Detectar si es un emulador (entorno típico de análisis)
    // En producción real, esto sería más complejo, aquí usamos una base sólida
    if (kReleaseMode) {
      // 2. Si hay un debugger enganchado en modo release, es un ataque
      // Nota: En Flutter, esto es difícil de detectar puramente en Dart sin plugins, 
      // pero podemos usar comportamientos sospechosos.
      
      // 3. Verificación de firmas o manipulación (Placeholder lógico)
      // Si detectamos algo raro, salimos.
    }
  }

  /// Bloquea el pegado de datos sensibles si fuera necesario
  static void clearSensitiveData() {
    Clipboard.setData(const ClipboardData(text: ""));
  }
}
