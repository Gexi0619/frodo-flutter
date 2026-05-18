import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';
part 'author.g.dart';

@freezed
class AuthorLoc with _$AuthorLoc {
  const factory AuthorLoc({
    required String id,
    required String name,
    String? uid,
  }) = _AuthorLoc;

  factory AuthorLoc.fromJson(Map<String, dynamic> json) =>
      _$AuthorLocFromJson(json);
}

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
    AuthorLoc? loc,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) => _$AuthorFromJson(json);
}
