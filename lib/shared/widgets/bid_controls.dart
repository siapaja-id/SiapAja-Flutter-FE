import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../app_theme.dart';
import '../utils/color_extensions.dart';
import '../utils/decorations.dart';
import 'primary_action_button.dart';

// ---------------------------------------------------------------------------
// BidAmountStepper — 3-column minus / amount / plus stepper
// ---------------------------------------------------------------------------

class BidAmountStepper extends StatelessWidget {
  final int amount;
  final ValueChanged<int> onChanged;
  final int step;

  /// Colour for the dollar-sign prefix.  Defaults to emerald but
  /// the radar overlay uses [AppColors.emerald].
  final Color accentColor;

  const BidAmountStepper({
    super.key,
    required this.amount,
    required this.onChanged,
    this.step = 5,
    this.accentColor = AppColors.emerald,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.w10),
      ),
      child: Row(
        children: [
          _StepperButton(
            icon: PhosphorIconsRegular.minus,
            onTap: () => onChanged(
              (amount - step).clamp(1, 99999),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('YOUR BID', style: AppTheme.smallLabel),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: AppTheme.heroTitle
                          .copyWith(fontSize: 24, color: accentColor),
                    ),
                    SizedBox(
                      width: 112,
                      child: TextField(
                        controller:
                            TextEditingController(text: amount.toString()),
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          if (parsed != null) onChanged(parsed);
                        },
                        style: AppTheme.priceDisplay,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _StepperButton(
            icon: PhosphorIconsRegular.plus,
            onTap: () => onChanged(amount + step),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QuickBidRow — Down / Match / Up quick-bid buttons
// ---------------------------------------------------------------------------

class QuickBidRow extends StatelessWidget {
  final int defaultBid;
  final int currentBid;
  final ValueChanged<int> onBidChanged;
  final int delta;

  const QuickBidRow({
    super.key,
    required this.defaultBid,
    required this.currentBid,
    required this.onBidChanged,
    this.delta = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ActionChip(
          onPressed: () => onBidChanged(
            (currentBid - delta).clamp(1, 99999),
          ),
          avatar: const Icon(
            PhosphorIconsRegular.trendDown,
            size: 14,
            color: AppColors.onSurface,
          ),
          label: const Text('Down Bid'),
          backgroundColor: const Color(0xFFDC2626).withOpacity(0.1),
          labelStyle: AppTheme.meta,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 8),
        ActionChip(
          onPressed: () => onBidChanged(defaultBid),
          label: const Text('Match Original'),
          backgroundColor: Colors.white.w05,
          labelStyle: AppTheme.meta,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 8),
        ActionChip(
          onPressed: () => onBidChanged(currentBid + delta),
          avatar: const Icon(
            PhosphorIconsRegular.trendUp,
            size: 14,
            color: AppColors.onSurface,
          ),
          label: const Text('Up Bid'),
          backgroundColor: const Color(0xFF10B981).withOpacity(0.1),
          labelStyle: AppTheme.meta,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// BidPitchField — multi-line pitch text area with glass styling
// ---------------------------------------------------------------------------

class BidPitchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String? hintText;
  final TextEditingController? controller;
  final int maxLines;

  const BidPitchField({
    super.key,
    required this.onChanged,
    this.hintText = 'Why should they choose you? (Optional)',
    this.controller,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTheme.bodyBold,
      decoration: glassInputArea(hintText: hintText),
      maxLines: maxLines,
      minLines: 4,
      onChanged: onChanged,
    );
  }
}

// ---------------------------------------------------------------------------
// BidSubmitButton — full-width emerald submit button
// ---------------------------------------------------------------------------

class BidSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;

  const BidSubmitButton({
    super.key,
    required this.onPressed,
    this.label = 'PLACE BID',
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: label,
      onTap: onPressed,
    );
  }
}

// ---------------------------------------------------------------------------
// Internal helper — round stepper button (minus / plus)
// ---------------------------------------------------------------------------

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.w05,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 28, color: AppColors.onSurfaceVariant),
      ),
    );
  }
}
