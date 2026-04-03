import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../app_theme.dart';
import '../../../models/gig.dart';
import '../../../shared/utils/task_icons.dart';

class GigCard extends StatefulWidget {
  final Gig gig;
  final void Function(String) onSwipe;
  final bool isTop;
  final int index;
  final String? swipeDirection;

  const GigCard({
    super.key,
    required this.gig,
    required this.onSwipe,
    required this.isTop,
    required this.index,
    required this.swipeDirection,
  });

  @override
  State<GigCard> createState() => _GigCardState();
}

class _GigCardState extends State<GigCard> with TickerProviderStateMixin {
  Offset _dragOffset = Offset.zero;
  double _nextCardScale = 0.92;
  double _nextCardOpacity = 0.6;
  double _nextCardY = 24;

  late AnimationController _exitController;
  late Animation<double> _exitOpacity;
  late Animation<double> _exitX;
  late Animation<double> _exitY;
  late Animation<double> _exitRotate;

  late AnimationController _enterController;
  late Animation<double> _enterScale;
  late Animation<double> _enterOpacity;
  late Animation<double> _enterY;

  @override
  void initState() {
    super.initState();
    _setupExitAnimations();
    _setupEnterAnimations();
  }

  void _setupExitAnimations() {
    _exitController = AnimationController(
      duration: AppTheme.animSheet,
      vsync: this,
    );
    _exitOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(_exitController);
    _exitX = Tween<double>(begin: 0, end: 0).animate(_exitController);
    _exitY = Tween<double>(begin: 0, end: 0).animate(_exitController);
    _exitRotate = Tween<double>(begin: 0, end: 0).animate(_exitController);
  }

