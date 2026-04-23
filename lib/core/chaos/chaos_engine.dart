import 'dart:math';

class ChaosAssistant {
  /// Sugiere una broma basada en el nivel de ruido (RMS) y la inactividad.
  /// No graba audio, solo procesa la magnitud del sonido en tiempo real.
  static String getSuggestion({
    required double currentRms, 
    required int inactivitySeconds,
  }) {
    // Escenario 1: Silencio incómodo (RMS bajo) -> Suele ser el mejor momento para un pedo
    if (currentRms < 0.05 && inactivitySeconds > 10) {
      return "OPORTUNIDAD: Un pedo ahora sería legendario. 💨";
    }

    // Escenario 2: Ambiente muy ruidoso -> Clímax para un aplauso irónico o finisher
    if (currentRms > 0.7) {
      return "¡CAOS DETECTADO! Desata el finalizador. 💀";
    }

    // Escenario 3: Inactividad prolongada -> Recordatorio
    if (inactivitySeconds > 60) {
      return "¿Demasiada paz? Prueba el látigo. ⚡";
    }

    return "Esperando el momento perfecto... 😈";
  }
}
