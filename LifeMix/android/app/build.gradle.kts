plugins {
    id 'com.android.application'
    id 'com.google.gms.google-services'   // ✅ Firebase plugin
    id 'kotlin-android'
}

android {
    namespace "com.dev.lifemix"   // ✅ must match Firebase package name
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.dev.lifemix"   // ✅ must match Firebase app setup
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
            minifyEnabled false
            shrinkResources false
        }
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:32.3.1')
    implementation 'com.google.firebase:firebase-analytics'
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-firestore'
}