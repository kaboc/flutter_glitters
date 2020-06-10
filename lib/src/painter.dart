import 'dart:math';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'consts.dart';

class GlitterPainter extends CustomPainter {
  GlitterPainter({
    @required this.squareSize,
    @required this.offset,
    @required this.aspectRatio,
    @required this.color,
    @required this.opacity,
  });

  final double squareSize;
  final Offset offset;
  final double aspectRatio;
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final double shrinkageRateX = min(1.0, aspectRatio);
    final double shrinkageRateY = min(1.0, 1.0 / aspectRatio);
    final double width = squareSize * shrinkageRateX;
    final double height = squareSize * shrinkageRateY;
    final Offset center = Offset(offset.dx + width / 2, offset.dy + height / 2);
    final double radius = min(squareSize, squareSize) * kCircleSizeRatio / 2;

    final Path circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(
      circlePath,
      paint
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFFFFFFFF).withOpacity(opacity),
            color.withOpacity(opacity),
            color.withOpacity(0.0),
          ],
          stops: const <double>[0.2, 0.5, 1.0],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius),
        ),
    );

    final double crossWidth = max(kMinCrossWidth, squareSize / 16);
    final double crossHalfWidth = crossWidth / 2;

    final Path crossPath = Path()
      ..moveTo(center.dx - crossHalfWidth, center.dy - crossHalfWidth)
      ..lineTo(center.dx, offset.dy)
      ..lineTo(center.dx + crossHalfWidth, center.dy - crossHalfWidth)
      ..lineTo(offset.dx + width, center.dy)
      ..lineTo(center.dx + crossHalfWidth, center.dy + crossHalfWidth)
      ..lineTo(center.dx, offset.dy + height)
      ..lineTo(center.dx - crossHalfWidth, center.dy + crossHalfWidth)
      ..lineTo(offset.dx, center.dy)
      ..lineTo(center.dx - crossHalfWidth, center.dy - crossHalfWidth);

    canvas.drawPath(
      crossPath,
      paint
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFFFFFFFF).withOpacity(opacity),
            color.withOpacity(opacity),
          ],
          stops: const <double>[0.1, 0.45],
        ).createShader(
          Rect.fromCircle(
            center: Offset(center.dx, center.dy),
            radius: squareSize / 2,
          ),
        ),
    );
  }

  @override
  bool shouldRepaint(GlitterPainter oldDelegate) {
    return opacity != oldDelegate.opacity;
  }
}
