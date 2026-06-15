// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PollImpl _$$PollImplFromJson(Map<String, dynamic> json) => _$PollImpl(
  id: json['id'] as String,
  expireTime: json['expire_time'] as String?,
  hasCorrectAnswer: json['has_correct_answer'] as bool? ?? false,
  inputType: json['input_type'] as String?,
  options:
      (json['options'] as List<dynamic>?)
          ?.map((e) => PollOption.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PollOption>[],
  ownerId: json['owner_id'] as String?,
  title: json['title'] as String?,
  voteLimit: (json['vote_limit'] as num?)?.toInt() ?? 1,
  votedUserCount: (json['voted_user_count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PollImplToJson(_$PollImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'expire_time': instance.expireTime,
      'has_correct_answer': instance.hasCorrectAnswer,
      'input_type': instance.inputType,
      'options': instance.options,
      'owner_id': instance.ownerId,
      'title': instance.title,
      'vote_limit': instance.voteLimit,
      'voted_user_count': instance.votedUserCount,
    };

_$PollOptionImpl _$$PollOptionImplFromJson(Map<String, dynamic> json) =>
    _$PollOptionImpl(
      id: json['id'] as String,
      isCorrect: json['is_correct'] as bool? ?? false,
      isVoted: json['is_voted'] as bool? ?? false,
      pollId: json['poll_id'] as String?,
      title: json['title'] as String,
      userId: json['user_id'] as String?,
      votedUserCount: (json['voted_user_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PollOptionImplToJson(_$PollOptionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_correct': instance.isCorrect,
      'is_voted': instance.isVoted,
      'poll_id': instance.pollId,
      'title': instance.title,
      'user_id': instance.userId,
      'voted_user_count': instance.votedUserCount,
    };
