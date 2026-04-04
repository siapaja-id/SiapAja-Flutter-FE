import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/task_icons.dart';
import '../../../shared/widgets/ring_animation.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/gig.dart';

class MatchSuccessSheet extends StatefulWidget {
  final Gig gig;
  final bool isQueued;
  final VoidCallback onContinue;
  final VoidCallback onClose;

  const MatchSuccessSheet({
    super.key,
    required this.gig,
    required this.isQueued,
    required this.onContinue,
    required this.onClose,
  });

  @override
  State<MatchSuccessSheet> createState() => _MatchSuccessSheetState();
}

class _MatchSuccessSheetState extends State<MatchSuccessSheet>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _yAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _opacityAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.curveOutQuart));
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.curveOut));
    _yAnim = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.curveOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchMap() {
    debugPrint(
      'Navigate to: https://maps.google.com/?q=${widget.gig.distance}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = min(screenWidth, 420.0);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnim.value,
          child: Container(
            color: const Color(0xFF09090B),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 0.6,
                        colors: [
                          const Color(0xFF10B981).withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: FloatingParticles(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        decoration: BoxDecoration(
                          border: Border.symmetric(
                            vertical: BorderSide(
                              color: Colors.white.w05,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            SizedBox(
                              width: 128,
                              height: 128,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ..._buildRadarRings(),
                                  Transform.scale(
                                    scale: _scaleAnim.value,
                                    child: Container(
                                      width: 96,
                                      height: 96,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFF34D399),
                                            Color(0xFF059669),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(48),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF10B981,
                                            ).withOpacity(0.5),
                                            blurRadius: 80,
                                          ),
                                        ],
                                      ),
                                      child: Icon(
                                        widget.isQueued
                                            ? PhosphorIconsRegular.listDashes
                                            : PhosphorIconsRegular.check,
                                        size: 48,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Transform.translate(
                              offset: Offset(0, _yAnim.value),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppTheme.scaled(
                                    multiplier: AppTheme.m3xl,
                                    weight: FontWeight.w900,
                                    letterSpacing: -1,
                                  ),
                                  children: widget.isQueued
                                      ? [
                                          const TextSpan(
                                            text: 'UP ',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: 'NEXT!',
                                            style: TextStyle(
                                              color: Color(0xFF34D399),
                                            ),
                                          ),
                                        ]
                                      : [
                                          const TextSpan(
                                            text: "IT'S A ",
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const TextSpan(
                                            text: 'MATCH!',
                                            style: TextStyle(
                                              color: Color(0xFF34D399),
                                            ),
                                          ),
                                        ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Transform.translate(
                              offset: Offset(0, _yAnim.value),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    PhosphorIconsRegular.sparkle,
                                    size: 18,
                                    color: Color(0xFF34D399),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    widget.isQueued
                                        ? 'Added to your Estafet queue.'
                                        : "You've secured this project.",
                                    style: AppTheme.scaled(
                                      multiplier: AppTheme.mbase,
                                      weight: FontWeight.w500,
                                      color: Colors.white.w60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            Transform.translate(
                              offset: Offset(0, _yAnim.value),
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white.w03,
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: Colors.white.w10,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 1,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              const Color(
                                                0xFF34D399,
                                              ).withOpacity(0.5),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 48,
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: Colors.white.w10,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Icon(
                                                getIconForTaskType(
                                                  widget.gig.iconType,
                                                ),
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                            ),
                                            Text(
                                              widget.gig.price,
                                              style: AppTheme.scaled(
                                                multiplier: AppTheme.m2xl,
                                                weight: FontWeight.w900,
                                                color: const Color(0xFF34D399),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          widget.gig.title,
                                          style: AppTheme.scaled(
                                            multiplier: AppTheme.mxl,
                                            weight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            const Icon(
                                              PhosphorIconsRegular.clock,
                                              size: 14,
                                              color: Color(0xFF34D399),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.gig.time,
                                              style: AppTheme.scaled(
                                                multiplier: AppTheme.m13,
                                                weight: FontWeight.w700,
                                                color: Colors.white.w50,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: Colors.white.w20,
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            const Icon(
                                              PhosphorIconsRegular.globe,
                                              size: 14,
                                              color: Color(0xFF34D399),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              widget.gig.distance,
                                              style: AppTheme.scaled(
                                                multiplier: AppTheme.m13,
                                                weight: FontWeight.w700,
                                                color: Colors.white.w50,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Spacer(),
                            Transform.translate(
                              offset: Offset(0, _yAnim.value),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: _launchMap,
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981),
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xFF10B981,
                                            ).withOpacity(0.3),
                                            blurRadius: 40,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            PhosphorIconsRegular
                                                .navigationArrow,
                                            size: 18,
                                            color: Colors.black,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Navigate via Google Maps',
                                            style: AppTheme.scaled(
                                              multiplier: AppTheme.mbase,
                                              weight: FontWeight.w700,
                                              color: Colors.black,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(
                                            PhosphorIconsRegular.arrowSquareOut,
                                            size: 14,
                                            color: Colors.black.black50,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.w05,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.w10,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            PhosphorIconsRegular.chatCircle,
                                            size: 18,
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Message ${widget.gig.clientName}',
                                            style: AppTheme.scaled(
                                              multiplier: AppTheme.mbase,
                                              weight: FontWeight.w700,
                                              color: Colors.white,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: widget.onContinue,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.white.w10,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Keep Swiping',
                                                style: AppTheme.scaled(
                                                  multiplier: AppTheme.mbase,
                                                  weight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: widget.onClose,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: Colors.white.w10,
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                'Dashboard',
                                                style: AppTheme.scaled(
                                                  multiplier: AppTheme.mbase,
                                                  weight: FontWeight.w700,
                                                  color: Colors.white,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildRadarRings() {
    return List.generate(3, (i) => PulsingRing(
      delay: i * 800,
      duration: const Duration(milliseconds: 2500),
      beginScale: 0.8,
      beginOpacity: 0.3,
      color: const Color(0xFF34D399).withOpacity(0.5),
      borderWidth: 1,
      borderRadius: 64,
    ));
  }
}
