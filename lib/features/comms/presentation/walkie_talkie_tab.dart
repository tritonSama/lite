import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class WalkieTalkieTab extends StatefulWidget {
  const WalkieTalkieTab({super.key});

  @override
  State<WalkieTalkieTab> createState() => _WalkieTalkieTabState();
}

class _WalkieTalkieTabState extends State<WalkieTalkieTab> with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() => _isRecording = true);
    _waveController.repeat(reverse: true);
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() => _isRecording = false);
    _waveController.stop();
    _waveController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: HBSpacing.xl),
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _AudioWavePainter(
                    isRecording: _isRecording,
                    animationValue: _waveController.value,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: HBSpacing.xl),
          Listener(
            onPointerDown: _onPointerDown,
            onPointerUp: _onPointerUp,
            onPointerCancel: (e) => _onPointerUp(null as dynamic),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: _isRecording ? 140 : 150,
              height: _isRecording ? 140 : 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording ? HBColors.tertiary : HBColors.neutral,
                border: Border.all(
                  color: _isRecording ? HBColors.tertiary : HBColors.primary,
                  width: 4,
                ),
                boxShadow: _isRecording
                    ? [
                        BoxShadow(
                          color: HBColors.tertiary.withValues(alpha: 0.8),
                          blurRadius: 30,
                          spreadRadius: 10,
                        )
                      ]
                    : [],
              ),
              child: Center(
                child: Icon(
                  Icons.mic,
                  size: 64,
                  color: _isRecording ? Colors.white : HBColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: HBSpacing.xl),
          Text(
            _isRecording ? 'TRANSMITTING...' : 'HOLD TO SPEAK',
            style: TextStyle(
              color: _isRecording ? HBColors.tertiary : HBColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AudioWavePainter extends CustomPainter {
  final bool isRecording;
  final double animationValue;

  _AudioWavePainter({required this.isRecording, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isRecording) {
      // Draw flat line
      final paint = Paint()
        ..color = HBColors.primary.withValues(alpha: 0.5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), paint);
      return;
    }

    final paint = Paint()
      ..color = HBColors.tertiary
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = HBColors.tertiary.withValues(alpha: 0.5)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);

    final width = size.width;
    final midY = size.height / 2;

    for (double i = 0; i <= width; i += 5) {
      // Create a complex wave combining multiple sine waves
      final normalizedX = i / width;
      // Fade out at edges
      final envelope = math.sin(normalizedX * math.pi);

      final wave1 = math.sin(normalizedX * math.pi * 10 + animationValue * math.pi * 4);
      final wave2 = math.cos(normalizedX * math.pi * 15 - animationValue * math.pi * 2);

      final totalWave = (wave1 + wave2) * 0.5 * envelope;

      final y = midY + totalWave * (size.height / 2);
      path.lineTo(i, y);
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _AudioWavePainter oldDelegate) {
    return oldDelegate.isRecording != isRecording || oldDelegate.animationValue != animationValue;
  }
}
