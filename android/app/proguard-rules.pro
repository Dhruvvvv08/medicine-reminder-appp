# Flutter Local Notifications plugin
-keep class com.dexterous.** { *; }

# Keep timezone data
-keep class org.joda.time.** { *; }
-keep class sun.util.calendar.ZoneInfoFile { *; }

# Keep Flutter plugin internals (good practice)
-keep class io.flutter.plugins.** { *; }

# Optional: helps with WorkManager or alarm services (if you expand later)
-keep class androidx.work.** { *; }
-keep class androidx.lifecycle.** { *; }