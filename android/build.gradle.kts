// android/build.gradle.kts

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ✅ Custom build directory
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.buildDir = newBuildDir.asFile

subprojects {
    buildDir = newBuildDir.dir(name).asFile
    evaluationDependsOn(":app")
}

// ✅ Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}

// ✅ Firebase plugin definition
plugins {
id("com.google.gms.google-services") version "4.3.15" apply false
}
