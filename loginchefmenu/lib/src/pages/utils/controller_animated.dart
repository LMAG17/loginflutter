import 'package:flutter/widgets.dart';

enum Playback {
  PAUSE,
  PLAY_FORWARD,
  PLAY_REVERSE,
  START_OVER_FORWARD,
  START_OVER_REVERSE,
  LOOP,
  MIRROR
}

class ControlledAnimation<T> extends StatefulWidget {
  final Playback playback;
  final Animatable<T> tween;
  final Curve curve;
  final Duration duration;
  final Duration delay;
  final Widget Function(BuildContext buildContext, T animatedValue) builder;
  final Widget Function(BuildContext, Widget child, T animatedValue)
      builderWithChild;
  final Widget child;
  final AnimationStatusListener animationControllerStatusListener;
  final double startPosition;

  ControlledAnimation(
      {this.playback = Playback.PLAY_FORWARD,
      this.tween,
      this.curve = Curves.linear,
      this.duration,
      this.delay,
      this.builder,
      this.builderWithChild,
      this.child,
      this.animationControllerStatusListener,
      this.startPosition = 0.0,
      Key key}):
        super(key: key);

  @override
  _ControlledAnimationState<T> createState() => _ControlledAnimationState<T>();
}

class _ControlledAnimationState<T> extends State<ControlledAnimation<T>>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<T> _animation;
  bool _isDisposed = false;
  bool _waitForDelay = true;
  bool _isCurrentlyMirroring = false;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..addListener(() {
        setState(() {});
      })
      ..value = widget.startPosition;

    _animation = widget.tween
        .chain(CurveTween(curve: widget.curve))
        .animate(_controller);

    if (widget.animationControllerStatusListener != null) {
      _controller.addStatusListener(widget.animationControllerStatusListener);
    }

    initialize();
    super.initState();
  }

  void initialize() async {
    if (widget.delay != null) {
      await Future.delayed(widget.delay);
    }
    _waitForDelay = false;
    executeInstruction();
  }

  @override
  void didUpdateWidget(ControlledAnimation<T> oldWidget) {
    _controller.duration = widget.duration;
    executeInstruction();
    super.didUpdateWidget(oldWidget);
  }

  void executeInstruction() async {
    if (_isDisposed || _waitForDelay) {
      return;
    }

    if (widget.playback == Playback.PAUSE) {
      _controller.stop();
    }
    if (widget.playback == Playback.PLAY_FORWARD) {
      _controller.forward();
    }
    if (widget.playback == Playback.PLAY_REVERSE) {
      _controller.reverse();
    }
    if (widget.playback == Playback.START_OVER_FORWARD) {
      _controller.forward(from: 0.0);
    }
    if (widget.playback == Playback.START_OVER_REVERSE) {
      _controller.reverse(from: 1.0);
    }
    if (widget.playback == Playback.LOOP) {
      _controller.repeat();
    }
    if (widget.playback == Playback.MIRROR && !_isCurrentlyMirroring) {
      _isCurrentlyMirroring = true;
      _controller.repeat(reverse: true);
    }

    if (widget.playback != Playback.MIRROR) {
      _isCurrentlyMirroring = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) {
      return widget.builder(context, _animation.value);
    } else if (widget.builderWithChild != null && widget.child != null) {
      return widget.builderWithChild(context, widget.child, _animation.value);
    }
    return Container();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    super.dispose();
  }
}