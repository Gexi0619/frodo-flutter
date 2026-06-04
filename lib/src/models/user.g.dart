// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileBannerImpl _$$ProfileBannerImplFromJson(Map<String, dynamic> json) =>
    _$ProfileBannerImpl(
      color: json['color'] as String?,
      normal: json['normal'] as String?,
      large: json['large'] as String?,
      isDefault: json['is_default'] as bool?,
    );

Map<String, dynamic> _$$ProfileBannerImplToJson(_$ProfileBannerImpl instance) =>
    <String, dynamic>{
      'color': instance.color,
      'normal': instance.normal,
      'large': instance.large,
      'is_default': instance.isDefault,
    };

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  uid: json['uid'] as String?,
  avatar: json['avatar'] as String?,
  largeAvatar: json['large_avatar'] as String?,
  uri: json['uri'] as String?,
  url: json['url'] as String?,
  gender: json['gender'] as String?,
  loc: json['loc'] == null
      ? null
      : AuthorLoc.fromJson(json['loc'] as Map<String, dynamic>),
  ipLocation: json['ip_location'] as String?,
  intro: json['intro'] as String?,
  regTime: json['reg_time'] as String?,
  profileBanner: json['profile_banner'] == null
      ? null
      : ProfileBanner.fromJson(json['profile_banner'] as Map<String, dynamic>),
  followersCount: (json['followers_count'] as num?)?.toInt(),
  followingCount: (json['following_count'] as num?)?.toInt(),
  statusesCount: (json['statuses_count'] as num?)?.toInt(),
  joinedGroupCount: (json['joined_group_count'] as num?)?.toInt(),
  followed: json['followed'] as bool?,
  followingMe: json['following_me'] as bool?,
  inBlacklist: json['in_blacklist'] as bool?,
  isClub: json['is_club'] as bool?,
  remark: json['remark'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uid': instance.uid,
      'avatar': instance.avatar,
      'large_avatar': instance.largeAvatar,
      'uri': instance.uri,
      'url': instance.url,
      'gender': instance.gender,
      'loc': instance.loc,
      'ip_location': instance.ipLocation,
      'intro': instance.intro,
      'reg_time': instance.regTime,
      'profile_banner': instance.profileBanner,
      'followers_count': instance.followersCount,
      'following_count': instance.followingCount,
      'statuses_count': instance.statusesCount,
      'joined_group_count': instance.joinedGroupCount,
      'followed': instance.followed,
      'following_me': instance.followingMe,
      'in_blacklist': instance.inBlacklist,
      'is_club': instance.isClub,
      'remark': instance.remark,
    };