  void _setupEnterAnimations() {
    _enterController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _enterScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _enterController, curve: AppTheme.curveOut),
    );
    _enterOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _enterController, curve: AppTheme.curveOutQuart));
    _enterY = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _enterController, curve: AppTheme.curveOut),
    );
    _enterController.forward();
  }

  @override
  void dispose() {
    _exitController.dispose();
    _enterController.dispose();
    super.dispose();
  }

  void _runExitAnimation(String direction) {
    if (direction == 'up') {
      _exitX = Tween<double>(begin: 0.0, end: 0.0).animate(_exitController);
      _exitY = Tween<double>(
        begin: 0.0,
        end: -500,
      ).animate(CurvedAnimation(parent: _exitController, curve: AppTheme.curveIn));
      _exitRotate = Tween<double>(
        begin: 0.0,
        end: 0.0,
      ).animate(_exitController);
    } else if (direction == 'right') {
      _exitX = Tween<double>(begin: 0.0, end: 400).animate(
        CurvedAnimation(parent: _exitController, curve: AppTheme.curveOut),
      );
      _exitY = Tween<double>(begin: 0.0, end: 50).animate(_exitController);
      _exitRotate = Tween<double>(begin: 0.0, end: 15).animate(_exitController);
    } else if (direction == 'left') {
      _exitX = Tween<double>(begin: 0.0, end: -400).animate(
        CurvedAnimation(parent: _exitController, curve: AppTheme.curveOut),
      );
      _exitY = Tween<double>(begin: 0.0, end: 50).animate(_exitController);
      _exitRotate = Tween<double>(
        begin: 0.0,
        end: -15,
      ).animate(_exitController);
    }
    _exitController.forward().then((_) {
      widget.onSwipe(direction);
    });
  }

  double _applyDragElastic(double value, double maxDrag) {
    if (value.abs() <= maxDrag) {
      return value;
    }
    final overshoot = value.abs() - maxDrag;
    final elasticValue = maxDrag + (overshoot * 0.2);
    return value.isNegative ? -elasticValue : elasticValue;
  }

  @override
  Widget build(BuildContext context) {
    final isNext = widget.index == 1;
    final showExit = widget.swipeDirection != null && widget.isTop;

    if (showExit &&
        !_exitController.isAnimating &&
        !_exitController.isCompleted) {
      _runExitAnimation(widget.swipeDirection!);
    }

    double rotation = 0;
    double opacity = 1.0;
    double scale = 1.0;
    double y = 0;

    if (widget.isTop) {
      final elasticX = _applyDragElastic(_dragOffset.dx, 200);
      final elasticY = _applyDragElastic(_dragOffset.dy, 200);
      rotation = elasticX * 0.05;
      opacity = 1.0;
      scale = 1.0;
      y = elasticY;
    } else if (isNext) {
      scale = _nextCardScale;
      opacity = _nextCardOpacity;
      y = _nextCardY;
    }

    if (showExit) {
      rotation = _exitRotate.value;
      opacity = _exitOpacity.value;
      scale = _enterScale.value;
    }

    double acceptOpacity = widget.isTop
        ? (_dragOffset.dx > 20 ? min(1.0, (_dragOffset.dx - 20) / 80) : 0)
        : 0;
    double passOpacity = widget.isTop
        ? (_dragOffset.dx < -20 ? min(1.0, (-_dragOffset.dx - 20) / 80) : 0)
        : 0;
    double bidOpacity = widget.isTop
        ? (_dragOffset.dy < -20 ? min(1.0, (-_dragOffset.dy - 20) / 80) : 0)
        : 0;

    return AnimatedBuilder(
      animation: _enterController,
      builder: (context, child) {
        return Transform.translate(
          offset: widget.isTop
              ? Offset(
                  _applyDragElastic(_dragOffset.dx, 200) + _exitX.value,
                  _applyDragElastic(_dragOffset.dy, 200) + _exitY.value,
                )
              : Offset(0, _enterController.isAnimating ? _enterY.value : y),
          child: Transform.rotate(
            angle: rotation * (pi / 180),
            child: Transform.scale(
              scale: widget.isTop
                  ? scale
                  : (isNext ? _nextCardScale * _enterScale.value : scale),
              child: Opacity(
                opacity: widget.isTop
                    ? opacity
                    : (_enterController.isAnimating
                          ? _enterOpacity.value
                          : opacity),
                child: GestureDetector(
                  onPanUpdate: isNext
                      ? null
                      : (details) {
                          if (!widget.isTop) return;
                          setState(() {
                            _dragOffset += details.delta;
                            _updateNextCard();
                          });
                        },
                  onPanEnd: isNext
                      ? null
                      : (details) {
                          if (!widget.isTop) return;
                          final velocity = details.velocity.pixelsPerSecond;
                          const threshold = 100.0;
                          const velocityThreshold = 500.0;

                          if (_dragOffset.dy < -threshold ||
                              velocity.dy < -velocityThreshold) {
                            widget.onSwipe('up');
                          } else if (_dragOffset.dx > threshold ||
                              velocity.dx > velocityThreshold) {
                            widget.onSwipe('right');
                          } else if (_dragOffset.dx < -threshold ||
                              velocity.dx < -velocityThreshold) {
                            widget.onSwipe('left');
                          }
                          setState(() {
                            _dragOffset = Offset.zero;
                            _nextCardScale = 0.92;
                            _nextCardOpacity = 0.6;
                            _nextCardY = 24;
                          });
                        },
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: surfaceCardDecor(radius: 32, shadows: [shadowBlack()]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.w03,
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (acceptOpacity > 0)
                            Positioned(
                              top: 40,
                              left: 32,
                              child: Opacity(
                                opacity: acceptOpacity,
                                child: Transform.rotate(
                                  angle: -0.2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xFF10B981),
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black54,
                                    ),
                                    child: Text(
                                      'ACCEPT',
                                      style: AppTheme.scaled(
                                        multiplier: AppTheme.m28,
                                        weight: FontWeight.w900,
                                        letterSpacing: 4,
                                        color: const Color(0xFF10B981),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (passOpacity > 0)
                            Positioned(
                              top: 40,
                              right: 32,
                              child: Opacity(
                                opacity: passOpacity,
                                child: Transform.rotate(
                                  angle: 0.2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.black54,
                                    ),
                                    child: Text(
                                      'PASS',
                                      style: AppTheme.scaled(
                                        multiplier: AppTheme.m28,
                                        weight: FontWeight.w900,
                                        letterSpacing: 4,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (bidOpacity > 0)
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.3,
                              left: 0,
                              right: 0,
                              child: Opacity(
                                opacity: bidOpacity,
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 4,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      color: Colors.black54,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.p50,
                                          blurRadius: 50,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          PhosphorIconsRegular.arrowUp,
                                          size: 48,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'BID',
                                          style: AppTheme.scaled(
                                            multiplier: AppTheme.m3xl,
                                            weight: FontWeight.w900,
                                            letterSpacing: 4,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: Colors.white.w05,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.w10,
                                        ),
                                      ),
                                      child: Icon(
                                        getIconForTaskType(widget.gig.iconType),
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          widget.gig.price,
                                          style: AppTheme.scaled(
                                            multiplier: AppTheme.m28,
                                            weight: FontWeight.w900,
                                            color: Colors.white,
                                          ),
                                        ),
                                        if (widget.gig.meta != null)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary.p20,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              widget.gig.meta!,
                                              style: AppTheme.scaled(
                                                multiplier: AppTheme.m2sm,
                                                weight: FontWeight.w900,
                                                letterSpacing: 2,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Text(
                                      '${widget.gig.type.name.toUpperCase()} REQUEST',
                                      style: AppTheme.scaled(
                                        multiplier: AppTheme.m2sm,
                                        weight: FontWeight.w900,
                                        letterSpacing: 2,
                                        color: Colors.white.w50,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.w20,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Row(
                                      children: [
                                        Icon(
                                          PhosphorIconsRegular.shieldCheck,
                                          size: 12,
                                          color: Color(0xFF10B981),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          widget.gig.clientName,
                                          style: AppTheme.scaled(
                                            multiplier: AppTheme.m2sm,
                                            weight: FontWeight.w700,
                                            color: Colors.white.w50,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  widget.gig.title,
                                  style: AppTheme.scaled(
                                    multiplier: AppTheme.m2xl,
                                    weight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoBlock(
                                        icon: PhosphorIconsRegular.mapPin,
                                        label: 'Location',
                                        value: widget.gig.distance,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildInfoBlock(
                                        icon: PhosphorIconsRegular.clock,
                                        label: 'Timeline',
                                        value: widget.gig.time,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'PROJECT BRIEF',
                                  style: AppTheme.scaled(
                                    multiplier: AppTheme.m2xs,
                                    weight: FontWeight.w900,
                                    letterSpacing: 2,
                                    color: Colors.white.w40,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.gig.description,
                                  style: AppTheme.scaled(
                                    multiplier: AppTheme.mbase,
                                    weight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Spacer(),
                                const SizedBox(height: 16),
                                Container(
                                  height: 1,
                                  color: Colors.white.w05,
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildActionButton(
                                      icon: PhosphorIconsRegular.x,
                                      color: Colors.white.w50,
                                      onTap: () => widget.onSwipe('left'),
                                    ),
                                    _buildBidButton(),
                                    _buildActionButton(
                                      icon: PhosphorIconsRegular.check,
                                      color: const Color(0xFF10B981),
                                      onTap: () => widget.onSwipe('right'),
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
            ),
          ),
        );
      },
    );
  }

  void _updateNextCard() {
    final dragProgress = min(1.0, _dragOffset.dx.abs() / 200);
    _nextCardScale = 0.92 + (0.08 * dragProgress);
    _nextCardOpacity = 0.6 + (0.4 * dragProgress);
    _nextCardY = 24 - (24 * dragProgress);
  }

  Widget _buildInfoBlock({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.w03,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.w05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.white.w40),
              const SizedBox(width: 4),
              Text(
                label.toUpperCase(),
                style: AppTheme.scaled(
                  multiplier: AppTheme.m2xs,
                  weight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white.w40,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTheme.scaled(
              multiplier: AppTheme.m13,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white.w05,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.w10),
        ),
        child: Icon(icon, size: 24, color: color),
      ),
    );
  }

  Widget _buildBidButton() {
    return GestureDetector(
      onTap: () => widget.onSwipe('up'),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primary.p20,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.p50),
          boxShadow: [
            shadowGlow(color: AppColors.primary),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              PhosphorIconsRegular.arrowUp,
              size: 16,
              color: AppColors.primary,
            ),
            Text(
              'BID',
              style: AppTheme.scaled(
                multiplier: AppTheme.mxs,
                weight: FontWeight.w900,
                letterSpacing: 1,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
