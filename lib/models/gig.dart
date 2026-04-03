import 'package:freezed_annotation/freezed_annotation.dart';

import 'feed_item.dart';

part 'gig.freezed.dart';

enum GigType { ride, delivery, design, dev, writing, labor }

@freezed
abstract class Gig with _$Gig {
  const factory Gig({
    required String id,
    required String title,
    required GigType type,
    required String distance,
    required String time,
    required String price,
    required String description,
    required TaskIconType iconType,
    String? meta,
    required List<String> tags,
    required String clientName,
    required double clientRating,
  }) = _Gig;
}
