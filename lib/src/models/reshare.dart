import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'reshare.freezed.dart';
part 'reshare.g.dart';

/// 讨论转发记录。
@freezed
class Reshare with _$Reshare {
  const factory Reshare({
    required String id,
    String? text,
    @JsonKey(name: 'create_time') String? createTime,
    String? uri,
    required Author author,
  }) = _Reshare;

  factory Reshare.fromJson(Map<String, dynamic> json) =>
      _$ReshareFromJson(json);
}
