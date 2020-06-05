import 'dart:math';
import 'package:flutter/material.dart';

class GlitterPainter extends CustomPainter {
  GlitterPainter({
    @required this.actualSize,
    @required this.offset,
    @required this.aspectRatio,
    @required Color color,
    @required double opacity,
  }) : _paint = Paint()
          ..color = color.withOpacity(opacity)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

  final double actualSize;
  final Offset offset;
  final double aspectRatio;
  final Paint _paint;

  double get _sizeRatio {
    final double cos45 = 1 / sqrt(2);
    final double diff = actualSize * cos45 - actualSize / 2;
    final double pathSize = actualSize + diff * 2;

    return actualSize / pathSize;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double sizeRatio = _sizeRatio;
    final double s = actualSize * sizeRatio;
    final double diff = (actualSize - actualSize * sizeRatio) / 2;
    final double x = offset.dx + diff - actualSize * (1 - aspectRatio) / 2;
    final double y = offset.dy + diff;
    final double center = s / 2;
    final Radius radius = Radius.circular(actualSize * 0.55);

    final Path path = Path()
      ..moveTo(x, y)
      ..arcToPoint(Offset(x + s, y), radius: radius, clockwise: false)
      ..arcToPoint(Offset(x + s, y + s), radius: radius, clockwise: false)
      ..arcToPoint(Offset(x, y + s), radius: radius, clockwise: false)
      ..arcToPoint(Offset(x, y), radius: radius, clockwise: false);

    canvas
      ..translate(x + center, y + center)
      ..scale(aspectRatio, 1.0)
      ..rotate(pi / 4)
      ..translate(-x - center, -y - center)
      ..drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(GlitterPainter oldDelegate) {
    return _paint.color != oldDelegate._paint.color;
  }
}
