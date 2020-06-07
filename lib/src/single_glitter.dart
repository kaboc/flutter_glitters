import 'package:flutter/widgets.dart';

import 'consts.dart';
import 'painter.dart';

class SingleGlitter extends StatelessWidget {
  const SingleGlitter({
    Key key,
    @required this.size,
    double aspectRatio,
    Color color,
    double opacity,
  })  : assert(size != null && size > 0.0),
        assert(aspectRatio == null || aspectRatio > 0.0),
        assert(opacity == null || (opacity > 0.0 && opacity <= 1.0)),
        _aspectRatio = aspectRatio ?? 1.0,
        _color = color ?? kDefaultColor,
        _opacity = opacity ?? 1.0;

  final double size;
  final double _aspectRatio;
  final double _opacity;
  final Color _color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size * _aspectRatio, size),
      painter: GlitterPainter(
        squareSize: size,
        offset: Offset.zero,
        aspectRatio: _aspectRatio,
        color: _color,
        opacity: _opacity,
      ),
    );
  }
}
