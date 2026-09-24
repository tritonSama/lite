import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../app/theme.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comms & Tools')),
      body: const Column(
        children: [
          Expanded(flex: 2, child: _GlobeVisualization()),
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.satellite_alt, size: 48, color: HBColors.primary),
                  SizedBox(height: HBSpacing.md),
                  Text(
                    'Global Comms Link',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: HBSpacing.sm),
                  Text(
                    'Walkie Talkie & GPS coming soon',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobeVisualization extends StatefulWidget {
  const _GlobeVisualization();

  @override
  State<_GlobeVisualization> createState() => _GlobeVisualizationState();
}

class _GlobeVisualizationState extends State<_GlobeVisualization>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GlobePainter(_controller.value * 2 * math.pi),
          size: Size.infinite,
        );
      },
    );
  }
}

class _GlobePainter extends CustomPainter {
  final double rotation;

  _GlobePainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.4;

    // Draw neon glow
    final glowPaint = Paint()
      ..color = HBColors.primary.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30);
    canvas.drawCircle(center, radius, glowPaint);

    // Draw globe base
    final paint = Paint()
      ..color = const Color(0xFF0C0F1D)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, paint);

    // Draw grid lines (longitude)
    final linePaint = Paint()
      ..color = HBColors.primary.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 12; i++) {
      final t = (i / 12) * math.pi + rotation;
      final dx = math.cos(t) * radius;

      final path = Path();
      path.moveTo(center.dx, center.dy - radius);
      path.quadraticBezierTo(
        center.dx + dx * 2,
        center.dy,
        center.dx,
        center.dy + radius,
      );
      canvas.drawPath(path, linePaint);
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
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GlobePainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}
