import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';
part 'author.g.dart';

/// 用户/作者：在 owner、reply_to、target.owner 等字段中复用。
@freezed
class Author with _$Author {
  const factory Author({
    required String id,
    required String name,
    String? avatar,
    String? uri,
    String? type,
    @JsonKey(name: 'large_avatar') String? largeAvatar,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}
