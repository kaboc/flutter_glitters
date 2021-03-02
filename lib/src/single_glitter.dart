import 'package:flutter/widgets.dart';

import 'consts.dart';
import 'painter.dart';

/// A widget that draws a single static glitter-like shape.
///
/// This widget may be useful when [Glitters] does not meet your needs
/// and you want to instead use only the glitter shape differently for
/// your own usage.
class SingleGlitter extends StatelessWidget {
  /// Creates a widget that draws a single static glitter-like shape.
  ///
  /// A single glitter with the [color] is displayed at the [aspectRatio]
  /// to fit the [width] and [height].
  /// Unlike [Glitters], this has the fixed [opacity] and does not animate.
  const SingleGlitter({
    Key key,
    this.maxWidth,
    this.maxHeight,
    double aspectRatio,
    Color color,
    double opacity,
  })  : assert(maxWidth == null || maxWidth > 0.0),
        assert(maxHeight == null || maxHeight > 0.0),
        assert(aspectRatio == null || aspectRatio > 0.0),
        assert(opacity == null || (opacity > 0.0 && opacity <= 1.0)),
        aspectRatio = aspectRatio ?? 1.0,
        color = color ?? kDefaultColor,
        opacity = opacity ?? 1.0,
        super(key: key);

  /// The max width of the widget.
  ///
  /// The widget is automatically sized to fit the available width if
  /// this is omitted, in which case an error occurs if the widget is
  /// unconstrained.
  ///
  /// The actual width of the widget may become smaller depending on
  /// the [height] and the [aspectRatio].
  final double maxWidth;

  /// The max height of the widget.
  ///
  /// The widget is automatically sized to fit the available height if
  /// this is omitted, in which case an error occurs if the widget is
  /// unconstrained.
  ///
  /// The actual height of the widget may become smaller depending on
  /// the [width] and the [aspectRatio].
  final double maxHeight;

  /// The aspect ratio (a ratio of width to height) of the widget.
  final double aspectRatio;

  /// The opacity of the main parts of the widget.
  final double opacity;

  /// The main color of the widget.
  final Color color;

  @override
  Widget build(BuildContext context) {
    return maxWidth == null || maxHeight == null
        ? LayoutBuilder(
            builder: (context, constraints) {
              return _paint(
                maxWidth ?? constraints.maxWidth,
                maxHeight ?? constraints.maxHeight,
              );
            },
          )
        : _paint(maxWidth, maxHeight);
  }

  Widget _paint(double maxWidth, double maxHeight) {
    final width = calculateWidth(maxWidth, maxHeight, aspectRatio);
    final height = calculateHeight(maxWidth, maxHeight, aspectRatio);

    return UnconstrainedBox(
      child: CustomPaint(
        size: Size(width, height),
        painter: GlitterPainter(
          width: width,
          height: height,
          offset: Offset.zero,
          aspectRatio: aspectRatio,
          color: color,
          opacity: opacity,
        ),
      ),
    );
  }
}
