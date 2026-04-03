import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../models/feed_item.dart';

IconData getIconForTaskType(TaskIconType type) => switch (type) {
  TaskIconType.palette => PhosphorIconsRegular.palette,
  TaskIconType.code => PhosphorIconsRegular.code,
  TaskIconType.car => PhosphorIconsRegular.car,
  TaskIconType.truck => PhosphorIconsRegular.truck,
  TaskIconType.writing => PhosphorIconsRegular.pencilSimple,
  TaskIconType.repair => PhosphorIconsRegular.wrench,
  TaskIconType.package => PhosphorIconsRegular.package,
  TaskIconType.location => PhosphorIconsRegular.mapPin,
};

String getStatusText(TaskStatus status) => switch (status) {
  TaskStatus.open => 'OPEN',
  TaskStatus.assigned => 'ASSIGNED',
  TaskStatus.inProgress => 'IN PROGRESS',
  TaskStatus.completed => 'COMPLETED',
  TaskStatus.finished => 'FINISHED',
};
