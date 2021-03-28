import 'dart:math';
import 'package:flutter/widgets.dart';

import 'consts.dart';
import 'painter.dart';
import 'stack.dart';

/// A widget that fades in and out glitter-like shapes one by one inside itself.
///
/// The size of the widget itself is calculated using the constraints obtained
/// by [LayoutBuilder], and glitters are randomly positioned within the area.
/// An error occurs if the widget is unconstrained.
///
/// Only a single glitter is shown at a time. Stack multiple glitters with
/// [GlitterStack] to display them concurrently.
class Glitters extends StatefulWidget {
  /// Creates a widget that fades in and out glitter-like shapes one by one.
  ///
  /// Each glitter is sized between [minSize] and [maxSize] for every animation
  /// and shown with the [color].
  /// It fades in and reaches [maxOpacity] over the duration of [inDuration],
  /// stays for the span of [duration], and then fades out over [outDuration].
  /// The next animation begins after a wait of [interval] duration.
  /// The start of animation can be delayed with [delay].
  ///
  /// You can set common settings for multiple [Glitters] widgets using the
  /// parameters with the same name in [GlitterStack] as the ones in this
  /// widget.
  ///
  /// This widget looks better in a dark background color.
  const Glitters({
    Key? key,
    this.minSize,
    this.maxSize,
    this.duration,
    this.inDuration,
    this.outDuration,
    this.interval,
    this.delay = Duration.zero,
    this.color,
    this.maxOpacity,
  })  : assert(minSize == null ||
            minSize > 0.0 && (maxSize == null || maxSize >= minSize)),
        assert(maxSize == null ||
            maxSize > 0.0 && (minSize == null || minSize <= maxSize)),
        assert(maxOpacity == null || maxOpacity > 0.0 && maxOpacity <= 1.0),
        super(key: key);

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

  /// The duration of the wait before animation starts.
  final Duration delay;

  /// The main color of glitters.
  final Color? color;

  /// The maximum opacity that a glitter fades in up to and out from.
  final double? maxOpacity;

  @override
  _GlittersState createState() => _GlittersState();
}

class _GlittersState extends State<Glitters> {
  late double _minSize;
  late double _maxSize;
  late Duration _duration;
  late Duration _inDuration;
  late Duration _outDuration;
  late Duration _interval;
  late Color _color;
  late double _maxOpacity;

  @override
  void initState() {
    super.initState();
    _initializeParams();
  }

  @override
  void didUpdateWidget(Glitters oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeParams();
  }

  void _initializeParams() {
    final stack = context.findAncestorWidgetOfExactType<GlitterStack>();

    _minSize = widget.minSize ?? stack?.minSize ?? kDefaultSize;
    _maxSize = widget.maxSize ?? stack?.maxSize ?? _minSize;
    _duration = widget.duration ?? stack?.duration ?? kDefaultDuration;
    _inDuration = widget.inDuration ?? stack?.inDuration ?? kDefaultInDuration;
    _outDuration =
        widget.outDuration ?? stack?.outDuration ?? kDefaultOutDuration;
    _interval = widget.interval ?? stack?.interval ?? kDefaultInterval;
    _color = widget.color ?? stack?.color ?? kDefaultColor;
    _maxOpacity = widget.maxOpacity ?? stack?.maxOpacity ?? 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      return _Paint(
        constraints: constraints,
        minSize: _minSize,
        maxSize: _maxSize,
        duration: _duration,
        inDuration: _inDuration,
        outDuration: _outDuration,
        interval: _interval,
        delay: widget.delay,
        color: _color,
        maxOpacity: _maxOpacity,
      );
    });
  }
}

class _Paint extends StatefulWidget {
  const _Paint({
    required this.constraints,
    required this.minSize,
    required this.maxSize,
    required this.duration,
    required this.inDuration,
    required this.outDuration,
    required this.interval,
    required this.delay,
    required this.color,
    required this.maxOpacity,
  });

  final BoxConstraints constraints;
  final double minSize;
  final double maxSize;
  final Duration duration;
  final Duration inDuration;
  final Duration outDuration;
  final Duration interval;
  final Duration delay;
  final Color color;
  final double maxOpacity;

  @override
  _PaintState createState() => _PaintState();
}

class _PaintState extends State<_Paint> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  late double _size;
  late Offset _offset;

  Duration get _totalDuration =>
      widget.duration +
      widget.inDuration +
      widget.outDuration +
      widget.interval;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: _totalDuration)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _updateGlitter();
          _controller.forward(from: 0.0);
        }
      });

    Future<void>.delayed(widget.delay, () {
      _updateGlitter();
      _controller.forward();
    });

    _opacity = TweenSequence<double>(<TweenSequenceItem<double>>[
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: widget.maxOpacity),
        weight:
            widget.inDuration.inMilliseconds / _totalDuration.inMilliseconds,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: widget.maxOpacity, end: widget.maxOpacity),
        weight: widget.duration.inMilliseconds / _totalDuration.inMilliseconds,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: widget.maxOpacity, end: 0.0),
        weight:
            widget.outDuration.inMilliseconds / _totalDuration.inMilliseconds,
      ),
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: 0.0, end: 0.0),
        weight: widget.interval.inMilliseconds / _totalDuration.inMilliseconds,
      ),
    ]).animate(_controller);
  }

  @override
  void didUpdateWidget(_Paint oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasChanges = widget.duration != oldWidget.duration ||
        widget.inDuration != oldWidget.inDuration ||
        widget.outDuration != oldWidget.outDuration ||
        widget.interval != oldWidget.interval ||
        widget.delay != oldWidget.delay;

    if (hasChanges) {
      _controller
        ..stop()
        ..reset()
        ..duration = _totalDuration;

      Future<void>.delayed(widget.delay, () {
        _updateGlitter();
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating) {
      return const SizedBox.expand();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) => CustomPaint(
        size: Size(widget.constraints.maxWidth, widget.constraints.maxHeight),
        painter: GlitterPainter(
          width: _size,
          height: _size,
          offset: _offset,
          aspectRatio: 1.0,
          color: widget.color,
          opacity: _opacity.value,
        ),
      ),
    );
  }

  void _updateGlitter() {
    setState(() {
      _size = Random().nextDouble() * (widget.maxSize - widget.minSize) +
          widget.minSize;
      _offset = Offset(
        Random().nextDouble() * (widget.constraints.maxWidth - _size),
        Random().nextDouble() * (widget.constraints.maxHeight - _size),
      );
    });
  }
}
