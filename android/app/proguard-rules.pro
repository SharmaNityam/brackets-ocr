# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google ML Kit
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.** { *; }

# Camera plugin
-keep class io.flutter.plugins.camera.** { *; }

# Permission handler
-keep class com.baseflow.permissionhandler.** { *; }

# SQLite
-keep class io.flutter.plugins.sqflite.** { *; }

# Path provider
-keep class io.flutter.plugins.pathprovider.** { *; }

# Optimize but keep essential classes
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify