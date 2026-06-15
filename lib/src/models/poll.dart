import 'package:freezed_annotation/freezed_annotation.dart';

part 'poll.freezed.dart';
part 'poll.g.dart';

/// 帖子内嵌投票。
///
/// 投票本身不在 topic 响应里，而是以
/// `<div data-entity-type="poll" data-id="{id}">` 形式嵌在正文 HTML 中，
/// 详情需另调 `/api/v2/ceorl/poll/{id}` 获取。
@freezed
class Poll with _$Poll {
  const Poll._();

  const factory Poll({
    required String id,
    @JsonKey(name: 'expire_time') String? expireTime,
    @JsonKey(name: 'has_correct_answer') @Default(false) bool hasCorrectAnswer,
    @JsonKey(name: 'input_type') String? inputType,
    @Default(<PollOption>[]) List<PollOption> options,
    @JsonKey(name: 'owner_id') String? ownerId,
    String? title,
    @JsonKey(name: 'vote_limit') @Default(1) int voteLimit,
    @JsonKey(name: 'voted_user_count') @Default(0) int votedUserCount,
  }) = _Poll;

  factory Poll.fromJson(Map<String, dynamic> json) => _$PollFromJson(json);

  /// 当前用户是否已投票（任一选项 is_voted）。
  bool get hasVoted => options.any((o) => o.isVoted);

  /// 是否多选（可投多于一票）。
  bool get isMultiSelect => voteLimit > 1;

  /// 截止时刻。expire_time 自带时区（如 `2026-06-22T11:10:54+08:00`），
  /// 直接解析即可，不能补 `+08:00`。为空表示不限时。
  DateTime? get expireAt {
    final raw = expireTime;
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  /// 投票是否已截止。expire_time 为空表示不限时。
  bool get isExpired {
    final t = expireAt;
    return t != null && t.isBefore(DateTime.now());
  }

  /// 已投票或已截止时展示结果（票数 / 百分比），否则展示可交互选项。
  bool get showResults => hasVoted || isExpired;
}

@freezed
class PollOption with _$PollOption {
  const factory PollOption({
    required String id,
    @JsonKey(name: 'is_correct') @Default(false) bool isCorrect,
    @JsonKey(name: 'is_voted') @Default(false) bool isVoted,
    @JsonKey(name: 'poll_id') String? pollId,
    required String title,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'voted_user_count') @Default(0) int votedUserCount,
  }) = _PollOption;

  factory PollOption.fromJson(Map<String, dynamic> json) =>
      _$PollOptionFromJson(json);
}
