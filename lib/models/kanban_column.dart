import 'package:freezed_annotation/freezed_annotation.dart';

part 'kanban_column.freezed.dart';

@freezed
abstract class KanbanColumn with _$KanbanColumn {
  const factory KanbanColumn({
    required String id,
    required String path,
    @Default(420) double width,
    Map<String, dynamic>? routeState,
    int? activeTab,
  }) = _KanbanColumn;
}
