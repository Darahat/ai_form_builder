// android/app/build.gradle.kts

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Firebase plugin
    id("dev.flutter.flutter-gradle-plugin") // Flutter plugin last
}

android {
    namespace = "com.example.flutter_starter_kit"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.aiformbuilder"
        minSdk = 24
        targetSdk = 35

        // ✅ Import flutter values from gradle.properties
        versionCode = project.findProperty("flutter.versionCode")?.toString()?.toInt() ?: 1
        versionName = project.findProperty("flutter.versionName")?.toString() ?: "1.0"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {

    // Core Library Desugaring (for using newer Java APIs on older Android versions)
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // ✅ Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // ✅ Firebase SDKs (you can add more like auth, messaging, etc.)
    implementation("com.google.firebase:firebase-analytics")

    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-appcheck-debug")
}
