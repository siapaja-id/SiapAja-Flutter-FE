import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../shared/utils/color_extensions.dart';
import '../../../../app_theme.dart';
import '../../../../models/feed_item.dart';
import '../../../../shared/widgets/base_sheet.dart';
import '../../../../shared/utils/decorations.dart';
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
                          style: AppTheme.smallLabel,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$',
                              style: AppTheme.heroTitle.copyWith(fontSize: 24, color: AppColors.emerald),
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
                  labelStyle: AppTheme.meta,
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
                  labelStyle: AppTheme.meta,
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
                  labelStyle: AppTheme.meta,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: widget.pitchCtrl,
              style: AppTheme.bodyBold,
              decoration: glassInputArea(
                hintText: 'Why should they choose you? (Optional)',
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
