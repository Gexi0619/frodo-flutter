import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'reaction.freezed.dart';
part 'reaction.g.dart';

/// 讨论点赞记录。
@freezed
class Reaction with _$Reaction {
  const factory Reaction({
    required String time,
    @JsonKey(name: 'reaction_type') required int reactionType,
    String? text,
    required Author user,
  }) = _Reaction;

  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(json);
}
