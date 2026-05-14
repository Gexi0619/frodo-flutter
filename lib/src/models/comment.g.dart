// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CommentImpl _$$CommentImplFromJson(Map<String, dynamic> json) =>
    _$CommentImpl(
      id: json['id'] as String,
      text: json['text'] as String?,
      createTime: json['create_time'] as String?,
      voteCount: (json['vote_count'] as num?)?.toInt(),
      repliesCount: (json['replies_count'] as num?)?.toInt(),
      isLiked: json['is_liked'] as bool?,
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      refComment: json['ref_comment'] == null
          ? null
          : Comment.fromJson(json['ref_comment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'create_time': instance.createTime,
      'vote_count': instance.voteCount,
      'replies_count': instance.repliesCount,
      'is_liked': instance.isLiked,
      'author': instance.author,
      'ref_comment': instance.refComment,
    };
