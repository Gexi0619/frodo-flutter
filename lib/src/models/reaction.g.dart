// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactionImpl _$$ReactionImplFromJson(Map<String, dynamic> json) =>
    _$ReactionImpl(
      time: json['time'] as String,
      reactionType: (json['reaction_type'] as num).toInt(),
      text: json['text'] as String?,
      user: Author.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReactionImplToJson(_$ReactionImpl instance) =>
    <String, dynamic>{
      'time': instance.time,
      'reaction_type': instance.reactionType,
      'text': instance.text,
      'user': instance.user,
    };
