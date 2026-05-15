// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  largeAvatar: json['large_avatar'] as String?,
  desc: json['desc'] as String?,
  descAbstract: json['desc_abstract'] as String?,
  subtitle: json['subtitle'] as String?,
  slogan: json['slogan'] as String?,
  memberCount: (json['member_count'] as num?)?.toInt(),
  memberCountText: json['member_count_text'] as String?,
  memberName: json['member_name'] as String?,
  topicCount: (json['topic_count'] as num?)?.toInt(),
  isSubscribed: json['is_subscribed'] as bool?,
  isOfficial: json['is_official'] as bool?,
  sharingUrl: json['sharing_url'] as String?,
  backgroundMaskColor: json['background_mask_color'] as String?,
  rulesDesc: json['rules_desc'] as String?,
  groupTabs: (json['group_tabs'] as List<dynamic>?)
      ?.map((e) => GroupTab.fromJson(e as Map<String, dynamic>))
      .toList(),
  feedTags: (json['feed_tags'] as List<dynamic>?)
      ?.map((e) => FeedTag.fromJson(e as Map<String, dynamic>))
      .toList(),
  owner: json['owner'] == null
      ? null
      : Author.fromJson(json['owner'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'large_avatar': instance.largeAvatar,
      'desc': instance.desc,
      'desc_abstract': instance.descAbstract,
      'subtitle': instance.subtitle,
      'slogan': instance.slogan,
      'member_count': instance.memberCount,
      'member_count_text': instance.memberCountText,
      'member_name': instance.memberName,
      'topic_count': instance.topicCount,
      'is_subscribed': instance.isSubscribed,
      'is_official': instance.isOfficial,
      'sharing_url': instance.sharingUrl,
      'background_mask_color': instance.backgroundMaskColor,
      'rules_desc': instance.rulesDesc,
      'group_tabs': instance.groupTabs,
      'feed_tags': instance.feedTags,
      'owner': instance.owner,
    };

_$GroupTabImpl _$$GroupTabImplFromJson(Map<String, dynamic> json) =>
    _$GroupTabImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
      uri: json['uri'] as String?,
      seq: (json['seq'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$GroupTabImplToJson(_$GroupTabImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'uri': instance.uri,
      'seq': instance.seq,
    };

_$FeedTagImpl _$$FeedTagImplFromJson(Map<String, dynamic> json) =>
    _$FeedTagImpl(
      sortby: json['sortby'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$$FeedTagImplToJson(_$FeedTagImpl instance) =>
    <String, dynamic>{'sortby': instance.sortby, 'title': instance.title};
