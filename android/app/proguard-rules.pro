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

# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Razorpay ProGuard rules
-keep class com.razorpay.** { *; }
-keep class proguard.annotation.** { *; }
-dontwarn proguard.annotation.**
-keepclassmembers class com.razorpay.** { *; }
-keepnames class com.razorpay.** { *; }

# Keep analytics and payment classes
-keep class com.razorpay.AnalyticsEvent { *; }
-keep class com.razorpay.CheckoutActivity { *; }

# Google Pay related classes - ignore missing classes
-dontwarn com.google.android.apps.nbu.paisa.inapp.client.api.**
-keep class com.google.android.apps.nbu.paisa.inapp.client.api.** { *; }

# Additional Google Pay ignores
-dontwarn com.google.android.apps.nbu.paisa.**
-dontwarn com.razorpay.RzpGpayMerged

# Prevent obfuscation of critical classes
-keepattributes Signature
-keepattributes Annotation

# Keep all classes with native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
