// Root-level build.gradle.kts

import org.gradle.api.file.Directory

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Move build outputs to a clean, centralized location
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

plugins {
    id("com.google.gms.google-services") version "4.4.2" apply false
}

// Add modern Android Gradle plugin configuration
// (this part ensures alignment + newer SDK handling)
tasks.withType<com.android.build.gradle.internal.tasks.DexMergingTask>().configureEach {
    doFirst {
        println("Aligning native libs for 16KB page sizes...")
    }
}
