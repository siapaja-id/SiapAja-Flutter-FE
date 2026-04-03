import 'dart:math';

import 'package:flutter/material.dart';

/// A pulsing ring animation, extracted from radar_page.dart.
///
/// Consolidates `_RadarRingAnimation` and `_MatchRadarRing` into a single
/// configurable widget with sensible defaults.
class PulsingRing extends StatefulWidget {
  final int delay;
  final Duration duration;
  final double beginScale;
  final double endScale;
  final double beginOpacity;
  final double endOpacity;
  final Color color;
  final double borderWidth;
  final double borderRadius;

  const PulsingRing({
    super.key,
    this.delay = 0,
    this.duration = const Duration(milliseconds: 2000),
    this.beginScale = 1.0,
    this.endScale = 2.5,
    this.beginOpacity = 0.5,
    this.endOpacity = 0.0,
    required this.color,
    this.borderWidth = 2,
    this.borderRadius = 96,
  });

  @override
  State<PulsingRing> createState() => _PulsingRingState();
}

class _PulsingRingState extends State<PulsingRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: widget.beginOpacity,
      end: widget.endOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat();
      }
    });
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
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.color,
                  width: widget.borderWidth,
                ),
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Floating particle animation, extracted from radar_page.dart.
///
/// Renders a stack of small colored dots that float upward with
/// fade-in/fade-out opacity and rotation.
class FloatingParticles extends StatefulWidget {
  final Color color;
  final int count;
  final double areaWidth;

  const FloatingParticles({
    super.key,
    required this.color,
    this.count = 30,
    this.areaWidth = 400,
  });

  @override
  State<FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<FloatingParticles> {
  final Random _random = Random();
  final List<_ParticleData> _particles = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.count; i++) {
      _particles.add(
        _ParticleData(
          x: _random.nextDouble() * widget.areaWidth,
          delay: _random.nextDouble() * 2,
          duration: _random.nextDouble() * 3 + 2,
          rotation: _random.nextDouble() * 360,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: _particles
          .map((p) => _Particle(
                key: ValueKey(p.x),
                data: p,
                color: widget.color,
              ))
          .toList(),
    );
  }
}

class _ParticleData {
  final double x;
  final double delay;
  final double duration;
  final double rotation;

  _ParticleData({
    required this.x,
    required this.delay,
    required this.duration,
    required this.rotation,
  });
}

class _Particle extends StatefulWidget {
  final _ParticleData data;
  final Color color;

  const _Particle({super.key, required this.data, required this.color});

  @override
  State<_Particle> createState() => _ParticleState();
}

class _ParticleState extends State<_Particle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _yAnim;
  late Animation<double> _opacityAnim;
  late Animation<double> _rotationAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: (widget.data.duration * 1000).toInt()),
      vsync: this,
    );
    _yAnim = Tween<double>(begin: 800, end: -50).animate(_controller);
    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);
    _rotationAnim = Tween<double>(
      begin: 0,
      end: widget.data.rotation,
    ).animate(_controller);
    Future.delayed(
      Duration(milliseconds: (widget.data.delay * 1000).toInt()),
      () {
        if (mounted) {
          _controller.repeat();
        }
      },
    );
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
      builder: (context, child) {
        return Positioned(
          left: widget.data.x,
          top: _yAnim.value,
          child: Transform.rotate(
            angle: _rotationAnim.value * (pi / 180),
            child: Opacity(
              opacity: _opacityAnim.value,
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
