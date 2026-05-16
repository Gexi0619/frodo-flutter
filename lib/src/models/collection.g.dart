// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CollectionImpl _$$CollectionImplFromJson(Map<String, dynamic> json) =>
    _$CollectionImpl(
      doulist: Doulist.fromJson(json['doulist'] as Map<String, dynamic>),
      time: json['time'] as String,
    );

Map<String, dynamic> _$$CollectionImplToJson(_$CollectionImpl instance) =>
    <String, dynamic>{'doulist': instance.doulist, 'time': instance.time};

_$DoulistImpl _$$DoulistImplFromJson(Map<String, dynamic> json) =>
    _$DoulistImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      owner: Author.fromJson(json['owner'] as Map<String, dynamic>),
      uri: json['uri'] as String?,
      url: json['url'] as String?,
      type: json['type'] as String?,
      listType: json['list_type'] as String?,
      sharingUrl: json['sharing_url'] as String?,
      coverUrl: json['cover_url'] as String?,
      itemsCount: (json['items_count'] as num?)?.toInt(),
      followersCount: (json['followers_count'] as num?)?.toInt(),
      isPrivate: json['is_private'] as bool?,
      category: json['category'] as String?,
      createTime: json['create_time'] as String?,
      updateTime: json['update_time'] as String?,
    );

Map<String, dynamic> _$$DoulistImplToJson(_$DoulistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'owner': instance.owner,
      'uri': instance.uri,
      'url': instance.url,
      'type': instance.type,
      'list_type': instance.listType,
      'sharing_url': instance.sharingUrl,
      'cover_url': instance.coverUrl,
      'items_count': instance.itemsCount,
      'followers_count': instance.followersCount,
      'is_private': instance.isPrivate,
      'category': instance.category,
      'create_time': instance.createTime,
      'update_time': instance.updateTime,
    };
