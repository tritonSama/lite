import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/fluoderpod/fluoderpod_bridge.dart';
import '../../../core/fluoderpod/fluoderpod_view.dart';
import '../../../app/theme.dart';
import 'mission_control_providers.dart';

class GameMapOverlay extends ConsumerStatefulWidget {
  const GameMapOverlay({super.key});

  @override
  ConsumerState<GameMapOverlay> createState() => _GameMapOverlayState();
}

class _GameMapOverlayState extends ConsumerState<GameMapOverlay> {
  String currentMode = 'CYBERPUNK RADAR';
  final List<String> modes = ['CYBERPUNK RADAR', 'TACTICAL GRID', 'SATELLITE'];
  Position? _lastPosition;
  StreamSubscription<Position>? _positionStreamSub;

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  @override
  void dispose() {
    _positionStreamSub?.cancel();
    super.dispose();
  }

  void _startLocationTracking() {
    _positionStreamSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((position) {
      if (mounted) {
        setState(() => _lastPosition = position);
      }
    });
  }

  void _switchMode(String mode) {
    setState(() {
      currentMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendLocationsProvider);
<<<<<<< Updated upstream
=======

    ref.listen(friendLocationsProvider, (previous, next) {
      if (next.value != null) {
        final bridge = ref.read(fluoderpodBridgeProvider);
        if (bridge.isInitialized) {
          final bytes = Uint8List(next.value!.length * 64);
          bridge.ingestBatch(bytes);
        }
      }
    });
>>>>>>> Stashed changes

    return Stack(
      children: [
        // High-Performance Interactive Holographic Globe / Radar View
<<<<<<< Updated upstream
        _HolographicGlobeView(
          mode: currentMode,
          lastPosition: _lastPosition,
          friends: friendsAsync.value ?? [],
=======
        FluoderpodView(
          overlay: Container(),
          onInitialized: () {
            // Push initial state to GPU buffer
            final bridge = ref.read(fluoderpodBridgeProvider);
            final friends = friendsAsync.value ?? [];
            final bytes = Uint8List(friends.length * 64);
            bridge.ingestBatch(bytes);
          },
>>>>>>> Stashed changes
        ),

        // Mode Switcher Overlay Bar
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: modes.map((m) {
              final isSelected = currentMode == m;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? HBColors.primary : HBColors.neutral,
                      foregroundColor: isSelected ? Colors.black : Colors.white,
                      side: const BorderSide(color: HBColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => _switchMode(m),
                    child: Text(
                      m,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.black : Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Interactive Holographic Globe / Radar View ────────────────────────────────
class _HolographicGlobeView extends StatefulWidget {
  final String mode;
  final Position? lastPosition;
  final List<FriendLocation> friends;

  const _HolographicGlobeView({
    required this.mode,
    required this.lastPosition,
    required this.friends,
  });

  @override
  State<_HolographicGlobeView> createState() => _HolographicGlobeViewState();
}

class _HolographicGlobeViewState extends State<_HolographicGlobeView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Offset _panOffset = Offset.zero;
  double _zoomScale = 1.0;
<<<<<<< Updated upstream
=======
  double _previousScale = 1.0;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
<<<<<<< Updated upstream
      onScaleUpdate: (details) {
        setState(() {
          _zoomScale = (_zoomScale * details.scale).clamp(0.5, 3.0);
          _panOffset += details.focalPointDelta;
        });
      },
=======
      onScaleStart: (details) {
        _previousScale = _zoomScale;
      },
      onScaleUpdate: (details) {
        setState(() {
          _zoomScale = (_previousScale * details.scale).clamp(0.5, 4.0);
          _panOffset += details.focalPointDelta;
        });
      },
>>>>>>> Stashed changes
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF0C0F1D), Color(0xFF020617)],
            radius: 0.9,
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _GlobePainter(
                progress: _controller.value,
                mode: widget.mode,
                lastPosition: widget.lastPosition,
                friends: widget.friends,
                panOffset: _panOffset,
                zoomScale: _zoomScale,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }
}

class _GlobePainter extends CustomPainter {
  final double progress;
  final String mode;
  final Position? lastPosition;
  final List<FriendLocation> friends;
  final Offset panOffset;
  final double zoomScale;

  _GlobePainter({
    required this.progress,
    required this.mode,
    required this.lastPosition,
    required this.friends,
    required this.panOffset,
    required this.zoomScale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2 + panOffset.dx, size.height / 2 + panOffset.dy);
    final radius = math.min(size.width, size.height) * 0.40 * zoomScale;

    // Background Cyber Glow
    final glowPaint = Paint()
      ..color = (mode == 'TACTICAL GRID' ? HBColors.secondary : HBColors.primary).withValues(alpha: 0.18)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 32);
    canvas.drawCircle(center, radius + 15, glowPaint);

    // Globe Base Circle
    final globePaint = Paint()
      ..color = mode == 'SATELLITE' ? const Color(0xFF091E11) : const Color(0xFF111827)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, globePaint);

    // Grid / Radar Circles
    final gridPaint = Paint()
      ..color = (mode == 'TACTICAL GRID' ? HBColors.secondary : HBColors.primary).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, radius, gridPaint);
    canvas.drawCircle(center, radius * 0.66, gridPaint);
    canvas.drawCircle(center, radius * 0.33, gridPaint);

    // Crosshairs
    canvas.drawLine(
      Offset(center.dx - radius - 10, center.dy),
      Offset(center.dx + radius + 10, center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius - 10),
      Offset(center.dx, center.dy + radius + 10),
      gridPaint,
    );

    // Rotating Longitude Meridians
    for (int i = 0; i < 8; i++) {
      final angle = (progress * 2 * math.pi) + (i * math.pi / 4);
      final path = Path();
      path.moveTo(center.dx, center.dy - radius);
      path.quadraticBezierTo(
        center.dx + radius * math.sin(angle),
        center.dy,
        center.dx,
        center.dy + radius,
      );
      canvas.drawPath(path, gridPaint);
    }

    // Latitude Parallels
    for (double r = 0.25; r < 1.0; r += 0.25) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center,
          width: radius * 2 * r,
          height: radius * 0.75 * r,
        ),
        gridPaint,
      );
    }

    // Draw User Location Puck (Center / Pulsing)
    final userPaint = Paint()
      ..color = const Color(0xFF00FFFF)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, 8, userPaint);
    canvas.drawCircle(
      center,
      18 + (math.sin(progress * math.pi * 4) * 6),
      Paint()
        ..color = const Color(0xFF00FFFF).withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Draw Friends / Squad Units relative to user
    final friendPaint = Paint()
      ..color = HBColors.secondary
      ..style = PaintingStyle.fill;

    for (int i = 0; i < friends.length; i++) {
      final f = friends[i];
      final angle = (i * (2 * math.pi / friends.length)) + (progress * 0.5);
      final dist = radius * 0.55;
      final fPos = Offset(
        center.dx + math.cos(angle) * dist,
        center.dy + math.sin(angle) * dist,
      );

      canvas.drawCircle(fPos, 6, friendPaint);
      canvas.drawCircle(
        fPos,
        12,
        Paint()
          ..color = HBColors.secondary.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );

      // Draw Label
      final textSpan = TextSpan(
        text: f.name.split(' ').first,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          backgroundColor: Colors.black45,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(fPos.dx - textPainter.width / 2, fPos.dy + 8));
    }
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) => true;
}
