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

class _GlittersState extends State<Glitters>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Key _key;
  late double _size;
  late double _randX;
  late double _randY;

  late double _minSize;
  late double _maxSize;
  late Duration _duration;
  late Duration _inDuration;
  late Duration _outDuration;
  late Duration _interval;
  late Color _color;
  late double _maxOpacity;

  Duration get _totalDuration =>
      _duration + _inDuration + _outDuration + _interval;

  @override
  void initState() {
    super.initState();

    _initializeParams();

    _controller = AnimationController(vsync: this, duration: _totalDuration)
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _renew();
          _controller.forward(from: 0.0);
        }
      });

    Future<void>.delayed(widget.delay, () {
      _renew();
      _controller.forward();
    });
  }

  @override
  void didUpdateWidget(Glitters oldWidget) {
    super.didUpdateWidget(oldWidget);

    final hasChanges = _updateParams();
    print(hasChanges);

    if (hasChanges) {
      _controller
        ..stop()
        ..reset()
        ..duration = _totalDuration;

      Future<void>.delayed(widget.delay, () {
        _renew();
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initializeParams() {
    final stack = context.findAncestorWidgetOfExactType<GlitterStack>();

    _minSize = stack?.minSize ?? widget.minSize ?? kDefaultSize;
    _maxSize = stack?.maxSize ?? widget.maxSize ?? _minSize;
    _duration = stack?.duration ?? widget.duration ?? kDefaultDuration;
    _inDuration = stack?.inDuration ?? widget.inDuration ?? kDefaultInDuration;
    _outDuration =
        stack?.outDuration ?? widget.outDuration ?? kDefaultOutDuration;
    _interval = stack?.interval ?? widget.interval ?? kDefaultInterval;
    _color = stack?.color ?? widget.color ?? kDefaultColor;
    _maxOpacity = stack?.maxOpacity ?? widget.maxOpacity ?? 1.0;
  }

  bool _updateParams() {
    final minSize = _minSize;
    final maxSize = _maxSize;
    final duration = _duration;
    final inDuration = _inDuration;
    final outDuration = _outDuration;
    final interval = _interval;
    final color = _color;
    final maxOpacity = _maxOpacity;

    _initializeParams();

    return _minSize != minSize ||
        _maxSize != maxSize ||
        _duration != duration ||
        _inDuration != inDuration ||
        _outDuration != outDuration ||
        _interval != interval ||
        _color != color ||
        _maxOpacity != maxOpacity;
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.isAnimating) {
      return const SizedBox.expand();
    }

    return LayoutBuilder(builder: (_, constraints) {
      final width = calculateWidth(_size, _size, kDefaultAspectRatio);
      final height = calculateWidth(_size, _size, kDefaultAspectRatio);

      return _Paint(
        key: _key,
        constraints: constraints,
        size: _size,
        offset: Offset(
          _randX * (constraints.maxWidth - width),
          _randY * (constraints.maxHeight - height),
        ),
        duration: _duration,
        inDuration: _inDuration,
        outDuration: _outDuration,
        color: _color,
        maxOpacity: _maxOpacity,
      );
    });
  }

  void _renew() {
    setState(() {
      _key = UniqueKey();
      _size = Random().nextDouble() * (_maxSize - _minSize) + _minSize;
      _randX = Random().nextDouble();
      _randY = Random().nextDouble();
    });
  }
}

class _Paint extends StatefulWidget {
  const _Paint({
    Key? key,
    required this.constraints,
    required this.size,
    required this.offset,
    required this.duration,
    required this.inDuration,
    required this.outDuration,
    required this.color,
    required this.maxOpacity,
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
  late final AnimationController _controller;
  late final Animation<double> _opacity;

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
          width: widget.size,
          height: widget.size,
          offset: widget.offset,
          aspectRatio: kDefaultAspectRatio,
          color: widget.color,
          opacity: _opacity.value,
        ),
      ),
    );
  }
}
