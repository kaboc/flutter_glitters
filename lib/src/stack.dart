import 'package:flutter/widgets.dart';

/// A widget that shows multiple [Glitters].
///
/// You can overlap other widgets using this in the same way as is
/// possible with [Stack].
class GlitterStack extends StatelessWidget {
  /// Creates a widget that shows multiple [Glitters].
  ///
  /// This widget and [Glitters] have some parameters in common.
  /// If different values are passed to parameters with the same name
  /// of both widgets, the one in [Glitters] is used.
  ///
  /// You can set common settings for multiple [Glitters] widgets set
  /// as children.
  const GlitterStack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.children = const <Widget>[],
    this.width,
    this.height,
    this.backgroundColor = const Color(0x00000000),
    this.minSize,
    this.maxSize,
    this.duration,
    this.inDuration,
    this.outDuration,
    this.interval,
    this.color,
    this.maxOpacity,
  })  : assert(minSize == null ||
            minSize > 0.0 && (maxSize == null || maxSize >= minSize)),
        assert(maxSize == null ||
            maxSize > 0.0 && (minSize == null || minSize <= maxSize)),
        assert(maxOpacity == null || maxOpacity > 0.0 && maxOpacity <= 1.0),
        super(key: key);

  /// How to align the non-positioned and partially-positioned children
  /// in the stack.
  final AlignmentGeometry alignment;

  /// The text direction with which to resolve [alignment].
  final TextDirection? textDirection;

  /// How to size the non-positioned children in the stack.
  final StackFit fit;

  /// The content will be clipped (or not) according to this option.
  final Clip clipBehavior;

  /// The widgets below this widget in the tree.
  final List<Widget> children;

  /// The width of the area in which a glitter is shown.
  final double? width;

  /// The height of the area in which a glitter is shown.
  final double? height;

  /// The background color of the area in which a glitter is shown.
  ///
  /// Glitters look better in a dark background color.
  final Color backgroundColor;

  /// The minimum size of a glitter shown inside the widget.
  final double? minSize;

  /// The maximum size of a glitter shown inside the widget.
  final double? maxSize;

  /// The duration in which a glitter is shown with the maximum opacity.
  /// This does not include the durations of fade-in/out and the interval
  /// between glitters.
  final Duration? duration;

  /// The duration over which a glitter fades in.
  final Duration? inDuration;

  /// The duration over which a glitter fades out.
  final Duration? outDuration;

  /// The duration of the wait between a glitter and the next.
  final Duration? interval;

  /// The main color of glitters.
  final Color? color;

  /// The maximum opacity that a glitter fades in up to and out from.
  final double? maxOpacity;

  @override
  Widget build(BuildContext context) {
    // Writing this in the initializer list causes an error
    // regardless of the duration value for some unknown reason.
    assert(duration == null || duration != Duration.zero);

    return SizedBox(
      width: width,
      height: height,
      child: ColoredBox(
        color: backgroundColor,
        child: Stack(
          alignment: alignment,
          textDirection: textDirection,
          fit: fit,
          clipBehavior: clipBehavior,
          children: children,
        ),
      ),
    );
  }
}
