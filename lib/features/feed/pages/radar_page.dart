import '../../../shared/utils/color_extensions.dart';
import '../../../shared/widgets/ring_animation.dart';
import '../../../shared/widgets/themed_background.dart';
import '../../../shared/widgets/bid_controls.dart';
import 'dart:async';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../app_theme.dart';
import '../../../models/gig.dart';
import '../../../shared/constants/mock_gigs.dart';
import '../../../shared/utils/price_utils.dart';
import '../../../shared/widgets/close_button.dart';
import '../providers.dart';
import '../widgets/gig_card.dart';
import '../widgets/match_success_sheet.dart';
import '../../../shared/widgets/empty_state.dart';

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
        _bidAmount = parsePrice(currentGig.price);
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
    if (_currentIndex >= gigs.length) return null;
    return gigs[_currentIndex];
  }

  void _advanceNext() {
    if (_showBidSheet) {
      _bidSheetController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _swipeDirection = null;
            _showBidSheet = false;
            if (_currentIndex < gigs.length - 1) {
              _currentIndex++;
            }
          });
        }
      });
    } else {
      setState(() {
        _swipeDirection = null;
        _showBidSheet = false;
        if (_currentIndex < gigs.length - 1) {
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
          if (_currentIndex + 1 < gigs.length)
            Positioned.fill(
              child: GigCard(
                gig: gigs[_currentIndex + 1],
                onSwipe: _handleSwipe,
                isTop: false,
                index: 1,
                swipeDirection: null,
              ),
            ),
          Positioned.fill(
            child: GigCard(
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
    return EmptyState(
      icon: PhosphorIconsRegular.magnifyingGlass,
      title: 'Queue Empty',
      subtitle: "You've swiped through all available gigs.",
      actionLabel: 'Return Home',
      onAction: () => context.go('/'),
    );
  }

  Widget _buildBidSheetOverlay() {
    final gig = _getCurrentGig()!;
    final defaultBid = parsePrice(gig.price);

    void closeBidSheet() {
      _bidSheetController.reverse().then((_) {
        if (mounted) {
          setState(() => _showBidSheet = false);
        }
      });
    }

    return GestureDetector(
      onTap: closeBidSheet,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _bidSheetController,
              builder: (context, child) {
                return Container(
                  color: Colors.black.withValues(alpha: 0.8 * _bidSheetOpacity.value),
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
                                onTap: closeBidSheet,
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
                            onChanged: (_) {},
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
