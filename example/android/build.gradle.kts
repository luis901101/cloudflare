allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// apivideo_live_stream 1.2.0 (its latest release) compiles against android-34, and its
// native_device_orientation 1.x against android-31; current AndroidX needs 34+ (36 for some).
// Raise only those two plugin modules for this example.
subprojects {
    if (name == "apivideo_live_stream" || name == "native_device_orientation") {
        afterEvaluate {
            extensions.configure<com.android.build.gradle.LibraryExtension> { compileSdk = 36 }
        }
    }
}

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
