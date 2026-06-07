// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'topic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TopicImpl _$$TopicImplFromJson(Map<String, dynamic> json) => _$TopicImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  abstract: json['abstract'] as String?,
  content: json['content'] as String?,
  createTime: json['create_time'] as String?,
  updateTime: json['update_time'] as String?,
  editTime: json['edit_time'] as String?,
  ipLocation: json['ip_location'] as String?,
  commentsCount: (json['comments_count'] as num?)?.toInt(),
  reactionsCount: (json['reactions_count'] as num?)?.toInt(),
  collectionsCount: (json['collections_count'] as num?)?.toInt(),
  resharesCount: (json['reshares_count'] as num?)?.toInt(),
  reactionType: (json['reaction_type'] as num?)?.toInt() ?? 0,
  sharingUrl: json['sharing_url'] as String?,
  coverUrl: json['cover_url'] as String?,
  imageLayout: json['image_layout'] as String?,
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => TopicPhoto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TopicPhoto>[],
  author: json['author'] == null
      ? null
      : Author.fromJson(json['author'] as Map<String, dynamic>),
  group: json['group'] == null
      ? null
      : Group.fromJson(json['group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$TopicImplToJson(_$TopicImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'abstract': instance.abstract,
      'content': instance.content,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
      'edit_time': instance.editTime,
      'ip_location': instance.ipLocation,
      'comments_count': instance.commentsCount,
      'reactions_count': instance.reactionsCount,
      'collections_count': instance.collectionsCount,
      'reshares_count': instance.resharesCount,
      'reaction_type': instance.reactionType,
      'sharing_url': instance.sharingUrl,
      'cover_url': instance.coverUrl,
      'image_layout': instance.imageLayout,
      'photos': instance.photos,
      'author': instance.author,
      'group': instance.group,
    };

_$TopicPhotoImpl _$$TopicPhotoImplFromJson(Map<String, dynamic> json) =>
    _$TopicPhotoImpl(
      id: json['id'] as String?,
      title: json['title'] as String?,
      images: json['image'] == null
          ? null
          : TopicPhotoImages.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TopicPhotoImplToJson(_$TopicPhotoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'image': instance.images,
    };

_$TopicPhotoImagesImpl _$$TopicPhotoImagesImplFromJson(
  Map<String, dynamic> json,
) => _$TopicPhotoImagesImpl(
  large: json['large'] == null
      ? null
      : TopicImage.fromJson(json['large'] as Map<String, dynamic>),
  normal: json['normal'] == null
      ? null
      : TopicImage.fromJson(json['normal'] as Map<String, dynamic>),
  raw: json['raw'] == null
      ? null
      : TopicImage.fromJson(json['raw'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$TopicPhotoImagesImplToJson(
  _$TopicPhotoImagesImpl instance,
) => <String, dynamic>{
  'large': instance.large,
  'normal': instance.normal,
  'raw': instance.raw,
};

_$TopicImageImpl _$$TopicImageImplFromJson(Map<String, dynamic> json) =>
    _$TopicImageImpl(
      url: json['url'] as String?,
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      size: (json['size'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$TopicImageImplToJson(_$TopicImageImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
      'size': instance.size,
    };
