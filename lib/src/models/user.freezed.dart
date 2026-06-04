// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProfileBanner _$ProfileBannerFromJson(Map<String, dynamic> json) {
  return _ProfileBanner.fromJson(json);
}

/// @nodoc
mixin _$ProfileBanner {
  String? get color => throw _privateConstructorUsedError;
  String? get normal => throw _privateConstructorUsedError;
  String? get large => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_default')
  bool? get isDefault => throw _privateConstructorUsedError;

  /// Serializes this ProfileBanner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProfileBanner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProfileBannerCopyWith<ProfileBanner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileBannerCopyWith<$Res> {
  factory $ProfileBannerCopyWith(
    ProfileBanner value,
    $Res Function(ProfileBanner) then,
  ) = _$ProfileBannerCopyWithImpl<$Res, ProfileBanner>;
  @useResult
  $Res call({
    String? color,
    String? normal,
    String? large,
    @JsonKey(name: 'is_default') bool? isDefault,
  });
}

/// @nodoc
class _$ProfileBannerCopyWithImpl<$Res, $Val extends ProfileBanner>
    implements $ProfileBannerCopyWith<$Res> {
  _$ProfileBannerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProfileBanner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? normal = freezed,
    Object? large = freezed,
    Object? isDefault = freezed,
  }) {
    return _then(
      _value.copyWith(
            color: freezed == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String?,
            normal: freezed == normal
                ? _value.normal
                : normal // ignore: cast_nullable_to_non_nullable
                      as String?,
            large: freezed == large
                ? _value.large
                : large // ignore: cast_nullable_to_non_nullable
                      as String?,
            isDefault: freezed == isDefault
                ? _value.isDefault
                : isDefault // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProfileBannerImplCopyWith<$Res>
    implements $ProfileBannerCopyWith<$Res> {
  factory _$$ProfileBannerImplCopyWith(
    _$ProfileBannerImpl value,
    $Res Function(_$ProfileBannerImpl) then,
  ) = __$$ProfileBannerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? color,
    String? normal,
    String? large,
    @JsonKey(name: 'is_default') bool? isDefault,
  });
}

/// @nodoc
class __$$ProfileBannerImplCopyWithImpl<$Res>
    extends _$ProfileBannerCopyWithImpl<$Res, _$ProfileBannerImpl>
    implements _$$ProfileBannerImplCopyWith<$Res> {
  __$$ProfileBannerImplCopyWithImpl(
    _$ProfileBannerImpl _value,
    $Res Function(_$ProfileBannerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProfileBanner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? color = freezed,
    Object? normal = freezed,
    Object? large = freezed,
    Object? isDefault = freezed,
  }) {
    return _then(
      _$ProfileBannerImpl(
        color: freezed == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String?,
        normal: freezed == normal
            ? _value.normal
            : normal // ignore: cast_nullable_to_non_nullable
                  as String?,
        large: freezed == large
            ? _value.large
            : large // ignore: cast_nullable_to_non_nullable
                  as String?,
        isDefault: freezed == isDefault
            ? _value.isDefault
            : isDefault // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProfileBannerImpl implements _ProfileBanner {
  const _$ProfileBannerImpl({
    this.color,
    this.normal,
    this.large,
    @JsonKey(name: 'is_default') this.isDefault,
  });

  factory _$ProfileBannerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProfileBannerImplFromJson(json);

  @override
  final String? color;
  @override
  final String? normal;
  @override
  final String? large;
  @override
  @JsonKey(name: 'is_default')
  final bool? isDefault;

  @override
  String toString() {
    return 'ProfileBanner(color: $color, normal: $normal, large: $large, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileBannerImpl &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.normal, normal) || other.normal == normal) &&
            (identical(other.large, large) || other.large == large) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, color, normal, large, isDefault);

  /// Create a copy of ProfileBanner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileBannerImplCopyWith<_$ProfileBannerImpl> get copyWith =>
      __$$ProfileBannerImplCopyWithImpl<_$ProfileBannerImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProfileBannerImplToJson(this);
  }
}

abstract class _ProfileBanner implements ProfileBanner {
  const factory _ProfileBanner({
    final String? color,
    final String? normal,
    final String? large,
    @JsonKey(name: 'is_default') final bool? isDefault,
  }) = _$ProfileBannerImpl;

  factory _ProfileBanner.fromJson(Map<String, dynamic> json) =
      _$ProfileBannerImpl.fromJson;

  @override
  String? get color;
  @override
  String? get normal;
  @override
  String? get large;
  @override
  @JsonKey(name: 'is_default')
  bool? get isDefault;

  /// Create a copy of ProfileBanner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProfileBannerImplCopyWith<_$ProfileBannerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get uid => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'large_avatar')
  String? get largeAvatar => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  AuthorLoc? get loc => throw _privateConstructorUsedError;
  @JsonKey(name: 'ip_location')
  String? get ipLocation => throw _privateConstructorUsedError;
  String? get intro => throw _privateConstructorUsedError;
  @JsonKey(name: 'reg_time')
  String? get regTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'profile_banner')
  ProfileBanner? get profileBanner => throw _privateConstructorUsedError;
  @JsonKey(name: 'followers_count')
  int? get followersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'following_count')
  int? get followingCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'statuses_count')
  int? get statusesCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'joined_group_count')
  int? get joinedGroupCount => throw _privateConstructorUsedError;
  bool? get followed => throw _privateConstructorUsedError;
  @JsonKey(name: 'following_me')
  bool? get followingMe => throw _privateConstructorUsedError;
  @JsonKey(name: 'in_blacklist')
  bool? get inBlacklist => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_club')
  bool? get isClub => throw _privateConstructorUsedError;
  String? get remark => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String name,
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
  });

  $AuthorLocCopyWith<$Res>? get loc;
  $ProfileBannerCopyWith<$Res>? get profileBanner;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? uid = freezed,
    Object? avatar = freezed,
    Object? largeAvatar = freezed,
    Object? uri = freezed,
    Object? url = freezed,
    Object? gender = freezed,
    Object? loc = freezed,
    Object? ipLocation = freezed,
    Object? intro = freezed,
    Object? regTime = freezed,
    Object? profileBanner = freezed,
    Object? followersCount = freezed,
    Object? followingCount = freezed,
    Object? statusesCount = freezed,
    Object? joinedGroupCount = freezed,
    Object? followed = freezed,
    Object? followingMe = freezed,
    Object? inBlacklist = freezed,
    Object? isClub = freezed,
    Object? remark = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            uid: freezed == uid
                ? _value.uid
                : uid // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            largeAvatar: freezed == largeAvatar
                ? _value.largeAvatar
                : largeAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            loc: freezed == loc
                ? _value.loc
                : loc // ignore: cast_nullable_to_non_nullable
                      as AuthorLoc?,
            ipLocation: freezed == ipLocation
                ? _value.ipLocation
                : ipLocation // ignore: cast_nullable_to_non_nullable
                      as String?,
            intro: freezed == intro
                ? _value.intro
                : intro // ignore: cast_nullable_to_non_nullable
                      as String?,
            regTime: freezed == regTime
                ? _value.regTime
                : regTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            profileBanner: freezed == profileBanner
                ? _value.profileBanner
                : profileBanner // ignore: cast_nullable_to_non_nullable
                      as ProfileBanner?,
            followersCount: freezed == followersCount
                ? _value.followersCount
                : followersCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            followingCount: freezed == followingCount
                ? _value.followingCount
                : followingCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            statusesCount: freezed == statusesCount
                ? _value.statusesCount
                : statusesCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            joinedGroupCount: freezed == joinedGroupCount
                ? _value.joinedGroupCount
                : joinedGroupCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            followed: freezed == followed
                ? _value.followed
                : followed // ignore: cast_nullable_to_non_nullable
                      as bool?,
            followingMe: freezed == followingMe
                ? _value.followingMe
                : followingMe // ignore: cast_nullable_to_non_nullable
                      as bool?,
            inBlacklist: freezed == inBlacklist
                ? _value.inBlacklist
                : inBlacklist // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isClub: freezed == isClub
                ? _value.isClub
                : isClub // ignore: cast_nullable_to_non_nullable
                      as bool?,
            remark: freezed == remark
                ? _value.remark
                : remark // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorLocCopyWith<$Res>? get loc {
    if (_value.loc == null) {
      return null;
    }

    return $AuthorLocCopyWith<$Res>(_value.loc!, (value) {
      return _then(_value.copyWith(loc: value) as $Val);
    });
  }

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileBannerCopyWith<$Res>? get profileBanner {
    if (_value.profileBanner == null) {
      return null;
    }

    return $ProfileBannerCopyWith<$Res>(_value.profileBanner!, (value) {
      return _then(_value.copyWith(profileBanner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
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
  });

  @override
  $AuthorLocCopyWith<$Res>? get loc;
  @override
  $ProfileBannerCopyWith<$Res>? get profileBanner;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? uid = freezed,
    Object? avatar = freezed,
    Object? largeAvatar = freezed,
    Object? uri = freezed,
    Object? url = freezed,
    Object? gender = freezed,
    Object? loc = freezed,
    Object? ipLocation = freezed,
    Object? intro = freezed,
    Object? regTime = freezed,
    Object? profileBanner = freezed,
    Object? followersCount = freezed,
    Object? followingCount = freezed,
    Object? statusesCount = freezed,
    Object? joinedGroupCount = freezed,
    Object? followed = freezed,
    Object? followingMe = freezed,
    Object? inBlacklist = freezed,
    Object? isClub = freezed,
    Object? remark = freezed,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        uid: freezed == uid
            ? _value.uid
            : uid // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        largeAvatar: freezed == largeAvatar
            ? _value.largeAvatar
            : largeAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        loc: freezed == loc
            ? _value.loc
            : loc // ignore: cast_nullable_to_non_nullable
                  as AuthorLoc?,
        ipLocation: freezed == ipLocation
            ? _value.ipLocation
            : ipLocation // ignore: cast_nullable_to_non_nullable
                  as String?,
        intro: freezed == intro
            ? _value.intro
            : intro // ignore: cast_nullable_to_non_nullable
                  as String?,
        regTime: freezed == regTime
            ? _value.regTime
            : regTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        profileBanner: freezed == profileBanner
            ? _value.profileBanner
            : profileBanner // ignore: cast_nullable_to_non_nullable
                  as ProfileBanner?,
        followersCount: freezed == followersCount
            ? _value.followersCount
            : followersCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        followingCount: freezed == followingCount
            ? _value.followingCount
            : followingCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        statusesCount: freezed == statusesCount
            ? _value.statusesCount
            : statusesCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        joinedGroupCount: freezed == joinedGroupCount
            ? _value.joinedGroupCount
            : joinedGroupCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        followed: freezed == followed
            ? _value.followed
            : followed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        followingMe: freezed == followingMe
            ? _value.followingMe
            : followingMe // ignore: cast_nullable_to_non_nullable
                  as bool?,
        inBlacklist: freezed == inBlacklist
            ? _value.inBlacklist
            : inBlacklist // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isClub: freezed == isClub
            ? _value.isClub
            : isClub // ignore: cast_nullable_to_non_nullable
                  as bool?,
        remark: freezed == remark
            ? _value.remark
            : remark // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl({
    required this.id,
    required this.name,
    this.uid,
    this.avatar,
    @JsonKey(name: 'large_avatar') this.largeAvatar,
    this.uri,
    this.url,
    this.gender,
    this.loc,
    @JsonKey(name: 'ip_location') this.ipLocation,
    this.intro,
    @JsonKey(name: 'reg_time') this.regTime,
    @JsonKey(name: 'profile_banner') this.profileBanner,
    @JsonKey(name: 'followers_count') this.followersCount,
    @JsonKey(name: 'following_count') this.followingCount,
    @JsonKey(name: 'statuses_count') this.statusesCount,
    @JsonKey(name: 'joined_group_count') this.joinedGroupCount,
    this.followed,
    @JsonKey(name: 'following_me') this.followingMe,
    @JsonKey(name: 'in_blacklist') this.inBlacklist,
    @JsonKey(name: 'is_club') this.isClub,
    this.remark,
  }) : super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? uid;
  @override
  final String? avatar;
  @override
  @JsonKey(name: 'large_avatar')
  final String? largeAvatar;
  @override
  final String? uri;
  @override
  final String? url;
  @override
  final String? gender;
  @override
  final AuthorLoc? loc;
  @override
  @JsonKey(name: 'ip_location')
  final String? ipLocation;
  @override
  final String? intro;
  @override
  @JsonKey(name: 'reg_time')
  final String? regTime;
  @override
  @JsonKey(name: 'profile_banner')
  final ProfileBanner? profileBanner;
  @override
  @JsonKey(name: 'followers_count')
  final int? followersCount;
  @override
  @JsonKey(name: 'following_count')
  final int? followingCount;
  @override
  @JsonKey(name: 'statuses_count')
  final int? statusesCount;
  @override
  @JsonKey(name: 'joined_group_count')
  final int? joinedGroupCount;
  @override
  final bool? followed;
  @override
  @JsonKey(name: 'following_me')
  final bool? followingMe;
  @override
  @JsonKey(name: 'in_blacklist')
  final bool? inBlacklist;
  @override
  @JsonKey(name: 'is_club')
  final bool? isClub;
  @override
  final String? remark;

  @override
  String toString() {
    return 'User(id: $id, name: $name, uid: $uid, avatar: $avatar, largeAvatar: $largeAvatar, uri: $uri, url: $url, gender: $gender, loc: $loc, ipLocation: $ipLocation, intro: $intro, regTime: $regTime, profileBanner: $profileBanner, followersCount: $followersCount, followingCount: $followingCount, statusesCount: $statusesCount, joinedGroupCount: $joinedGroupCount, followed: $followed, followingMe: $followingMe, inBlacklist: $inBlacklist, isClub: $isClub, remark: $remark)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.largeAvatar, largeAvatar) ||
                other.largeAvatar == largeAvatar) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.loc, loc) || other.loc == loc) &&
            (identical(other.ipLocation, ipLocation) ||
                other.ipLocation == ipLocation) &&
            (identical(other.intro, intro) || other.intro == intro) &&
            (identical(other.regTime, regTime) || other.regTime == regTime) &&
            (identical(other.profileBanner, profileBanner) ||
                other.profileBanner == profileBanner) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.followingCount, followingCount) ||
                other.followingCount == followingCount) &&
            (identical(other.statusesCount, statusesCount) ||
                other.statusesCount == statusesCount) &&
            (identical(other.joinedGroupCount, joinedGroupCount) ||
                other.joinedGroupCount == joinedGroupCount) &&
            (identical(other.followed, followed) ||
                other.followed == followed) &&
            (identical(other.followingMe, followingMe) ||
                other.followingMe == followingMe) &&
            (identical(other.inBlacklist, inBlacklist) ||
                other.inBlacklist == inBlacklist) &&
            (identical(other.isClub, isClub) || other.isClub == isClub) &&
            (identical(other.remark, remark) || other.remark == remark));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    uid,
    avatar,
    largeAvatar,
    uri,
    url,
    gender,
    loc,
    ipLocation,
    intro,
    regTime,
    profileBanner,
    followersCount,
    followingCount,
    statusesCount,
    joinedGroupCount,
    followed,
    followingMe,
    inBlacklist,
    isClub,
    remark,
  ]);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User extends User {
  const factory _User({
    required final String id,
    required final String name,
    final String? uid,
    final String? avatar,
    @JsonKey(name: 'large_avatar') final String? largeAvatar,
    final String? uri,
    final String? url,
    final String? gender,
    final AuthorLoc? loc,
    @JsonKey(name: 'ip_location') final String? ipLocation,
    final String? intro,
    @JsonKey(name: 'reg_time') final String? regTime,
    @JsonKey(name: 'profile_banner') final ProfileBanner? profileBanner,
    @JsonKey(name: 'followers_count') final int? followersCount,
    @JsonKey(name: 'following_count') final int? followingCount,
    @JsonKey(name: 'statuses_count') final int? statusesCount,
    @JsonKey(name: 'joined_group_count') final int? joinedGroupCount,
    final bool? followed,
    @JsonKey(name: 'following_me') final bool? followingMe,
    @JsonKey(name: 'in_blacklist') final bool? inBlacklist,
    @JsonKey(name: 'is_club') final bool? isClub,
    final String? remark,
  }) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get uid;
  @override
  String? get avatar;
  @override
  @JsonKey(name: 'large_avatar')
  String? get largeAvatar;
  @override
  String? get uri;
  @override
  String? get url;
  @override
  String? get gender;
  @override
  AuthorLoc? get loc;
  @override
  @JsonKey(name: 'ip_location')
  String? get ipLocation;
  @override
  String? get intro;
  @override
  @JsonKey(name: 'reg_time')
  String? get regTime;
  @override
  @JsonKey(name: 'profile_banner')
  ProfileBanner? get profileBanner;
  @override
  @JsonKey(name: 'followers_count')
  int? get followersCount;
  @override
  @JsonKey(name: 'following_count')
  int? get followingCount;
  @override
  @JsonKey(name: 'statuses_count')
  int? get statusesCount;
  @override
  @JsonKey(name: 'joined_group_count')
  int? get joinedGroupCount;
  @override
  bool? get followed;
  @override
  @JsonKey(name: 'following_me')
  bool? get followingMe;
  @override
  @JsonKey(name: 'in_blacklist')
  bool? get inBlacklist;
  @override
  @JsonKey(name: 'is_club')
  bool? get isClub;
  @override
  String? get remark;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
