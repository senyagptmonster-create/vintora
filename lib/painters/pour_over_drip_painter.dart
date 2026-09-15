import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/vintora_theme.dart';

class PourOverDripPainter extends CustomPainter {
  final double extractionProgress;
  final bool isExtracting;

  PourOverDripPainter({required this.extractionProgress, required this.isExtracting});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // 1. Conical filter cone
    final conePath = Path()
      ..moveTo(width * 0.2, height * 0.1)
      ..lineTo(width * 0.8, height * 0.1)
      ..lineTo(width * 0.55, height * 0.5)
      ..lineTo(width * 0.45, height * 0.5)
      ..close();

    final conePaint = Paint()
      ..color = const Color(0xFFF3EDE2)
      ..style = PaintingStyle.fill;
    canvas.drawPath(conePath, conePaint);

    final coneStroke = Paint()
      ..color = VintoraTheme.edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(conePath, coneStroke);

    // 2. Coffee bed inside cone
    final bedPath = Path()
      ..moveTo(width * 0.28, height * 0.22)
      ..lineTo(width * 0.72, height * 0.22)
      ..lineTo(width * 0.54, height * 0.48)
      ..lineTo(width * 0.46, height * 0.48)
      ..close();

    final bedPaint = Paint()
      ..color = const Color(0xFF45220C)
      ..style = PaintingStyle.fill;
    canvas.drawPath(bedPath, bedPaint);

    // 3. Falling coffee drops if extracting
    if (isExtracting) {
      final dropPaint = Paint()..color = VintoraTheme.accent;
      for (int i = 0; i < 3; i++) {
        final dropY = height * 0.53 + (i * 14) + (sin(extractionProgress * 20 + i) * 3);
        if (dropY < height * 0.72) {
          canvas.drawCircle(Offset(width * 0.5, dropY), 3.5, dropPaint);
        }
      }
    }

    // 4. Decanter glass vessel bottom
    final carafePath = Path()
      ..moveTo(width * 0.38, height * 0.65)
      ..lineTo(width * 0.62, height * 0.65)
      ..lineTo(width * 0.75, height * 0.95)
      ..lineTo(width * 0.25, height * 0.95)
      ..close();

    final carafeStroke = Paint()
      ..color = VintoraTheme.edge
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawPath(carafePath, carafeStroke);

    // 5. Liquid level in carafe
    final liquidHeight = (height * 0.25) * extractionProgress.clamp(0.0, 1.0);
    if (liquidHeight > 0) {
      final liquidTop = height * 0.95 - liquidHeight;
      final liquidRect = Rect.fromLTRB(width * 0.28, liquidTop, width * 0.72, height * 0.95);
      final liquidPaint = Paint()
        ..color = VintoraTheme.accent.withValues(alpha: 0.75)
        ..style = PaintingStyle.fill;
      canvas.drawRRect(RRect.fromRectAndRadius(liquidRect, const Radius.circular(8)), liquidPaint);
    }
  }

  @override
  bool shouldRepaint(covariant PourOverDripPainter oldDelegate) {
    return oldDelegate.extractionProgress != extractionProgress ||
        oldDelegate.isExtracting != isExtracting;
  }
}
