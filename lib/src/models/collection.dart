import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'collection.freezed.dart';
part 'collection.g.dart';

/// 讨论被收录的豆列。
@freezed
class Collection with _$Collection {
  const factory Collection({
    required Doulist doulist,
    required String time,
  }) = _Collection;

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);
}

/// 豆列。
@freezed
class Doulist with _$Doulist {
  const factory Doulist({
    required String id,
    required String title,
    required Author owner,
    String? uri,
    String? url,
    String? type,
    @JsonKey(name: 'list_type') String? listType,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
  }) = _Doulist;

  factory Doulist.fromJson(Map<String, dynamic> json) =>
      _$DoulistFromJson(json);
}
