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
  isSubscribed: _boolFromJson(json['is_subscribed']),
  isOfficial: _boolFromJson(json['is_official']),
  sharingUrl: json['sharing_url'] as String?,
  backgroundMaskColor: json['background_mask_color'] as String?,
  rulesDesc: json['rules_desc'] as String?,
  groupTabs: (json['group_tabs'] as List<dynamic>?)
      ?.map((e) => GroupTab.fromJson(e as Map<String, dynamic>))
      .toList(),
  feedTags: (json['feed_tags'] as List<dynamic>?)
      ?.map((e) => FeedTag.fromJson(e as Map<String, dynamic>))
      .toList(),
  joinType: json['join_type'] as String?,
  memberRole: (json['member_role'] as num?)?.toInt(),
  joiningGuide: json['joining_guide'] == null
      ? null
      : GroupGuide.fromJson(json['joining_guide'] as Map<String, dynamic>),
  joinedGuide: json['joined_guide'] == null
      ? null
      : GroupGuide.fromJson(json['joined_guide'] as Map<String, dynamic>),
  unreadCountStr: json['unread_count_str'] as String?,
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
      'join_type': instance.joinType,
      'member_role': instance.memberRole,
      'joining_guide': instance.joiningGuide,
      'joined_guide': instance.joinedGuide,
      'unread_count_str': instance.unreadCountStr,
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

_$GroupGuideImpl _$$GroupGuideImplFromJson(Map<String, dynamic> json) =>
    _$GroupGuideImpl(
      text: json['text'] as String?,
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$GroupGuideImplToJson(_$GroupGuideImpl instance) =>
    <String, dynamic>{'text': instance.text, 'links': instance.links};

_$FeedTagImpl _$$FeedTagImplFromJson(Map<String, dynamic> json) =>
    _$FeedTagImpl(
      sortby: json['sortby'] as String,
      title: json['title'] as String,
    );

Map<String, dynamic> _$$FeedTagImplToJson(_$FeedTagImpl instance) =>
    <String, dynamic>{'sortby': instance.sortby, 'title': instance.title};
