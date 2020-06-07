import 'dart:math';
import 'package:flutter/widgets.dart';

import 'consts.dart';
import 'painter.dart';

class Glitters extends StatefulWidget {
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
            (minSize > 0.0 && maxSize >= (minSize ?? kDefaultSize))),
        assert(maxSize == null || maxSize > 0.0),
        assert(maxOpacity == null || (maxOpacity > 0.0 && maxOpacity <= 1.0)),
        _minSize = minSize ?? kDefaultSize,
        _maxSize = maxSize ?? kDefaultSize,
        _duration = duration ?? kDefaultDuration,
        _inDuration = inDuration ?? kDefaultInDuration,
        _outDuration = outDuration ?? kDefaultOutDuration,
        _interval = interval ?? kDefaultInterval,
        _color = color ?? kDefaultColor,
        _maxOpacity = maxOpacity ?? 1.0,
        super(key: key);

  final double _minSize;
  final double _maxSize;
  final Duration _duration;
  final Duration _inDuration;
  final Duration _outDuration;
  final Duration _interval;
  final Color _color;
  final double _maxOpacity;

  @override
  _GlittersState createState() => _GlittersState();
}

class _GlittersState extends State<Glitters>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  double _size;
  Key _key;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget._duration +
          widget._inDuration +
          widget._outDuration +
          widget._interval,
    )
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, BoxConstraints constraints) {
      final double width = _size * kDefaultAspectRatio;
      final double height = _size;

      return _Paint(
        key: _key,
        constraints: constraints,
        size: _size,
        offset: Offset(
          Random().nextDouble() * (constraints.maxWidth - width),
          Random().nextDouble() * (constraints.maxHeight - height),
        ),
        duration: widget._duration,
        inDuration: widget._inDuration,
        outDuration: widget._outDuration,
        color: widget._color,
        maxOpacity: widget._maxOpacity,
      );
    });
  }

  void _renew() {
    setState(() {
      _key = UniqueKey();
      _size = Random().nextDouble() * (widget._maxSize - widget._minSize) +
          widget._minSize;
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

    final Duration duration =
        widget.duration + widget.inDuration + widget.outDuration;

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
          squareSize: widget.size,
          offset: widget.offset,
          aspectRatio: kDefaultAspectRatio,
          color: widget.color,
          opacity: _opacity.value,
        ),
      ),
    );
  }
}
