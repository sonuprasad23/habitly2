# Keep Drift database classes
-keep class * extends dev.simonscholz.drift.** { *; }

# Keep Flutter local notifications
-keep class com.dexterous.** { *; }

# Keep WorkManager
-keep class androidx.work.** { *; }

# Keep just_audio
-keep class com.google.android.exoplayer2.** { *; }

# General Flutter rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Kotlin
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
