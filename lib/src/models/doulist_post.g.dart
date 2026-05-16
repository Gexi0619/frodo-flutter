// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doulist_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DoulistPostImpl _$$DoulistPostImplFromJson(Map<String, dynamic> json) =>
    _$DoulistPostImpl(
      id: json['id'] as String,
      collectionTime: json['collection_time'] as String?,
      collectionReason: json['collection_reason'] as String?,
      commentsCount: (json['comments_count'] as num?)?.toInt(),
      reactionsCount: (json['reactions_count'] as num?)?.toInt(),
      resharesCount: (json['reshares_count'] as num?)?.toInt(),
      content: json['content'] == null
          ? null
          : DoulistPostContent.fromJson(
              json['content'] as Map<String, dynamic>,
            ),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$$DoulistPostImplToJson(_$DoulistPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'collection_time': instance.collectionTime,
      'collection_reason': instance.collectionReason,
      'comments_count': instance.commentsCount,
      'reactions_count': instance.reactionsCount,
      'reshares_count': instance.resharesCount,
      'content': instance.content,
      'type': instance.type,
    };

_$DoulistPostContentImpl _$$DoulistPostContentImplFromJson(
  Map<String, dynamic> json,
) => _$DoulistPostContentImpl(
  id: json['id'] as String,
  title: json['title'] as String,
  abstract: json['abstract'] as String?,
  author: json['author'] == null
      ? null
      : Author.fromJson(json['author'] as Map<String, dynamic>),
  photos:
      (json['photos'] as List<dynamic>?)
          ?.map((e) => TopicPhoto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TopicPhoto>[],
  uri: json['uri'] as String?,
  url: json['url'] as String?,
);

Map<String, dynamic> _$$DoulistPostContentImplToJson(
  _$DoulistPostContentImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'abstract': instance.abstract,
  'author': instance.author,
  'photos': instance.photos,
  'uri': instance.uri,
  'url': instance.url,
};
