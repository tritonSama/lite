# UPGRADE-03: Android Vulkan Zero-Copy Texture Bridge
**Agent Role:** Agent Delta (Native NDK & Vulkan Specialist)
**Target Scope:** Android only (NDK 28, Vulkan)
**Status:** Plumbing DONE and compiling. Native renderer entry point NOT yet implemented.

---

## 1. Chosen Architecture

Flutter `SurfaceProducer` -> `Surface` -> `ANativeWindow` -> Vulkan swapchain (`VK_KHR_android_surface` via wgpu). No CPU read-back.

This replaces the earlier `AHardwareBuffer` import idea: a Flutter-owned `Surface` is the supported zero-copy path, and wgpu can create a surface from an `ANativeWindow` directly, so no manual `VkImage` import is required.

```
Dart FluoderpodBridge --MethodChannel--> FluorescentVulkanPlugin.kt
   start(w,h): textures.createSurfaceProducer() -> Surface
   JNI createSurfaceFromWindow(Surface) -> ANativeWindow*   (exists in android_vulkan.rs)
   JNI startRenderer(window,w,h) -> Boolean                 (TO IMPLEMENT in Rust)
   returns { textureId } only if the renderer started
```

## 2. Done

* [`FluorescentVulkanPlugin.kt`](file:///c:/Users/blue-/projects/lite/android/app/src/main/kotlin/com/fluorescent/vulkan/FluorescentVulkanPlugin.kt): channel `com.fluorescent.vulkan/texture` with `start`, `resize`, `dispose`. Registered in `MainActivity`.
* [`fluoderpod_bridge.dart`](file:///c:/Users/blue-/projects/lite/lib/core/fluoderpod/fluoderpod_bridge.dart): Android `initialize()` now requests a real texture id. It reports `false` (so `FluoderpodView` keeps its painted fallback) on `NATIVE_UNAVAILABLE`, `NO_WINDOW`, `RENDERER_FAILED`, or a missing plugin. The old hardcoded id `2002` is removed; it would have rendered an invalid `Texture`.
* `flutter build apk --debug` succeeds.

## 3. Remaining (Rust, `third_party/fluorescent/fluoderpod_render`)

Today the APK bundles **no** `libfluoderpod_render.so`, so Android always uses the fallback viewport.

1. **Install targets + cargo-ndk**
   ```powershell
   rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android
   cargo install cargo-ndk
   ```
2. **Implement the JNI entry points** in `android_vulkan.rs` (names fixed by the Kotlin `external` declarations):
   * `Java_com_fluorescent_vulkan_FluorescentVulkanPlugin_startRenderer(env, class, window: jlong, w: jint, h: jint) -> jboolean`: create `wgpu::Instance` (Vulkan), `create_surface` from the `ANativeWindow`, device/queue, configure the surface, spawn the render loop driving `FluoderpodRenderer::execute_frame`.
   * `..._stopRenderer(env, class, window: jlong)`: stop the loop, drop the surface, `ANativeWindow_release`.
   * Wire `fluoderpod_ingest_batch` (already exported in `lib.rs`) to the Dart `ingestBatch()` via FFI or a second channel method.
3. **Build and bundle the library**
   ```powershell
   cd third_party/fluorescent/fluoderpod_render
   cargo ndk -t arm64-v8a -t armeabi-v7a -t x86_64 -o ../../../android/app/src/main/jniLibs build --release
   ```
4. **Verify**
   ```powershell
   flutter build apk --release
   adb logcat -s FluorescentVulkan
   ```
   Expect no `NATIVE_UNAVAILABLE` warning, and the telemetry badge showing `Fluoderpod Vulkan`.

> [!WARNING]
> `wgpu = "0.20"` plus `wgpu-hal`, `webrtc`, `openxr`, and `reticulum` in one crate may not cross-compile to Android unchanged. Gate the non-render dependencies behind features and build a minimal `android-render` feature first.
