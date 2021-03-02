import 'dart:math';
import 'package:meta/meta.dart';
import 'package:flutter/rendering.dart';

import 'consts.dart';

class GlitterPainter extends CustomPainter {
  GlitterPainter({
    @required this.width,
    @required this.height,
    @required this.offset,
    @required this.aspectRatio,
    @required this.color,
    @required this.opacity,
  });

  final double width;
  final double height;
  final Offset offset;
  final double aspectRatio;
  final Color color;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final center = Offset(offset.dx + width / 2, offset.dy + height / 2);
    final radius = min(width, height) * kCircleSizeRatio * 0.55;

    final circlePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(
      circlePath,
      paint
        ..shader = RadialGradient(
          colors: <Color>[
            color.withOpacity(opacity),
            color.withOpacity(opacity * 0.7),
            color.withOpacity(0.0),
          ],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius),
        ),
    );

    final smallerCirclePath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius * 0.5));

    canvas.drawPath(
      smallerCirclePath,
      paint
        ..shader = RadialGradient(
          colors: <Color>[
            const Color(0xFFFFFFFF).withOpacity(opacity * 0.9),
            const Color(0x00FFFFFF),
          ],
          stops: const <double>[0.4, 1.0],
        ).createShader(
          Rect.fromCircle(center: center, radius: radius * 0.5),
        ),
    );

    final squareSize = min(width, height);
    final crossWidth = max(kMinCrossWidth, squareSize / 17);
    final crossHalfWidth = crossWidth / 2;

    final crossPath = Path()
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

double calculateWidth(double width, double height, double aspectRatio) {
  return width / height >= aspectRatio ? height * aspectRatio : width;
}

double calculateHeight(double width, double height, double aspectRatio) {
  return width / height >= aspectRatio ? height : width / aspectRatio;
}
