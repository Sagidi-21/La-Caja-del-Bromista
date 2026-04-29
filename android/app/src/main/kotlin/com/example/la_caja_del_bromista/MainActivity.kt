package com.example.la_caja_del_bromista

import android.view.WindowManager.LayoutParams
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // Ciberseguridad: Bloquea capturas de pantalla y grabaciones
        window.addFlags(LayoutParams.FLAG_SECURE)
        super.configureFlutterEngine(flutterEngine)
    }
}
