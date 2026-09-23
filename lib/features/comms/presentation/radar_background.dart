import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../mission_control/presentation/mission_control_providers.dart';

class RadarBackground extends ConsumerStatefulWidget {
  const RadarBackground({super.key});

  @override
  ConsumerState<RadarBackground> createState() => _RadarBackgroundState();
}

class _RadarBackgroundState extends ConsumerState<RadarBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Speed of radar sweep
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendLocationsProvider);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _RadarPainter(
            sweepAngle: _controller.value * 2 * math.pi,
            friends: friendsAsync.value ?? [],
          ),
        );
      },
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double sweepAngle;
  final List<FriendLocation> friends;

  _RadarPainter({required this.sweepAngle, required this.friends});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.45;

    // Background circle
    final bgPaint = Paint()
      ..color = const Color(0xFF0C0F1D).withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Radar grid lines
    final gridPaint = Paint()
      ..color = HBColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), gridPaint);
    }
    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      gridPaint,
    );

    // Sweeping radar arm
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          HBColors.primary.withValues(alpha: 0.0),
          HBColors.primary.withValues(alpha: 0.6),
        ],
        stops: const [0.0, 1.0],
        transform: GradientRotation(sweepAngle - math.pi / 2),
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      sweepAngle - math.pi / 2, // Start slightly behind
      math.pi / 2, // Sweep width
      true,
      sweepPaint,
    );

    // Draw friend blips
    final blipPaint = Paint()
      ..color = HBColors.secondary
      ..style = PaintingStyle.fill;
    final blipGlow = Paint()
      ..color = HBColors.secondary.withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (final friend in friends) {
      // Very simple mock projection relative to SF (37.77, -122.41) just to spread them out on radar
      final dy = (friend.latitude - 37.77) * 2;
      final dx = (friend.longitude + 122.41) * 2;

      // Normalize and fit inside radius
      final dist = math.sqrt(dx * dx + dy * dy);
      double renderX, renderY;

      if (dist > 0) {
        final scale =
            math.min(dist * 20, radius * 0.9) /
            dist; // Keeps them inside the radar
        renderX = center.dx + dx * scale;
        renderY = center.dy - dy * scale; // Invert Y
      } else {
        renderX = center.dx;
        renderY = center.dy;
      }

      final point = Offset(renderX, renderY);

      // Check if the radar just passed this blip to make it glow brighter
      final angleToBlip = math.atan2(
        point.dy - center.dy,
        point.dx - center.dx,
      );
      double normalizedBlipAngle = angleToBlip;
      if (normalizedBlipAngle < 0) normalizedBlipAngle += 2 * math.pi;

      double normalizedSweep = sweepAngle;

      double diff = normalizedSweep - normalizedBlipAngle;
      if (diff < 0) diff += 2 * math.pi;

      if (diff < math.pi / 2) {
        // It's in the fading sweep
        canvas.drawCircle(point, 6, blipGlow);
        canvas.drawCircle(point, 3, blipPaint);
      } else {
        // Faded out
        canvas.drawCircle(
          point,
          2,
          blipPaint..color = HBColors.secondary.withValues(alpha: 0.3),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return true; // Always repaint during animation
  }
}
