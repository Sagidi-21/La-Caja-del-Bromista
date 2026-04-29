# Reglas de ProGuard para La Caja del Bromista

# Preservar clases de Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Evitar que se eliminen recursos necesarios por reflexión
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes EnclosingMethod

# Ocultar nombres de archivos y números de línea en logs de error (Ciberseguridad)
-renamesourcefileattribute SourceFile
-keepattributes SourceFile,LineNumberTable

# Optimización agresiva
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
