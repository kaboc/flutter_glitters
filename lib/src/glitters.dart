import 'dart:math';
import 'package:flutter/widgets.dart';

import 'consts.dart';
import 'painter.dart';

/// A widget that fades in and out glitter-like shapes one by one inside itself.
///
/// The size of the widget itself is calculated using the constraints obtained
/// by [LayoutBuilder], and glitters are randomly positioned within the area.
/// An error will occur if the widget is unconstrained.
///
/// Only a single glitter is shown at a time. Stack multiple glitters to display
/// them concurrently.
class Glitters extends StatefulWidget {
  /// Creates a widget that fades in and out glitter-like shapes one by one.
  ///
  /// Each glitter is sized between [minSize] and [maxSize] for every animation
  /// and shown with the [color].
  /// It fades in and reaches [maxOpacity] over the duration of [inDuration],
  /// stays for the span of [duration], and then fades out over [outDuration].
  /// The next animation begins after a wait of [interval] duration.
  const Glitters({
    Key key,
    double minSize,
    double maxSize,
    Duration duration,
    Duration inDuration,
    Duration outDuration,
    Duration interval,
    Color color,
    double maxOpacity,
  })  : assert(minSize == null ||
            (minSize > 0.0 && (maxSize == null || maxSize >= minSize))),
        assert(maxSize == null ||
            (maxSize > 0.0 && (minSize == null || minSize <= maxSize))),
        assert(maxOpacity == null || (maxOpacity > 0.0 && maxOpacity <= 1.0)),
        minSize = minSize ?? kDefaultSize,
        maxSize = maxSize ?? (minSize ?? kDefaultSize),
        duration = duration ?? kDefaultDuration,
        inDuration = inDuration ?? kDefaultInDuration,
        outDuration = outDuration ?? kDefaultOutDuration,
        interval = interval ?? kDefaultInterval,
        color = color ?? kDefaultColor,
        maxOpacity = maxOpacity ?? 1.0,
        super(key: key);

  /// The minimum size of a glitter shown inside the widget.
  final double minSize;

  /// The maximum size of a glitter shown inside the widget.
  final double maxSize;

  /// The duration in which a glitter is shown with the maximum opacity.
  /// This does not include the durations of fade-in/out and the interval
  /// between glitters.
  final Duration duration;

  /// The duration over which a glitter fades in.
  final Duration inDuration;

  /// The duration over which a glitter fades out.
  final Duration outDuration;

  /// The duration of a wait between each glitter and the next.
  final Duration interval;

  /// The main color of glitters.
  final Color color;

  /// The maximum opacity that glitters fade in up to and out from.
  final double maxOpacity;

  @override
  _GlittersState createState() => _GlittersState();
}

class _GlittersState extends State<Glitters>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _size;
  Key _key;

  Duration get _duration =>
      widget.duration +
      widget.inDuration +
      widget.outDuration +
      widget.interval;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _duration)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _renew();
          _controller.forward(from: 0.0);
        }
      })
      ..forward();

    _renew();
  }

  @override
  void didUpdateWidget(Glitters oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration ||
        widget.inDuration != oldWidget.inDuration ||
        widget.outDuration != oldWidget.outDuration ||
        widget.interval != oldWidget.interval) {
      _controller
        ..stop()
        ..duration = _duration
        ..forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      final width = _size * kDefaultAspectRatio;
      final height = _size;

      return _Paint(
        key: _key,
        constraints: constraints,
        size: _size,
        offset: Offset(
          Random().nextDouble() * (constraints.maxWidth - width),
          Random().nextDouble() * (constraints.maxHeight - height),
        ),
        duration: widget.duration,
        inDuration: widget.inDuration,
        outDuration: widget.outDuration,
        color: widget.color,
        maxOpacity: widget.maxOpacity,
      );
    });
  }

  void _renew() {
    setState(() {
      _key = UniqueKey();
      _size = Random().nextDouble() * (widget.maxSize - widget.minSize) +
          widget.minSize;
    });
  }
}

class _Paint extends StatefulWidget {
  const _Paint({
    Key key,
    @required this.constraints,
    @required this.size,
    @required this.offset,
    this.duration,
    this.inDuration,
    this.outDuration,
    this.color,
    this.maxOpacity,
  }) : super(key: key);

  final BoxConstraints constraints;
  final double size;
  final Offset offset;
  final Duration duration;
  final Duration inDuration;
  final Duration outDuration;
  final Color color;
  final double maxOpacity;

  @override
  _PaintState createState() => _PaintState();
}

class _PaintState extends State<_Paint> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    final duration = widget.duration + widget.inDuration + widget.outDuration;

    _controller = AnimationController(vsync: this, duration: duration)
      ..forward();

    _opacity = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: widget.maxOpacity),
        weight: widget.inDuration.inMilliseconds / duration.inMilliseconds,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: widget.maxOpacity, end: widget.maxOpacity),
        weight: widget.duration.inMilliseconds / duration.inMilliseconds,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: widget.maxOpacity, end: 0.0),
        weight: widget.outDuration.inMilliseconds / duration.inMilliseconds,
      ),
    ]).animate(_controller);
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
      builder: (_, __) => CustomPaint(
        size: Size(widget.constraints.maxWidth, widget.constraints.maxHeight),
        painter: GlitterPainter(
          maxWidth: widget.size,
          maxHeight: widget.size,
          offset: widget.offset,
          aspectRatio: kDefaultAspectRatio,
          color: widget.color,
          opacity: _opacity.value,
        ),
      ),
    );
  }
}
