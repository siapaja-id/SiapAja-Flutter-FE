import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../app_theme.dart';
import '../../../models/gig.dart';
import '../../../shared/constants/mock_gigs.dart';
import '../../../shared/settings_provider.dart';
import '../providers.dart';

class RadarPage extends ConsumerStatefulWidget {
  const RadarPage({super.key});

  @override
  ConsumerState<RadarPage> createState() => _RadarPageState();
}

class _RadarPageState extends ConsumerState<RadarPage>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  String? _swipeDirection;
  bool _showMatchedGig = false;
  bool _showBidSheet = false;
  int _bidAmount = 50;
  String _replyText = '';
  Timer? _autoPilotTimer;

  late AnimationController _bidSheetController;
  late Animation<double> _bidSheetY;
  late Animation<double> _bidSheetOpacity;

  @override
  void initState() {
    super.initState();
    _bidSheetController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _bidSheetY = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _bidSheetController, curve: Curves.easeOutCubic),
    );
    _bidSheetOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bidSheetController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _autoPilotTimer?.cancel();
    _bidSheetController.dispose();
    super.dispose();
  }

  void _handleSwipe(String direction) {
    setState(() {
      _swipeDirection = direction;
    });

    final currentGig = _getCurrentGig();
    if (currentGig == null) return;

    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      if (direction == 'up') {
        _bidAmount =
            int.tryParse(currentGig.price.replaceAll(RegExp(r'[^0-9]'), '')) ??
            50;
        setState(() {
          _showBidSheet = true;
        });
        _bidSheetController.forward(from: 0.0);
      } else if (direction == 'right') {
        final uiState = ref.read(uiStateProvider);
        if (uiState.activeGig == null) {
          ref.read(uiStateProvider.notifier).setActiveGig(currentGig);
        } else {
          ref.read(uiStateProvider.notifier).addQueuedGig(currentGig);
        }
        setState(() {
          _showMatchedGig = true;
        });
      } else {
        _advanceNext();
      }
    });
  }

  Gig? _getCurrentGig() {
    if (_currentIndex >= GIGS.length) return null;
    return GIGS[_currentIndex];
  }

  void _advanceNext() {
    if (_showBidSheet) {
      _bidSheetController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _swipeDirection = null;
            _showBidSheet = false;
            if (_currentIndex < GIGS.length - 1) {
              _currentIndex++;
            }
          });
        }
      });
    } else {
      setState(() {
        _swipeDirection = null;
        _showBidSheet = false;
        if (_currentIndex < GIGS.length - 1) {
          _currentIndex++;
        }
      });
    }
  }

  void _handleBidSubmit() {
    _advanceNext();
  }

  void _handleContinue() {
    setState(() {
      _showMatchedGig = false;
    });
    _advanceNext();
  }

  void _handleClose() {
    context.go('/');
  }

  void _toggleAutoPilot(bool value) {
    ref.read(uiStateProvider.notifier).setIsAutoPilot(value);
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(uiStateProvider);
    final activeGig = uiState.activeGig;
    final queuedGigs = uiState.queuedGigs;
    final isAutoPilot = uiState.isAutoPilot;
    final themeColor = ref.watch(settingsProvider.select((s) => s.themeColor));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: AppTheme.backgroundGradient(themeColor),
                ),
              ),
            ),
          ),
          Column(
            children: [
              if (activeGig != null) _buildEstafetBanner(activeGig, queuedGigs),
              _buildHeaderBar(isAutoPilot),
              Expanded(child: _buildContent(isAutoPilot)),
            ],
          ),
          if (_showMatchedGig && _getCurrentGig() != null)
            MatchSuccessSheet(
              gig: _getCurrentGig()!,
              isQueued:
                  activeGig != null && activeGig.id != _getCurrentGig()!.id,
              onContinue: _handleContinue,
              onClose: _handleClose,
            ),
          if (_showBidSheet && _getCurrentGig() != null)
            _buildBidSheetOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeaderBar(bool isAutoPilot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              PhosphorIconsRegular.lightning,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'RADAR',
            style: AppTheme.scaled(
              multiplier: AppTheme.mbase,
              weight: FontWeight.w900,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Row(
              children: [
                Text(
                  'Auto-Pilot',
                  style: AppTheme.scaled(
                    multiplier: AppTheme.mxs,
                    weight: FontWeight.w700,
                    letterSpacing: 1,
                    color: isAutoPilot
                        ? AppColors.primary
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _toggleAutoPilot(!isAutoPilot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isAutoPilot
                          ? AppColors.primary
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isAutoPilot
                            ? AppColors.primary
                            : Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          left: isAutoPilot ? 22 : 2,
                          top: 2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstafetBanner(Gig activeGig, List<Gig> queuedGigs) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0x1A10B981),
        border: const Border(
          bottom: BorderSide(color: Color(0x3310B981), width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0x3310B981),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              PhosphorIconsRegular.listDashes,
              size: 16,
              color: Color(0xFF34D399),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ESTAFET MODE ACTIVE',
                  style: AppTheme.scaled(
                    multiplier: AppTheme.m2xs,
                    weight: FontWeight.w900,
                    letterSpacing: 2,
                    color: const Color(0xFF34D399),
                  ),
                ),
                Text(
                  'Currently on: ${activeGig.title}',
                  style: AppTheme.scaled(
                    multiplier: AppTheme.m13,
                    weight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Up Next',
                style: AppTheme.scaled(
                  multiplier: AppTheme.mxs,
                  weight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ),
              Text(
                '${queuedGigs.length}',
                style: AppTheme.scaled(
                  multiplier: AppTheme.mlg,
                  weight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isAutoPilot) {
    if (isAutoPilot) {
      return _buildAutoPilotView();
    }

    final currentGig = _getCurrentGig();
    if (currentGig == null) {
      return _buildEmptyView();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 96),
      child: Stack(
        children: [
          if (_currentIndex + 1 < GIGS.length)
            Positioned.fill(
              child: _GigCard(
                gig: GIGS[_currentIndex + 1],
                onSwipe: _handleSwipe,
                isTop: false,
                index: 1,
                swipeDirection: null,
              ),
            ),
          Positioned.fill(
            child: _GigCard(
              gig: currentGig,
              onSwipe: _handleSwipe,
              isTop: true,
              index: 0,
              swipeDirection: _swipeDirection,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAutoPilotView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 192,
            height: 192,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ..._buildRadarRings(),
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.5),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.robot,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Auto-Pilot Active',
            style: AppTheme.scaled(
              multiplier: AppTheme.m2xl,
              weight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sit back. We are instantly catching gigs\nthat match your preferences.',
            style: AppTheme.scaled(
              multiplier: AppTheme.mbase,
              weight: FontWeight.w500,
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRadarRings() {
    return List.generate(3, (i) => _RadarRingAnimation(delay: i * 600));
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              PhosphorIconsRegular.magnifyingGlass,
              size: 32,
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Queue Empty',
            style: AppTheme.scaled(
              multiplier: AppTheme.m2xl,
              weight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You've swiped through all available gigs.",
            style: AppTheme.scaled(
              multiplier: AppTheme.mbase,
              weight: FontWeight.w500,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => context.go('/'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'Return Home',
                style: AppTheme.scaled(
                  multiplier: AppTheme.m13,
                  weight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBidSheetOverlay() {
    final gig = _getCurrentGig()!;
    final defaultBid =
        int.tryParse(gig.price.replaceAll(RegExp(r'[^0-9]'), '')) ?? 50;

    return GestureDetector(
      onTap: () {
        _bidSheetController.reverse().then((_) {
          if (mounted) {
            setState(() => _showBidSheet = false);
          }
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bidSheetController,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withOpacity(0.8 * _bidSheetOpacity.value),
                );
              },
            ),
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bidSheetController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    0,
                    MediaQuery.of(context).size.height * _bidSheetY.value,
                  ),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Submit Your Bid',
                                style: AppTheme.scaled(
                                  multiplier: AppTheme.mxl,
                                  weight: FontWeight.w900,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _bidSheetController.reverse().then((_) {
                                    if (mounted) {
                                      setState(() => _showBidSheet = false);
                                    }
                                  });
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Icon(
                                    PhosphorIconsRegular.x,
                                    size: 20,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceContainer,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _bidAmount = max(1, _bidAmount - 5);
                                  }),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      PhosphorIconsRegular.minus,
                                      size: 28,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'YOUR BID',
                                      style: AppTheme.scaled(
                                        multiplier: AppTheme.m2xs,
                                        weight: FontWeight.w900,
                                        letterSpacing: 2,
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '\$',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF10B981),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 80,
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 48,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                            ),
                                            controller: TextEditingController(
                                              text: '$_bidAmount',
                                            ),
                                            onChanged: (value) {
                                              final parsed = int.tryParse(
                                                value,
                                              );
                                              if (parsed != null) {
                                                _bidAmount = parsed;
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _bidAmount += 5;
                                  }),
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      PhosphorIconsRegular.plus,
                                      size: 28,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildQuickBidButton('Down Bid', -15, defaultBid),
                              const SizedBox(width: 8),
                              _buildQuickBidButton('Match', 0, defaultBid),
                              const SizedBox(width: 8),
                              _buildQuickBidButton('Up Bid', 15, defaultBid),
                            ],
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            maxLines: 3,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText:
                                  'Why should they choose you? (Optional)',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.05),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: AppColors.primary.withOpacity(0.5),
                                ),
                              ),
                            ),
                            onChanged: (value) => _replyText = value,
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _handleBidSubmit,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.2),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    PhosphorIconsRegular.paperPlaneTilt,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'PLACE BID',
                                    style: AppTheme.scaled(
                                      multiplier: AppTheme.mbase,
                                      weight: FontWeight.w900,
                                      color: Colors.black,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickBidButton(String label, int delta, int defaultBid) {
    final isDown = delta < 0;
    final isUp = delta > 0;

    Color bgColor = Colors.white.withOpacity(0.05);
    Color textColor = Colors.white;

    if (isDown) {
      bgColor = const Color(0xFFDC2626).withOpacity(0.1);
      textColor = const Color(0xFFDC2626);
    } else if (isUp) {
      bgColor = const Color(0xFF10B981).withOpacity(0.1);
      textColor = const Color(0xFF10B981);
    }

    return GestureDetector(
      onTap: () => setState(() {
        _bidAmount = delta == 0 ? defaultBid : max(1, _bidAmount + delta);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDown)
              Icon(PhosphorIconsRegular.trendDown, size: 14, color: textColor),
            if (isUp)
              Icon(PhosphorIconsRegular.trendUp, size: 14, color: textColor),
            if (isDown || isUp) const SizedBox(width: 4),
            Text(
              '$label${delta != 0 ? ' \$${delta.abs()}' : ''}',
              style: AppTheme.scaled(
                multiplier: AppTheme.mxs,
                weight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RadarRingAnimation extends StatefulWidget {
  final int delay;

  const _RadarRingAnimation({required this.delay});

  @override
  State<_RadarRingAnimation> createState() => _RadarRingAnimationState();
}

class _RadarRingAnimationState extends State<_RadarRingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 0.5,
      end: 0.0,
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
                  color: AppColors.primary.withOpacity(0.4),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(96),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GigCard extends StatefulWidget {
  final Gig gig;
  final void Function(String) onSwipe;
  final bool isTop;
  final int index;
  final String? swipeDirection;

  const _GigCard({
    required this.gig,
    required this.onSwipe,
    required this.isTop,
    required this.index,
    required this.swipeDirection,
  });

  @override
  State<_GigCard> createState() => _GigCardState();
}

class _GigCardState extends State<_GigCard> with TickerProviderStateMixin {
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
      duration: const Duration(milliseconds: 400),
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
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic),
    );
    _enterOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _enterController, curve: Curves.easeOut));
    _enterY = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(parent: _enterController, curve: Curves.easeOutCubic),
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
      ).animate(CurvedAnimation(parent: _exitController, curve: Curves.easeIn));
      _exitRotate = Tween<double>(
        begin: 0.0,
        end: 0.0,
      ).animate(_exitController);
    } else if (direction == 'right') {
      _exitX = Tween<double>(begin: 0.0, end: 400).animate(
        CurvedAnimation(parent: _exitController, curve: Curves.easeOutCubic),
      );
      _exitY = Tween<double>(begin: 0.0, end: 50).animate(_exitController);
      _exitRotate = Tween<double>(begin: 0.0, end: 15).animate(_exitController);
    } else if (direction == 'left') {
      _exitX = Tween<double>(begin: 0.0, end: -400).animate(
        CurvedAnimation(parent: _exitController, curve: Curves.easeOutCubic),
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
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
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
                                    Colors.white.withOpacity(0.03),
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
                                          color: AppColors.primary.withOpacity(
                                            0.5,
                                          ),
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
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Icon(
                                        _getIconForType(widget.gig.iconType),
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
                                              color: AppColors.primary
                                                  .withOpacity(0.2),
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
                                        color: Colors.white.withOpacity(0.5),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
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
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
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
                                    color: Colors.white.withOpacity(0.4),
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
                                  color: Colors.white.withOpacity(0.05),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildActionButton(
                                      icon: PhosphorIconsRegular.x,
                                      color: Colors.white.withOpacity(0.5),
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
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 12, color: Colors.white.withOpacity(0.4)),
              const SizedBox(width: 4),
              Text(
                label.toUpperCase(),
                style: AppTheme.scaled(
                  multiplier: AppTheme.m2xs,
                  weight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white.withOpacity(0.4),
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
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
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
          color: AppColors.primary.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 20,
            ),
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

  IconData _getIconForType(dynamic iconType) {
    switch (iconType.toString()) {
      case 'TaskIconType.palette':
        return PhosphorIconsRegular.palette;
      case 'TaskIconType.code':
        return PhosphorIconsRegular.code;
      case 'TaskIconType.car':
        return PhosphorIconsRegular.car;
      case 'TaskIconType.truck':
        return PhosphorIconsRegular.truck;
      case 'TaskIconType.writing':
        return PhosphorIconsRegular.pencil;
      default:
        return PhosphorIconsRegular.briefcase;
    }
  }
}

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
  late Animation<double> _exitOpacity;

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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _yAnim = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
                  child: IgnorePointer(child: const _Particles()),
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
                              color: Colors.white.withOpacity(0.05),
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
                                          TextSpan(
                                            text: 'NEXT!',
                                            style: const TextStyle(
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
                                          TextSpan(
                                            text: 'MATCH!',
                                            style: const TextStyle(
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
                                  Icon(
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
                                      color: Colors.white.withOpacity(0.6),
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
                                  color: Colors.white.withOpacity(0.03),
                                  borderRadius: BorderRadius.circular(32),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
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
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Icon(
                                                _getIconForType(
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
                                            Icon(
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
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Container(
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(3),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Icon(
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
                                                color: Colors.white.withOpacity(
                                                  0.5,
                                                ),
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
                                          Icon(
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
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
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
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
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
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
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
                                                color: Colors.white.withOpacity(
                                                  0.1,
                                                ),
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
    return List.generate(3, (i) => _MatchRadarRing(delay: i * 800));
  }

  IconData _getIconForType(dynamic iconType) {
    switch (iconType.toString()) {
      case 'TaskIconType.palette':
        return PhosphorIconsRegular.palette;
      case 'TaskIconType.code':
        return PhosphorIconsRegular.code;
      case 'TaskIconType.car':
        return PhosphorIconsRegular.car;
      case 'TaskIconType.truck':
        return PhosphorIconsRegular.truck;
      case 'TaskIconType.writing':
        return PhosphorIconsRegular.pencil;
      default:
        return PhosphorIconsRegular.briefcase;
    }
  }
}

class _MatchRadarRing extends StatefulWidget {
  final int delay;

  const _MatchRadarRing({required this.delay});

  @override
  State<_MatchRadarRing> createState() => _MatchRadarRingState();
}

class _MatchRadarRingState extends State<_MatchRadarRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacityAnimation = Tween<double>(
      begin: 0.3,
      end: 0.0,
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
                  color: const Color(0xFF34D399).withOpacity(0.5),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(64),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Particles extends StatefulWidget {
  const _Particles();

  @override
  State<_Particles> createState() => _ParticlesState();
}

class _ParticlesState extends State<_Particles> {
  final Random _random = Random();
  final List<_ParticleData> _particles = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 30; i++) {
      _particles.add(
        _ParticleData(
          x: _random.nextDouble() * 400,
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
          .map((p) => _Particle(key: ValueKey(p.x), data: p))
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

  const _Particle({super.key, required this.data});

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
                  color: const Color(0xFF10B981).withOpacity(0.4),
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
