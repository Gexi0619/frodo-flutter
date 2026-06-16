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
      totalReplies: (json['total_replies'] as num?)?.toInt(),
      nextReplyStart: (json['next_reply_start'] as num?)?.toInt(),
      isVoted: json['is_voted'] as bool?,
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => CommentPhoto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CommentPhoto>[],
      replies:
          (json['replies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Comment>[],
      author: json['author'] == null
          ? null
          : Author.fromJson(json['author'] as Map<String, dynamic>),
      refComment: json['ref_comment'] == null
          ? null
          : Comment.fromJson(json['ref_comment'] as Map<String, dynamic>),
      parentCommentId: json['parent_comment_id'] as String?,
      ipLocation: json['ip_location'] as String?,
      isFolded: json['is_folded'] as bool? ?? false,
      foldedMessage: json['folded_message'] as String?,
      foldedReasonText: json['folded_reason_text'] as String?,
      isCensoring: json['is_censoring'] as bool? ?? false,
      censorMessage: json['censor_message'] as String?,
      censorMessageMore: json['censor_message_more'] as String?,
    );

Map<String, dynamic> _$$CommentImplToJson(_$CommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'create_time': instance.createTime,
      'vote_count': instance.voteCount,
      'total_replies': instance.totalReplies,
      'next_reply_start': instance.nextReplyStart,
      'is_voted': instance.isVoted,
      'photos': instance.photos,
      'replies': instance.replies,
      'author': instance.author,
      'ref_comment': instance.refComment,
      'parent_comment_id': instance.parentCommentId,
      'ip_location': instance.ipLocation,
      'is_folded': instance.isFolded,
      'folded_message': instance.foldedMessage,
      'folded_reason_text': instance.foldedReasonText,
      'is_censoring': instance.isCensoring,
      'censor_message': instance.censorMessage,
      'censor_message_more': instance.censorMessageMore,
    };

_$CommentPhotoImpl _$$CommentPhotoImplFromJson(Map<String, dynamic> json) =>
    _$CommentPhotoImpl(
      id: json['id'] as String?,
      image: json['image'] == null
          ? null
          : CommentPhotoImage.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$CommentPhotoImplToJson(_$CommentPhotoImpl instance) =>
    <String, dynamic>{'id': instance.id, 'image': instance.image};

_$CommentPhotoImageImpl _$$CommentPhotoImageImplFromJson(
  Map<String, dynamic> json,
) => _$CommentPhotoImageImpl(
  large: json['large'] == null
      ? null
      : CommentPhotoSize.fromJson(json['large'] as Map<String, dynamic>),
  normal: json['normal'] == null
      ? null
      : CommentPhotoSize.fromJson(json['normal'] as Map<String, dynamic>),
  isAnimated: json['is_animated'] as bool? ?? false,
);

Map<String, dynamic> _$$CommentPhotoImageImplToJson(
  _$CommentPhotoImageImpl instance,
) => <String, dynamic>{
  'large': instance.large,
  'normal': instance.normal,
  'is_animated': instance.isAnimated,
};

_$CommentPhotoSizeImpl _$$CommentPhotoSizeImplFromJson(
  Map<String, dynamic> json,
) => _$CommentPhotoSizeImpl(
  url: json['url'] as String?,
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
);

Map<String, dynamic> _$$CommentPhotoSizeImplToJson(
  _$CommentPhotoSizeImpl instance,
) => <String, dynamic>{
  'url': instance.url,
  'width': instance.width,
  'height': instance.height,
};
