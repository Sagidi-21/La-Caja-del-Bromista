# Configuración de Android Emulator MCP para Antigravity

Este documento detalla la instalación y configuración del servidor MCP para la interacción con emuladores de Android Studio dentro del entorno de **Antigravity**.

## 1. Información General
*   **Servidor MCP:** `mcp-android-emulator`
*   **Método de ejecución:** `npx -y` (Ejecución directa de paquete Node.js)
*   **Dependencia Principal:** Android Debug Bridge (ADB)

## 2. Detalles Técnicos de la Instalación

### Localización de ADB
Se ha identificado la ruta de ADB en el sistema local para asegurar la comunicación con el emulador:
`C:\Users\Salva\AppData\Local\Android\Sdk\platform-tools\adb.exe`

### Modificación del Archivo de Configuración
Se ha actualizado el archivo de configuración maestro de Antigravity:
**Ruta:** `C:\Users\Salva\.gemini\antigravity\mcp_config.json`

**Bloque añadido:**
```json
"android-emulator": {
  "command": "npx",
  "args": [
    "-y",
    "mcp-android-emulator"
  ],
  "env": {
    "ADB_PATH": "C:\\Users\\Salva\\AppData\\Local\\Android\\Sdk\\platform-tools\\adb.exe"
  }
}
```

## 3. Verificación de Funcionamiento
Se realizó una prueba de ejecución manual con el comando:
`npx -y mcp-android-emulator --help`

**Resultado:** El servidor inició correctamente reportando actividad en `stdio`.

## 4. Pasos para la Activación
Para que las herramientas del emulador estén disponibles en la sesión de Antigravity, se deben seguir estos pasos:

1.  **Cerrar Antigravity** completamente.
2.  **Iniciar un emulador** en Android Studio (AVD Manager).
3.  **Abrir Antigravity**.
4.  Verificar en la lista de herramientas disponibles la presencia de comandos como:
    *   `mcp_android_emulator_screenshot`
    *   `mcp_android_emulator_tap`
    *   `mcp_android_emulator_list_devices`

## 5. Resolución de Problemas
*   **Error de conexión:** Asegúrate de que el emulador esté visible ejecutando `adb devices` en una terminal.
*   **Herramientas no aparecen:** Verifica que el archivo `mcp_config.json` no tenga errores de sintaxis JSON.
