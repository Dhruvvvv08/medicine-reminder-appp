// Root-level build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // Firebase plugin for Google services (apply this in the app-level build.gradle.kts)
        classpath("com.google.gms:google-services:4.3.15") // Make sure this is the correct version
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Custom build directories configuration
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
