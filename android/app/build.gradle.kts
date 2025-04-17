plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    compileSdk = 34 // Replace this with your desired SDK level

    signingConfigs {
        create("release") {
            keyAlias = "my-key-alias"
            keyPassword = "_apitec"
            storeFile = file("my-release-key.jks")
            storePassword = "hc_apitec"
        }
    }

    defaultConfig {
        applicationId = "id.co.ptap.hcmobile"
        minSdk = 21 // Replace with your app's minimum SDK level
        targetSdk = 34
        versionCode = 7 //update versioncode harus selalu lebih besar dari versioncode sebelumnya
        versionName = "1.0.7"
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = true // Enable code shrinking
            isShrinkResources = true // Enable resource shrinking
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    namespace = "id.co.ptap.hcmobile"
}

flutter {
    source = "../.."
}
