plugins {
    id("com.android.application")
    id("kotlin-android")
    // Add this line here:
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}
//android {
//    namespace = "com.example.flutter_projectt"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_17
//        targetCompatibility = JavaVersion.VERSION_17
//    }
//
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_17.toString()
//    }
//
//    defaultConfig {
//        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.example.flutter_projectt"
//        // You can update the following values to match your application needs.
//        // For more information, see: https://flutter.dev/to/review-gradle-config.
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//    }
//
//    buildTypes {
//        release {
//            // TODO: Add your own signing config for the release build.
//            // Signing with the debug keys for now, so `flutter run --release` works.
//            signingConfig = signingConfigs.getByName("debug")
//        }
//    }
//}

android {
    namespace = "com.example.flutter_projectt"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17 // Update from 1_8
        targetCompatibility = JavaVersion.VERSION_17 // Update from 1_8
    }

    kotlinOptions {
        jvmTarget = "17" // Update from "1.8"
    }

    defaultConfig {
        applicationId = "com.example.flutter_projectt"

        // 🚨 Notification plugin requires minSdk 21+
        minSdk = flutter.minSdkVersion

        // Corrected property name for Kotlin DSL
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 🚨 Required for apps with many dependencies (like Firebase + Notifications)
        multiDexEnabled = true
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
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
