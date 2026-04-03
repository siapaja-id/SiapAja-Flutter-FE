import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../shared/utils/color_extensions.dart';
import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/widgets/base_sheet.dart';
import '../../../../shared/widgets/primary_action_button.dart';

class BidSheet extends StatefulWidget {
  final TaskData task;
  final int defaultBid;
  final TextEditingController pitchCtrl;
  final void Function(int bidAmount, String pitch) onSubmit;

  const BidSheet({
    super.key,
    required this.task,
    required this.defaultBid,
    required this.pitchCtrl,
    required this.onSubmit,
  });

  @override
  State<BidSheet> createState() => _BidSheetState();

  static void show({
    required BuildContext context,
    required TaskData task,
    required int defaultBid,
    required TextEditingController pitchCtrl,
    required void Function(int bidAmount, String pitch) onSubmit,
  }) {
    BaseSheet.show(
      context: context,
      title: 'Submit Your Bid',
      builder: (_) => BidSheet(
        task: task,
        defaultBid: defaultBid,
        pitchCtrl: pitchCtrl,
        onSubmit: onSubmit,
      ),
    );
  }
}

class _BidSheetState extends State<BidSheet> {
  late int _bidAmount;

  @override
  void initState() {
    super.initState();
    _bidAmount = widget.defaultBid;
  }

  @override
  Widget build(BuildContext context) {
    return BaseSheet(
      title: 'Submit Your Bid',
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: Colors.white.w10),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => setState(
                      () => _bidAmount = (_bidAmount - 5).clamp(1, 99999),
                    ),
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.w05,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        PhosphorIconsRegular.minus,
                        size: 28,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'YOUR BID',
                          style: AppTheme.scaled(
                            multiplier: AppTheme.m2sm,
                            color: AppColors.onSurfaceVariant,
                            weight: FontWeight.w900,
                            letterSpacing: 3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$',
                              style: AppTheme.scaled(
                                multiplier: AppTheme.m3xl,
                                color: AppColors.emerald,
                                weight: FontWeight.w900,
                              ),
                            ),
                            SizedBox(
                              width: 112,
                              child: TextField(
                                controller: TextEditingController(
                                  text: _bidAmount.toString(),
                                ),
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  final parsed = int.tryParse(val);
                                  if (parsed != null) {
                                    setState(() => _bidAmount = parsed);
                                  }
                                },
                                style: AppTheme.scaled(
                                  multiplier: AppTheme.m28,
                                  color: AppColors.onSurface,
                                  weight: FontWeight.w900,
                                  letterSpacing: -2,
                                ),
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
                  InkWell(
                    onTap: () => setState(() => _bidAmount = _bidAmount + 5),
                    borderRadius: BorderRadius.circular(20),
                    child: Ink(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: Colors.white.w05,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        PhosphorIconsRegular.plus,
                        size: 28,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ActionChip(
                  onPressed: () => setState(
                    () => _bidAmount = (_bidAmount - 15).clamp(1, 99999),
                  ),
                  avatar: const Icon(
                    PhosphorIconsRegular.trendDown,
                    size: 14,
                    color: AppColors.onSurface,
                  ),
                  label: const Text('Down Bid'),
                  backgroundColor: Colors.white.w05,
                  labelStyle: AppTheme.scaled(
                    multiplier: AppTheme.mxs,
                    weight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  onPressed: () =>
                      setState(() => _bidAmount = widget.defaultBid),
                  label: const Text('Match Original'),
                  backgroundColor: Colors.white.w05,
                  labelStyle: AppTheme.scaled(
                    multiplier: AppTheme.mxs,
                    weight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 8),
                ActionChip(
                  onPressed: () => setState(() => _bidAmount = _bidAmount + 15),
                  avatar: const Icon(
                    PhosphorIconsRegular.trendUp,
                    size: 14,
                    color: AppColors.onSurface,
                  ),
                  label: const Text('Up Bid'),
                  backgroundColor: Colors.white.w05,
                  labelStyle: AppTheme.scaled(
                    multiplier: AppTheme.mxs,
                    weight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.pitchCtrl,
              style: AppTheme.scaled(
                multiplier: AppTheme.mbase,
                color: AppColors.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Why should they choose you? (Optional)',
                hintStyle: TextStyle(
                  color: AppColors.onSurfaceVariant.withOpacity(0.3),
                ),
                filled: true,
                fillColor: Colors.white.w05,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.w10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.w10),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 4,
              minLines: 4,
            ),
            const SizedBox(height: 20),
            PrimaryActionButton(
              label: 'PLACE BID',
              onTap: () {
                widget.onSubmit(_bidAmount, widget.pitchCtrl.text.trim());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
