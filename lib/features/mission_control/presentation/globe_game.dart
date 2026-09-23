import 'dart:math' as math;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:fluorescent_core/fluorescent_core.dart';
import 'package:fluorescent_flame/fluorescent_flame.dart';

import '../../../app/theme.dart';
import 'mission_control_providers.dart';

class GlobeGame extends FlameGame with PanDetector {
  final List<FriendLocation> friends;

  FluorescentViewport? _viewport;
  GlobeOverlay? _overlay;

  double globeRotation = 0.0;
  bool isDragging = false;

  GlobeGame({required this.friends});

  @override
  Future<void> onLoad() async {
    // 3D Viewport (Mock)
    final world3d = await World3D.load('Holographic Globe');
    final camera3d = ThirdPersonCamera(fov: 60, near: 0.1, far: 1000);

    _viewport = FluorescentViewport(
      world: world3d,
      camera: camera3d,
      textureId: 1, // Suppress stub fallback
      size: size,
    );
    add(_viewport!);

    // 2D Cyberpunk Globe Overlay
    _overlay = GlobeOverlay(this)
      ..size = size
      ..position = size / 2;
    add(_overlay!);
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (_viewport != null) {
      _viewport!.size = size;
    }
    if (_overlay != null) {
      _overlay!.size = size;
      _overlay!.position = size / 2;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isDragging) {
      globeRotation += 0.2 * dt;
      if (globeRotation > 2 * math.pi) {
        globeRotation -= 2 * math.pi;
      }
    }
  }

  @override
  void onPanDown(DragDownInfo info) {
    isDragging = true;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    globeRotation += info.delta.global.x * 0.01;
    if (globeRotation > 2 * math.pi) {
      globeRotation -= 2 * math.pi;
    } else if (globeRotation < 0) {
      globeRotation += 2 * math.pi;
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    isDragging = false;
  }

  @override
  void onPanCancel() {
    isDragging = false;
  }
}

class GlobeOverlay extends PositionComponent with TapCallbacks {
  final GlobeGame game;

  late final double radius;
  final Paint _glowPaint;
  final Paint _basePaint;
  final Paint _linePaint;

  String? _tooltipText;
  Vector2? _tooltipPosition;
  double _tooltipTimer = 0;

  GlobeOverlay(this.game)
    : _glowPaint = Paint()
        ..color = HBColors.primary.withValues(alpha: 0.2)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
      _basePaint = Paint()
        ..color = const Color(0xFF0C0F1D)
        ..style = PaintingStyle.fill,
      _linePaint = Paint()
        ..color = HBColors.primary.withValues(alpha: 0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 {
    anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    radius = math.min(size.x, size.y) * 0.4;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_tooltipText != null) {
      _tooltipTimer -= dt;
      if (_tooltipTimer <= 0) {
        _tooltipText = null;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final center = Offset(size.x / 2, size.y / 2);

    // Draw neon glow
    canvas.drawCircle(center, radius, _glowPaint);

    // Draw globe base
    canvas.drawCircle(center, radius, _basePaint);

    // Draw grid lines (longitude)
    for (int i = 0; i < 12; i++) {
      final t = (i / 12) * math.pi + game.globeRotation;
      final dx = math.cos(t) * radius;

      final path = Path();
      path.moveTo(center.dx, center.dy - radius);
      path.quadraticBezierTo(
        center.dx + dx * 2,
        center.dy,
        center.dx,
        center.dy + radius,
      );
      canvas.drawPath(path, _linePaint);
    }

    // Draw grid lines (latitude)
    for (int i = 1; i < 6; i++) {
      final yOffset = radius * math.cos(i * math.pi / 6);
      final xRadius = radius * math.sin(i * math.pi / 6);
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy + yOffset),
          width: xRadius * 2,
          height: xRadius * 0.4,
        ),
        _linePaint,
      );
    }

    // Draw friends
    for (final friend in game.friends) {
      _renderFriend(canvas, center, friend);
    }

    // Draw tooltip
    if (_tooltipText != null && _tooltipPosition != null) {
      _renderTooltip(canvas, center);
    }
  }

  void _renderFriend(Canvas canvas, Offset center, FriendLocation friend) {
    // Map latitude/longitude to spherical coordinates
    // latitude: -90 to +90
    // longitude: -180 to +180

    final latRad = friend.latitude * (math.pi / 180.0);
    final lngRad = friend.longitude * (math.pi / 180.0);

    // Apply rotation
    final effectiveLng = lngRad + game.globeRotation;

    // Check if point is on the front half of the sphere
    final cosLng = math.cos(effectiveLng);
    if (cosLng < 0) return; // Point is on the back

    // Project to 2D
    final x = radius * math.cos(latRad) * math.sin(effectiveLng);
    final y = -radius * math.sin(latRad);

    final point = Offset(center.dx + x, center.dy + y);

    // Draw marker
    final markerPaint = Paint()
      ..color = HBColors.secondary
      ..style = PaintingStyle.fill;

    final markerGlow = Paint()
      ..color = HBColors.secondary.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    canvas.drawCircle(point, 6, markerGlow);
    canvas.drawCircle(point, 3, markerPaint);
  }

  @override
  void onTapDown(TapDownEvent event) {
    // localPosition is relative to the top-left of this component,
    // which spans the entire game size. We need to check distance from the center.
    final localPosition = event.localPosition - (size / 2);

    bool hit = false;

    for (final friend in game.friends) {
      final latRad = friend.latitude * (math.pi / 180.0);
      final lngRad = friend.longitude * (math.pi / 180.0);
      final effectiveLng = lngRad + game.globeRotation;

      final cosLng = math.cos(effectiveLng);
      if (cosLng < 0) continue; // On back

      final x = radius * math.cos(latRad) * math.sin(effectiveLng);
      final y = -radius * math.sin(latRad);

      final distance = math.sqrt(
        math.pow(x - localPosition.x, 2) + math.pow(y - localPosition.y, 2),
      );

      if (distance < 20) {
        _tooltipText = friend.name;
        _tooltipPosition = Vector2(x, y);
        _tooltipTimer = 3.0; // Show for 3 seconds
        hit = true;
        break;
      }
    }

    if (!hit) {
      _tooltipText = null;
    }
  }

  void _renderTooltip(Canvas canvas, Offset center) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _tooltipText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          backgroundColor: Color(0xAA0C0F1D),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final offset = Offset(
      center.dx + _tooltipPosition!.x - (textPainter.width / 2),
      center.dy + _tooltipPosition!.y - 25 - textPainter.height,
    );

    // Draw a small background rect
    final bgRect = Rect.fromLTWH(
      offset.dx - 4,
      offset.dy - 2,
      textPainter.width + 8,
      textPainter.height + 4,
    );
    final bgPaint = Paint()
      ..color = const Color(0xCC0C0F1D)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = HBColors.secondary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      bgPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(4)),
      borderPaint,
    );

    textPainter.paint(canvas, offset);
  }
}
