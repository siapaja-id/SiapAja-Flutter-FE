import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String name,
    required String handle,
    required String avatar,
    @Default(false) bool verified,
    int? karma,
    @Default(false) bool isOnline,
  }) = _Author;
}
