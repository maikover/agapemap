import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../core/constants/art_pattern.dart';

/// Widget de fondo con arte generativo animado
class GenerativeArtBackground extends StatefulWidget {
  final Color baseColor;
  final ArtPattern pattern;
  final double animationDuration; // segundos
  final Widget? child;

  const GenerativeArtBackground({
    super.key,
    required this.baseColor,
    this.pattern = ArtPattern.mandala,
    this.animationDuration = 5.0,
    this.child,
  });

  @override
  State<GenerativeArtBackground> createState() =>
      _GenerativeArtBackgroundState();
}

class _GenerativeArtBackgroundState extends State<GenerativeArtBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          Duration(milliseconds: (widget.animationDuration * 1000).toInt()),
      vsync: this,
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
          painter: GenerativeArtPainter(
            pattern: widget.pattern,
            baseColor: widget.baseColor,
            animationValue: _controller.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// Painter para el arte generativo
class GenerativeArtPainter extends CustomPainter {
  final ArtPattern pattern;
  final Color baseColor;
  final double animationValue;

  GenerativeArtPainter({
    required this.pattern,
    required this.baseColor,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = math.min(size.width, size.height) / 2;

    switch (pattern) {
      case ArtPattern.mandala:
        _drawMandala(canvas, center, maxRadius);
        break;
      case ArtPattern.waves:
        _drawWaves(canvas, size);
        break;
      case ArtPattern.spiral:
        _drawSpiral(canvas, center, maxRadius);
        break;
      case ArtPattern.particles:
        _drawParticles(canvas, size);
        break;
    }
  }

  void _drawMandala(Canvas canvas, Offset center, double maxRadius) {
    final layers = 5;
    final petalsPerLayer = [6, 12, 18, 24, 30];

    for (int layer = 0; layer < layers; layer++) {
      final radius = maxRadius * (0.2 + layer * 0.16);
      final petalCount = petalsPerLayer[layer];
      final layerColor = HSLColor.fromColor(baseColor)
          .withLightness(0.3 + layer * 0.1)
          .toColor();

      final paint = Paint()
        ..color = layerColor.withOpacity(0.15 - layer * 0.02)
        ..style = PaintingStyle.fill;

      for (int i = 0; i < petalCount; i++) {
        final angle =
            (i / petalCount) * 2 * math.pi + animationValue * 2 * math.pi;
        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        // Dibujar pétalo
        final path = Path();
        final petalSize = maxRadius * 0.12;

        path.moveTo(x, y);
        path.quadraticBezierTo(
          x + petalSize * math.cos(angle + 0.3),
          y + petalSize * math.sin(angle + 0.3),
          x + petalSize * math.cos(angle),
          y + petalSize * math.sin(angle),
        );
        path.quadraticBezierTo(
          x + petalSize * math.cos(angle - 0.3),
          y + petalSize * math.sin(angle - 0.3),
          x,
          y,
        );

        canvas.drawPath(path, paint);
      }
    }

    // Círculos concéntricos
    for (int i = 1; i <= 4; i++) {
      final circlePaint = Paint()
        ..color = baseColor.withOpacity(0.05)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, maxRadius * i * 0.2, circlePaint);
    }
  }

  void _drawWaves(Canvas canvas, Size size) {
    final waveCount = 8;

    for (int i = 0; i < waveCount; i++) {
      final yOffset = size.height * (i / waveCount);
      final amplitude = size.height * 0.05 + i * 5;
      final frequency = 0.02 + i * 0.005;
      final phaseShift = animationValue * 2 * math.pi;

      final waveColor =
          HSLColor.fromColor(baseColor).withLightness(0.2 + i * 0.08).toColor();

      final paint = Paint()
        ..color = waveColor.withOpacity(0.1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final path = Path();
      path.moveTo(0, yOffset);

      for (double x = 0; x <= size.width; x += 5) {
        final y = yOffset +
            math.sin(x * frequency + phaseShift + i) * amplitude +
            math.sin(x * frequency * 2 + phaseShift) * amplitude * 0.5;
        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }
  }

  void _drawSpiral(Canvas canvas, Offset center, double maxRadius) {
    final spiralArms = 3;
    final pointsPerArm = 100;

    for (int arm = 0; arm < spiralArms; arm++) {
      final armAngle = arm * 2 * math.pi / spiralArms;

      final paint = Paint()
        ..color = baseColor.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      final path = Path();

      for (int i = 0; i < pointsPerArm; i++) {
        final t = i / pointsPerArm;
        final angle = armAngle + t * 4 * math.pi + animationValue * 2 * math.pi;
        final radius = t * maxRadius;

        final x = center.dx + radius * math.cos(angle);
        final y = center.dy + radius * math.sin(angle);

        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }

      canvas.drawPath(path, paint);
    }

    // Puntos decorativos
    for (int i = 0; i < 20; i++) {
      final angle = (i / 20) * 2 * math.pi + animationValue * math.pi;
      final radius = maxRadius * 0.3 + (i % 5) * maxRadius * 0.12;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      final dotPaint = Paint()
        ..color = baseColor.withOpacity(0.2)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  void _drawParticles(Canvas canvas, Size size) {
    final random = math.Random(42); // Seed fixed for consistency
    final particleCount = 50;

    for (int i = 0; i < particleCount; i++) {
      final baseX = random.nextDouble() * size.width;
      final baseY = random.nextDouble() * size.height;

      // Movimiento oscilante
      final offsetX = math.sin(animationValue * 2 * math.pi + i) * 30;
      final offsetY = math.cos(animationValue * 2 * math.pi + i * 1.5) * 30;

      final x = (baseX + offsetX) % size.width;
      final y = (baseY + offsetY) % size.height;

      final particleSize = 2 + random.nextDouble() * 4;
      final opacity = 0.05 + random.nextDouble() * 0.15;

      final particleColor = HSLColor.fromColor(baseColor)
          .withLightness(0.3 + random.nextDouble() * 0.4)
          .toColor();

      final paint = Paint()
        ..color = particleColor.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }

    // Líneas de conexión entre partículas cercanas
    final connectionPaint = Paint()
      ..color = baseColor.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;

    for (int i = 0; i < particleCount; i++) {
      final x1 = (random.nextDouble() * size.width +
              math.sin(animationValue * 2 * math.pi + i) * 30) %
          size.width;
      final y1 = (random.nextDouble() * size.height +
              math.cos(animationValue * 2 * math.pi + i) * 30) %
          size.height;

      for (int j = i + 1; j < particleCount; j++) {
        final x2 = (random.nextDouble() * size.width +
                math.sin(animationValue * 2 * math.pi + j) * 30) %
            size.width;
        final y2 = (random.nextDouble() * size.height +
                math.cos(animationValue * 2 * math.pi + j) * 30) %
            size.height;

        final distance = math.sqrt(math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2));

        if (distance < 80) {
          connectionPaint.color =
              baseColor.withOpacity(0.02 * (1 - distance / 80));
          canvas.drawLine(Offset(x1, y1), Offset(x2, y2), connectionPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GenerativeArtPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.pattern != pattern;
  }
}
