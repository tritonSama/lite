package com.fluorescent.vulkan

import android.util.Log
import android.view.Surface
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.view.TextureRegistry

/**
 * Bridges Flutter's texture registry to the native `fluoderpod_render`
 * Vulkan renderer.
 *
 * Path: Flutter [TextureRegistry.SurfaceProducer] -> [Surface] ->
 * `ANativeWindow` -> Vulkan swapchain (VK_KHR_android_surface). Frames never
 * touch the CPU. The JNI symbol names below are fixed by the Rust crate
 * (`android_vulkan.rs`), hence this package name.
 *
 * The native library is optional at runtime: when it, or the
 * `startRenderer` entry point, is missing, `start` reports
 * `NATIVE_UNAVAILABLE` and Dart keeps its fallback viewport. A texture is
 * only exposed once a native renderer has actually claimed the surface, so
 * the UI never shows an empty texture.
 */
object FluorescentVulkanPlugin {
    private const val TAG = "FluorescentVulkan"
    const val CHANNEL = "com.fluorescent.vulkan/texture"

    private var producer: TextureRegistry.SurfaceProducer? = null
    private var nativeWindow: Long = 0L

    // --- JNI (implemented in fluoderpod_render) ---------------------------
    @JvmStatic external fun createSurfaceFromWindow(surface: Surface): Long

    /** Contract still to be implemented in Rust: bind a wgpu surface to
     *  [window] and begin rendering. Returns true on success. */
    @JvmStatic external fun startRenderer(window: Long, width: Int, height: Int): Boolean

    @JvmStatic external fun stopRenderer(window: Long)

    private fun loadNative(): Boolean = try {
        System.loadLibrary("fluoderpod_render")
        true
    } catch (e: UnsatisfiedLinkError) {
        Log.w(TAG, "libfluoderpod_render.so not bundled: ${e.message}")
        false
    }

    fun register(engine: FlutterEngine) {
        val textures = engine.renderer
        MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val w = call.argument<Int>("width") ?: 0
                    val h = call.argument<Int>("height") ?: 0
                    start(textures, w, h, result)
                }
                "resize" -> {
                    val w = call.argument<Int>("width") ?: 0
                    val h = call.argument<Int>("height") ?: 0
                    producer?.setSize(w, h)
                    result.success(null)
                }
                "dispose" -> {
                    release()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun start(
        textures: TextureRegistry,
        width: Int,
        height: Int,
        result: MethodChannel.Result,
    ) {
        if (width <= 0 || height <= 0) {
            result.error("BAD_SIZE", "width/height must be positive", null)
            return
        }
        if (!loadNative()) {
            result.error("NATIVE_UNAVAILABLE", "fluoderpod_render not bundled", null)
            return
        }
        release()
        val p = textures.createSurfaceProducer()
        p.setSize(width, height)
        try {
            val window = createSurfaceFromWindow(p.surface)
            if (window == 0L) {
                p.release()
                result.error("NO_WINDOW", "ANativeWindow creation failed", null)
                return
            }
            if (!startRenderer(window, width, height)) {
                stopRenderer(window)
                p.release()
                result.error("RENDERER_FAILED", "native renderer refused surface", null)
                return
            }
            producer = p
            nativeWindow = window
            result.success(mapOf("textureId" to p.id()))
        } catch (e: UnsatisfiedLinkError) {
            p.release()
            result.error("NATIVE_UNAVAILABLE", e.message, null)
        }
    }

    private fun release() {
        if (nativeWindow != 0L) {
            try { stopRenderer(nativeWindow) } catch (_: UnsatisfiedLinkError) {}
            nativeWindow = 0L
        }
        producer?.release()
        producer = null
    }
}
