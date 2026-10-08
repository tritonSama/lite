$ErrorActionPreference = "Stop"

Write-Host "Building fluoderpod_render native Android library via Cargo NDK..."

# Create jniLibs directory if it doesn't exist
$jniLibs = "$PSScriptRoot\..\android\app\src\main\jniLibs"
if (!(Test-Path -Path $jniLibs)) {
    New-Item -ItemType Directory -Force -Path $jniLibs | Out-Null
}

$fluorescentDir = "$PSScriptRoot\..\third_party\fluorescent\fluoderpod_render"

# Define architectures to build
$targets = @{
    "aarch64-linux-android" = "arm64-v8a"
    "armv7-linux-androideabi" = "armeabi-v7a"
    "x86_64-linux-android" = "x86_64"
}

Push-Location $fluorescentDir

foreach ($target in $targets.Keys) {
    $abi = $targets[$target]
    Write-Host "`n---> Compiling for $abi ($target)"
    
    # We use cargo ndk to build the native library
    cargo ndk -t $abi build --release --no-default-features --features android-render
    
    # Create target directory
    $targetDir = "$jniLibs\$abi"
    if (!(Test-Path -Path $targetDir)) {
        New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
    }
    
    # Copy the .so to the Android jniLibs path where Gradle will automatically bundle it
    Copy-Item "target\$target\release\libfluoderpod_render.so" -Destination "$targetDir\libfluoderpod_render.so" -Force
    Write-Host "Copied libfluoderpod_render.so to $targetDir"
}

Pop-Location
Write-Host "`nNative build complete! The .so files have been injected into the Android jniLibs directory."
