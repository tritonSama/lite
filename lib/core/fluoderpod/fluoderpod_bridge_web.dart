// lib/core/fluoderpod/fluoderpod_bridge_web.dart

import 'dart:typed_data';
import 'dart:js_util';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart'; // For type compatibility

// Provider exposing the web bridge instance.
final fluoderpodBridgeProvider = Provider<FluoderpodBridge>((ref) => FluoderpodBridge());

/// Web implementation of the Fluoderpod bridge using JavaScript interop.
///
/// The real WebGPU binding is provided by the Fluorescent team. This stub
/// forwards calls to global JS functions if they exist, otherwise it behaves as
/// a fallback.
class FluoderpodBridge {
  int _textureId = -1;
  bool _isInitialized = false;

  /// Initialize the WebGPU pipeline. Expects global JS functions
  /// `fluoderpodStart(width, height)` and `fluoderpodResize(width, height)`.
  Future<bool> initialize({required int width, required int height}) async {
    if (!kIsWeb) return false;
    final startFn = getProperty<dynamic>(globalThis, 'fluoderpodStart');
    if (startFn != null) {
      final result = await promiseToFuture<dynamic>(
        callMethod<dynamic>(globalThis, 'fluoderpodStart', [width, height]),
      );
      _textureId = result is int ? result : 1001; // fallback ID
      _isInitialized = true;
      debugPrint('[FluoderpodBridge] WebGPU initialized via JS interop.');
    } else {
      debugPrint('[FluoderpodBridge] JS interop not available, using fallback.');
    }
    return _isInitialized;
  }

  void resize(int width, int height) {
    if (!_isInitialized) return;
    final resizeFn = getProperty<dynamic>(globalThis, 'fluoderpodResize');
    if (resizeFn != null) {
      callMethod<dynamic>(globalThis, 'fluoderpodResize', [width, height]);
    }
  }

  void ingestBatch(Uint8List rawEntityData) {
    // No‑op placeholder – real implementation will push data to GPU buffers.
  }

  int get textureId => _textureId;
  bool get isInitialized => _isInitialized;
}
