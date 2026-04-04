import 'package:flutter/material.dart';

import '../../../../models/feed_item.dart';
import '../../../../shared/widgets/base_sheet.dart';
import '../../../../shared/widgets/bid_controls.dart';

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
            BidAmountStepper(
              amount: _bidAmount,
              onChanged: (v) => setState(() => _bidAmount = v),
            ),
            const SizedBox(height: 20),
            QuickBidRow(
              defaultBid: widget.defaultBid,
              currentBid: _bidAmount,
              onBidChanged: (v) => setState(() => _bidAmount = v),
            ),
            const SizedBox(height: 20),
            BidPitchField(
              controller: widget.pitchCtrl,
              onChanged: (_) {},
            ),
            const SizedBox(height: 20),
            BidSubmitButton(
              onPressed: () {
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
