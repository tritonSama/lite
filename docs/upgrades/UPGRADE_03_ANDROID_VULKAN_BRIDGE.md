# UPGRADE-03: Android Vulkan HardwareBuffer Zero-Copy Bridge
**Agent Role:** Agent Delta (Native NDK & Vulkan Specialist)  
**Target Scope:** Android (strictly Android NDK / Vulkan 1.3)  
**Objective:** Replace fallback surface rendering with zero-copy `AHardwareBuffer` / `ANativeWindow` swapchain linking into Flutter's `TextureRegistry`.

---

## 1. Technical Specification

### 1.1 Swapchain Architecture
```
[Fluoderpod Vulkan Renderer]
         │ (VkImage / AHardwareBuffer)
         ▼
[android_vulkan.rs NDK Surface]
         │ (Zero-copy swapchain)
         ▼
[io.flutter.view.TextureRegistry]
         │ (SurfaceTexture / HardwareBuffer)
         ▼
[Flutter Engine Compositor (Texture Widget)]
```

### 1.2 Target Source Files
* `third_party/fluorescent/fluoderpod_render/src/android_vulkan.rs`
* `android/app/src/main/kotlin/.../FluoderpodPlugin.kt`
* `lib/core/fluoderpod/fluoderpod_bridge.dart`

---

## 2. Step-by-Step Implementation Instructions

### Step 1: Configure Android NDK Build Flags
Ensure `android/app/build.gradle.kts` specifies NDK 28+ and Vulkan linking:
```kotlin
android {
    ndkVersion = "28.2.13676358"
    defaultConfig {
        ndk {
            abiFilters.addAll(listOf("arm64-v8a", "armeabi-v7a", "x86_64"))
        }
    }
}
```

### Step 2: Bind Vulkan Swapchain to `AHardwareBuffer`
In `android_vulkan.rs`:
1. Allocate `VkImage` with `VK_EXTERNAL_MEMORY_HANDLE_TYPE_ANDROID_HARDWARE_BUFFER_BIT_ANDROID`.
2. Export `AHardwareBuffer` handle.
3. Pass buffer pointer through JNI to Kotlin `TextureRegistry.ImageTextureEntry`.
4. Return `textureId` back to Flutter `FluoderpodBridge`.

---

## 3. Build & Verification Commands

```powershell
# 1. Clean previous build artifacts
flutter clean
flutter pub get

# 2. Build release APK targeting native Vulkan NDK
flutter build apk --release

# 3. Check for zero-copy texture registration in release output
Get-Item build/app/outputs/flutter-apk/app-release.apk | Format-List Length, LastWriteTime
```
