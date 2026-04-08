plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("kotlin-kapt")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.demo_app"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = "27.0.12077973"
    ndkVersion = "28.1.13356709"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.nhm.appdatxe"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        // minSdk = 21
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
            keyAlias = "key0"
            keyPassword = "Pass#123456"
            //storeFile = file("keystores/demo.jks")
            storePassword = "Pass#123456"
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
            isMinifyEnabled = true
            isShrinkResources = true

            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    java {
        toolchain {
            languageVersion = JavaLanguageVersion.of(21)
        }
    }
    // flavorDimensions "environment"

    // productFlavors {
    //     dev {
    //         dimension "environment"
    //         applicationIdSuffix ".dev"
    //         resValue "string", "app_name", "Demo App (Dev)"
    //     }
    //     staging {
    //         dimension "environment"
    //         applicationIdSuffix ".staging"
    //         resValue "string", "app_name", "Demo App (Staging)"
    //     }
    //     prod {
    //         dimension "environment"
    //         // không có suffix
    //         resValue "string", "app_name", "Demo App"
    //     }
    // }
}

repositories {
    flatDir {
        dirs("libs")
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.fragment:fragment-ktx:1.8.6")
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.navigation:navigation-fragment-ktx:2.8.5")
    implementation("androidx.navigation:navigation-ui-ktx:2.8.5")
    implementation("androidx.lifecycle:lifecycle-viewmodel-ktx:2.8.7")
    implementation("androidx.lifecycle:lifecycle-livedata-ktx:2.8.7")
    implementation("com.google.dagger:dagger:2.51.1")
    kapt("com.google.dagger:dagger-compiler:2.51.1")
    implementation("com.google.dagger:dagger-android-support:2.51.1")
    implementation("com.google.mlkit:face-detection:16.1.7")
    implementation ("com.squareup.okhttp3:okhttp:3.12.8")
    implementation ("com.squareup.okhttp3:logging-interceptor:4.8.1")
    implementation ("com.squareup.retrofit2:adapter-rxjava2:2.3.0")
    implementation ("com.squareup.retrofit2:retrofit:2.8.1")
    implementation ("com.squareup.retrofit2:converter-gson:2.8.1")
    // speed test
    implementation ("com.google.android.gms:play-services-location:21.0.1")
    implementation ("com.google.android.gms:play-services-base:18.3.0")
    implementation ("com.google.android.gms:play-services-maps:18.2.0")

    //ipcc
    implementation("com.nabinbhandari.android:permissions:4.0.0")
    implementation ("androidx.swiperefreshlayout:swiperefreshlayout:1.1.0")
    implementation ("com.squareup:android-times-square:1.7.11@aar")
    implementation ("com.makeramen:roundedimageview:2.3.0")
// google sign in 
    implementation(platform("com.google.firebase:firebase-bom:34.11.0"))
}

flutter {
    source = "../.."
}
