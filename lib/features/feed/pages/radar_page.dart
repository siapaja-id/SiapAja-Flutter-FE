import '../../../shared/utils/color_extensions.dart';
import '../../../shared/utils/decorations.dart';
import '../../../shared/widgets/ring_animation.dart';
import '../../../shared/widgets/themed_background.dart';
import '../../../shared/widgets/bid_controls.dart';
import '../../../shared/utils/task_icons.dart';
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
import '../../../shared/utils/price_utils.dart';
import '../../../shared/widgets/close_button.dart';
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
      duration: AppTheme.animSheet,
      vsync: this,
    );
    _bidSheetY = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _bidSheetController, curve: AppTheme.curveOut),
    );
    _bidSheetOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bidSheetController, curve: AppTheme.curveOutQuart),
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

    Future.delayed(AppTheme.animSlide, () {
      if (!mounted) return;

      if (direction == 'up') {
        _bidAmount = parsePrice(currentGig.price) ?? 50;
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const ThemedBackground(),
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
              color: AppColors.primary.p20,
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
              border: Border.all(color: Colors.white.w05),
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
                    duration: AppTheme.animSlide,
                    curve: AppTheme.curveOut,
                    width: 40,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isAutoPilot
                          ? AppColors.primary
                          : Colors.white.w10,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isAutoPilot
                            ? AppColors.primary
                            : Colors.white.w20,
                      ),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: AppTheme.animSlide,
                          curve: AppTheme.curveOut,
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
                                  color: Colors.black.black20,
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
      duration: AppTheme.animSlide,
      curve: AppTheme.curveOut,
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
                  color: Colors.white.w50,
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
                        color: AppColors.primary.p50,
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
              color: Colors.white.w50,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRadarRings() {
    return List.generate(3, (i) => PulsingRing(
      delay: i * 600,
      color: AppColors.primary.p40,
    ));
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
              color: Colors.white.w05,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(
              PhosphorIconsRegular.magnifyingGlass,
              size: 32,
              color: Colors.white.w20,
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
              color: Colors.white.w50,
            ),
          ),
          const SizedBox(height: 32),
          GestureDetector(
            onTap: () => context.go('/'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.w10,
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
    final defaultBid = parsePrice(gig.price) ?? 50;

    void _closeBidSheet() {
      _bidSheetController.reverse().then((_) {
        if (mounted) {
          setState(() => _showBidSheet = false);
        }
      });
    }

    return GestureDetector(
      onTap: _closeBidSheet,
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
                            color: Colors.white.w10,
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
                              CloseButton(
                                onTap: _closeBidSheet,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          BidAmountStepper(
                            amount: _bidAmount,
                            onChanged: (v) => setState(() => _bidAmount = v),
                          ),
                          const SizedBox(height: 12),
                          QuickBidRow(
                            defaultBid: defaultBid,
                            currentBid: _bidAmount,
                            onBidChanged: (v) =>
                                setState(() => _bidAmount = v),
                          ),
                          const SizedBox(height: 16),
                          BidPitchField(
                            onChanged: (v) => _replyText = v,
                          ),
                          const SizedBox(height: 16),
                          BidSubmitButton(
                            onPressed: _handleBidSubmit,
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
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.curveOutQuart));
    _scaleAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.curveOut));
    _yAnim = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.curveOut));
    _exitOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppTheme.curveOutQuart));
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
