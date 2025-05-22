// App-level build.gradle.kts (inside android/app)

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // ✅ Apply Firebase Google Services plugin
}

android {
    namespace = "com.example.healthmvp" // Update this with your actual package name
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.healthmvp" // Make sure this matches your app package
        minSdk = 23 // Firebase Messaging requires at least API 21
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Desugaring support for Java 8 features
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Firebase Messaging library (FCM)
    implementation("com.google.firebase:firebase-messaging:23.0.0") // ✅ Add Firebase Messaging
}

flutter {
    source = "../.." // Path to the Flutter source code (relative to this file)
}
