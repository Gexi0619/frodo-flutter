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
      photos:
          (json['photos'] as List<dynamic>?)
              ?.map((e) => CommentPhoto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <CommentPhoto>[],
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
      'photos': instance.photos,
      'author': instance.author,
      'ref_comment': instance.refComment,
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
