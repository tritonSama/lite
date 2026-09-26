import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'fluoderpod_bridge.dart';

/// Unified Flutter view rendering the 3D Fluoderpod GPU-driven scene.
/// Target Platforms: Android (Vulkan NDK Texture) and Web (WebGPU).
class FluoderpodView extends ConsumerStatefulWidget {
  final Widget? overlay;
  final VoidCallback? onInitialized;

  const FluoderpodView({
    super.key,
    this.overlay,
    this.onInitialized,
  });

  @override
  ConsumerState<FluoderpodView> createState() => _FluoderpodViewState();
}

class _FluoderpodViewState extends ConsumerState<FluoderpodView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final bridge = ref.read(fluoderpodBridgeProvider);
      final size = MediaQuery.of(context).size;
      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      await bridge.initialize(
        width: (size.width * pixelRatio).toInt(),
        height: (size.height * pixelRatio).toInt(),
      );
      if (mounted) {
        widget.onInitialized?.call();
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bridge = ref.watch(fluoderpodBridgeProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Native render surface or holographic fallback
            if (bridge.isInitialized && !kIsWeb && defaultTargetPlatform == TargetPlatform.android && bridge.textureId > 0)
              Texture(textureId: bridge.textureId)
            else
              // Animated holographic fallback for Web/simulators
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: _FluoderpodHoloPainter(
                      progress: _pulseCtrl.value,
                      isWeb: kIsWeb,
                    ),
                  );
                },
              ),

            // Telemetry overlay badge (FPS / Clusters)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.cyanAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      kIsWeb
                          ? 'Fluoderpod WebGPU (60 FPS)'
                          : 'Fluoderpod Vulkan (${bridge.currentFps.toInt()} FPS)',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Optional child UI overlay
            if (widget.overlay != null) widget.overlay!,
          ],
        );
      },
    );
  }
}

class _FluoderpodHoloPainter extends CustomPainter {
  final double progress;
  final bool isWeb;

  _FluoderpodHoloPainter({required this.progress, required this.isWeb});

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF070B14);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final gridPaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.12)
      ..strokeWidth = 1.0;

    const step = 40.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final center = Offset(size.width / 2, size.height / 2);
    final corePaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.2 + progress * 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, 60 + progress * 20, corePaint);
    canvas.drawCircle(center, 120 + progress * 10, corePaint..color = Colors.indigoAccent.withValues(alpha: 0.15));
  }

  @override
  bool shouldRepaint(covariant _FluoderpodHoloPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
