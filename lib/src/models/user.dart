import 'package:freezed_annotation/freezed_annotation.dart';

import 'author.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// 用户主页头图（`profile_banner`）。
/// `is_default=true` 时是系统默认底图，UI 上可据此回退到纯色背景。
@freezed
class ProfileBanner with _$ProfileBanner {
  const factory ProfileBanner({
    String? color,
    String? normal,
    String? large,
    @JsonKey(name: 'is_default') bool? isDefault,
  }) = _ProfileBanner;

  factory ProfileBanner.fromJson(Map<String, dynamic> json) =>
      _$ProfileBannerFromJson(json);
}

/// 用户完整信息（GET /api/v2/user/{user_id}?basic_only=false）。
///
/// openapi 字段极多，这里只保留 header 需要的：身份信息、关系字段（followed /
/// following_me）、统计数（关注 / 被关注 / 广播）、IP 属地与头图。
/// `basic_only=true` 不返回这些字段，故拉取时必须传 `basic_only=false`。
@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String name,
    String? uid,
    String? avatar,
    @JsonKey(name: 'large_avatar') String? largeAvatar,
    String? uri,
    String? url,
    String? gender,
    AuthorLoc? loc,
    @JsonKey(name: 'ip_location') String? ipLocation,
    String? intro,
    @JsonKey(name: 'reg_time') String? regTime,
    @JsonKey(name: 'profile_banner') ProfileBanner? profileBanner,
    @JsonKey(name: 'followers_count') int? followersCount,
    @JsonKey(name: 'following_count') int? followingCount,
    @JsonKey(name: 'statuses_count') int? statusesCount,
    @JsonKey(name: 'joined_group_count') int? joinedGroupCount,
    bool? followed,
    @JsonKey(name: 'following_me') bool? followingMe,
    @JsonKey(name: 'in_blacklist') bool? inBlacklist,
    @JsonKey(name: 'is_club') bool? isClub,
    String? remark,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// 与当前用户的关系，用于关注按钮文案。
  UserRelation get relation {
    final iFollow = followed ?? false;
    final followsMe = followingMe ?? false;
    if (iFollow && followsMe) return UserRelation.mutual;
    if (iFollow) return UserRelation.following;
    if (followsMe) return UserRelation.followsMe;
    return UserRelation.none;
  }
}

enum UserRelation { none, following, followsMe, mutual }
