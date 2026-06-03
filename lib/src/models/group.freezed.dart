// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  @JsonKey(name: 'large_avatar')
  String? get largeAvatar => throw _privateConstructorUsedError;
  String? get desc => throw _privateConstructorUsedError;
  @JsonKey(name: 'desc_abstract')
  String? get descAbstract => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get slogan => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_count')
  int? get memberCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_count_text')
  String? get memberCountText => throw _privateConstructorUsedError;
  @JsonKey(name: 'member_name')
  String? get memberName => throw _privateConstructorUsedError;
  @JsonKey(name: 'topic_count')
  int? get topicCount => throw _privateConstructorUsedError; // 部分接口（如 recommend_feed 的 owner）把这些字段返成 0/1 整数而非布尔，
  // 用 [_boolFromJson] 容错，否则 `int as bool?` 会抛类型错误。
  @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson)
  bool? get isSubscribed => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_official', fromJson: _boolFromJson)
  bool? get isOfficial => throw _privateConstructorUsedError;
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'background_mask_color')
  String? get backgroundMaskColor => throw _privateConstructorUsedError;
  @JsonKey(name: 'rules_desc')
  String? get rulesDesc => throw _privateConstructorUsedError;
  @JsonKey(name: 'group_tabs')
  List<GroupTab>? get groupTabs => throw _privateConstructorUsedError;
  @JsonKey(name: 'feed_tags')
  List<FeedTag>? get feedTags => throw _privateConstructorUsedError;

  /// 小组本身的加入方式：'A'=自动通过；'R'=需要填写申请理由审核。
  /// 注意：这反映的是小组规则，**不是**当前用户是否已加入。
  @JsonKey(name: 'join_type')
  String? get joinType => throw _privateConstructorUsedError;

  /// 当前用户在该小组的角色 / 加入状态。详见 [GroupJoinStatus]。
  /// 1000=未加入；1001=普通成员（含 1002+ 管理员）；1005=申请中。
  @JsonKey(name: 'member_role')
  int? get memberRole => throw _privateConstructorUsedError;

  /// 未加入时展示的申请说明（管理员留言）。
  @JsonKey(name: 'joining_guide')
  GroupGuide? get joiningGuide => throw _privateConstructorUsedError;

  /// 加入成功后展示的欢迎语。
  @JsonKey(name: 'joined_guide')
  GroupGuide? get joinedGuide => throw _privateConstructorUsedError;
  Author? get owner => throw _privateConstructorUsedError;

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
  @useResult
  $Res call({
    String id,
    String name,
    String? avatar,
    @JsonKey(name: 'large_avatar') String? largeAvatar,
    String? desc,
    @JsonKey(name: 'desc_abstract') String? descAbstract,
    String? subtitle,
    String? slogan,
    @JsonKey(name: 'member_count') int? memberCount,
    @JsonKey(name: 'member_count_text') String? memberCountText,
    @JsonKey(name: 'member_name') String? memberName,
    @JsonKey(name: 'topic_count') int? topicCount,
    @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson) bool? isSubscribed,
    @JsonKey(name: 'is_official', fromJson: _boolFromJson) bool? isOfficial,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'background_mask_color') String? backgroundMaskColor,
    @JsonKey(name: 'rules_desc') String? rulesDesc,
    @JsonKey(name: 'group_tabs') List<GroupTab>? groupTabs,
    @JsonKey(name: 'feed_tags') List<FeedTag>? feedTags,
    @JsonKey(name: 'join_type') String? joinType,
    @JsonKey(name: 'member_role') int? memberRole,
    @JsonKey(name: 'joining_guide') GroupGuide? joiningGuide,
    @JsonKey(name: 'joined_guide') GroupGuide? joinedGuide,
    Author? owner,
  });

  $GroupGuideCopyWith<$Res>? get joiningGuide;
  $GroupGuideCopyWith<$Res>? get joinedGuide;
  $AuthorCopyWith<$Res>? get owner;
}

/// @nodoc
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? largeAvatar = freezed,
    Object? desc = freezed,
    Object? descAbstract = freezed,
    Object? subtitle = freezed,
    Object? slogan = freezed,
    Object? memberCount = freezed,
    Object? memberCountText = freezed,
    Object? memberName = freezed,
    Object? topicCount = freezed,
    Object? isSubscribed = freezed,
    Object? isOfficial = freezed,
    Object? sharingUrl = freezed,
    Object? backgroundMaskColor = freezed,
    Object? rulesDesc = freezed,
    Object? groupTabs = freezed,
    Object? feedTags = freezed,
    Object? joinType = freezed,
    Object? memberRole = freezed,
    Object? joiningGuide = freezed,
    Object? joinedGuide = freezed,
    Object? owner = freezed,
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
            avatar: freezed == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            largeAvatar: freezed == largeAvatar
                ? _value.largeAvatar
                : largeAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            desc: freezed == desc
                ? _value.desc
                : desc // ignore: cast_nullable_to_non_nullable
                      as String?,
            descAbstract: freezed == descAbstract
                ? _value.descAbstract
                : descAbstract // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            slogan: freezed == slogan
                ? _value.slogan
                : slogan // ignore: cast_nullable_to_non_nullable
                      as String?,
            memberCount: freezed == memberCount
                ? _value.memberCount
                : memberCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            memberCountText: freezed == memberCountText
                ? _value.memberCountText
                : memberCountText // ignore: cast_nullable_to_non_nullable
                      as String?,
            memberName: freezed == memberName
                ? _value.memberName
                : memberName // ignore: cast_nullable_to_non_nullable
                      as String?,
            topicCount: freezed == topicCount
                ? _value.topicCount
                : topicCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            isSubscribed: freezed == isSubscribed
                ? _value.isSubscribed
                : isSubscribed // ignore: cast_nullable_to_non_nullable
                      as bool?,
            isOfficial: freezed == isOfficial
                ? _value.isOfficial
                : isOfficial // ignore: cast_nullable_to_non_nullable
                      as bool?,
            sharingUrl: freezed == sharingUrl
                ? _value.sharingUrl
                : sharingUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            backgroundMaskColor: freezed == backgroundMaskColor
                ? _value.backgroundMaskColor
                : backgroundMaskColor // ignore: cast_nullable_to_non_nullable
                      as String?,
            rulesDesc: freezed == rulesDesc
                ? _value.rulesDesc
                : rulesDesc // ignore: cast_nullable_to_non_nullable
                      as String?,
            groupTabs: freezed == groupTabs
                ? _value.groupTabs
                : groupTabs // ignore: cast_nullable_to_non_nullable
                      as List<GroupTab>?,
            feedTags: freezed == feedTags
                ? _value.feedTags
                : feedTags // ignore: cast_nullable_to_non_nullable
                      as List<FeedTag>?,
            joinType: freezed == joinType
                ? _value.joinType
                : joinType // ignore: cast_nullable_to_non_nullable
                      as String?,
            memberRole: freezed == memberRole
                ? _value.memberRole
                : memberRole // ignore: cast_nullable_to_non_nullable
                      as int?,
            joiningGuide: freezed == joiningGuide
                ? _value.joiningGuide
                : joiningGuide // ignore: cast_nullable_to_non_nullable
                      as GroupGuide?,
            joinedGuide: freezed == joinedGuide
                ? _value.joinedGuide
                : joinedGuide // ignore: cast_nullable_to_non_nullable
                      as GroupGuide?,
            owner: freezed == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as Author?,
          )
          as $Val,
    );
  }

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupGuideCopyWith<$Res>? get joiningGuide {
    if (_value.joiningGuide == null) {
      return null;
    }

    return $GroupGuideCopyWith<$Res>(_value.joiningGuide!, (value) {
      return _then(_value.copyWith(joiningGuide: value) as $Val);
    });
  }

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupGuideCopyWith<$Res>? get joinedGuide {
    if (_value.joinedGuide == null) {
      return null;
    }

    return $GroupGuideCopyWith<$Res>(_value.joinedGuide!, (value) {
      return _then(_value.copyWith(joinedGuide: value) as $Val);
    });
  }

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorCopyWith<$Res>? get owner {
    if (_value.owner == null) {
      return null;
    }

    return $AuthorCopyWith<$Res>(_value.owner!, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$GroupImplCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$GroupImplCopyWith(
    _$GroupImpl value,
    $Res Function(_$GroupImpl) then,
  ) = __$$GroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? avatar,
    @JsonKey(name: 'large_avatar') String? largeAvatar,
    String? desc,
    @JsonKey(name: 'desc_abstract') String? descAbstract,
    String? subtitle,
    String? slogan,
    @JsonKey(name: 'member_count') int? memberCount,
    @JsonKey(name: 'member_count_text') String? memberCountText,
    @JsonKey(name: 'member_name') String? memberName,
    @JsonKey(name: 'topic_count') int? topicCount,
    @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson) bool? isSubscribed,
    @JsonKey(name: 'is_official', fromJson: _boolFromJson) bool? isOfficial,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'background_mask_color') String? backgroundMaskColor,
    @JsonKey(name: 'rules_desc') String? rulesDesc,
    @JsonKey(name: 'group_tabs') List<GroupTab>? groupTabs,
    @JsonKey(name: 'feed_tags') List<FeedTag>? feedTags,
    @JsonKey(name: 'join_type') String? joinType,
    @JsonKey(name: 'member_role') int? memberRole,
    @JsonKey(name: 'joining_guide') GroupGuide? joiningGuide,
    @JsonKey(name: 'joined_guide') GroupGuide? joinedGuide,
    Author? owner,
  });

  @override
  $GroupGuideCopyWith<$Res>? get joiningGuide;
  @override
  $GroupGuideCopyWith<$Res>? get joinedGuide;
  @override
  $AuthorCopyWith<$Res>? get owner;
}

/// @nodoc
class __$$GroupImplCopyWithImpl<$Res>
    extends _$GroupCopyWithImpl<$Res, _$GroupImpl>
    implements _$$GroupImplCopyWith<$Res> {
  __$$GroupImplCopyWithImpl(
    _$GroupImpl _value,
    $Res Function(_$GroupImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? largeAvatar = freezed,
    Object? desc = freezed,
    Object? descAbstract = freezed,
    Object? subtitle = freezed,
    Object? slogan = freezed,
    Object? memberCount = freezed,
    Object? memberCountText = freezed,
    Object? memberName = freezed,
    Object? topicCount = freezed,
    Object? isSubscribed = freezed,
    Object? isOfficial = freezed,
    Object? sharingUrl = freezed,
    Object? backgroundMaskColor = freezed,
    Object? rulesDesc = freezed,
    Object? groupTabs = freezed,
    Object? feedTags = freezed,
    Object? joinType = freezed,
    Object? memberRole = freezed,
    Object? joiningGuide = freezed,
    Object? joinedGuide = freezed,
    Object? owner = freezed,
  }) {
    return _then(
      _$GroupImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: freezed == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        largeAvatar: freezed == largeAvatar
            ? _value.largeAvatar
            : largeAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        desc: freezed == desc
            ? _value.desc
            : desc // ignore: cast_nullable_to_non_nullable
                  as String?,
        descAbstract: freezed == descAbstract
            ? _value.descAbstract
            : descAbstract // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        slogan: freezed == slogan
            ? _value.slogan
            : slogan // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberCount: freezed == memberCount
            ? _value.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        memberCountText: freezed == memberCountText
            ? _value.memberCountText
            : memberCountText // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberName: freezed == memberName
            ? _value.memberName
            : memberName // ignore: cast_nullable_to_non_nullable
                  as String?,
        topicCount: freezed == topicCount
            ? _value.topicCount
            : topicCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        isSubscribed: freezed == isSubscribed
            ? _value.isSubscribed
            : isSubscribed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        isOfficial: freezed == isOfficial
            ? _value.isOfficial
            : isOfficial // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sharingUrl: freezed == sharingUrl
            ? _value.sharingUrl
            : sharingUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        backgroundMaskColor: freezed == backgroundMaskColor
            ? _value.backgroundMaskColor
            : backgroundMaskColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        rulesDesc: freezed == rulesDesc
            ? _value.rulesDesc
            : rulesDesc // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupTabs: freezed == groupTabs
            ? _value._groupTabs
            : groupTabs // ignore: cast_nullable_to_non_nullable
                  as List<GroupTab>?,
        feedTags: freezed == feedTags
            ? _value._feedTags
            : feedTags // ignore: cast_nullable_to_non_nullable
                  as List<FeedTag>?,
        joinType: freezed == joinType
            ? _value.joinType
            : joinType // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberRole: freezed == memberRole
            ? _value.memberRole
            : memberRole // ignore: cast_nullable_to_non_nullable
                  as int?,
        joiningGuide: freezed == joiningGuide
            ? _value.joiningGuide
            : joiningGuide // ignore: cast_nullable_to_non_nullable
                  as GroupGuide?,
        joinedGuide: freezed == joinedGuide
            ? _value.joinedGuide
            : joinedGuide // ignore: cast_nullable_to_non_nullable
                  as GroupGuide?,
        owner: freezed == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as Author?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupImpl extends _Group {
  const _$GroupImpl({
    required this.id,
    required this.name,
    this.avatar,
    @JsonKey(name: 'large_avatar') this.largeAvatar,
    this.desc,
    @JsonKey(name: 'desc_abstract') this.descAbstract,
    this.subtitle,
    this.slogan,
    @JsonKey(name: 'member_count') this.memberCount,
    @JsonKey(name: 'member_count_text') this.memberCountText,
    @JsonKey(name: 'member_name') this.memberName,
    @JsonKey(name: 'topic_count') this.topicCount,
    @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson) this.isSubscribed,
    @JsonKey(name: 'is_official', fromJson: _boolFromJson) this.isOfficial,
    @JsonKey(name: 'sharing_url') this.sharingUrl,
    @JsonKey(name: 'background_mask_color') this.backgroundMaskColor,
    @JsonKey(name: 'rules_desc') this.rulesDesc,
    @JsonKey(name: 'group_tabs') final List<GroupTab>? groupTabs,
    @JsonKey(name: 'feed_tags') final List<FeedTag>? feedTags,
    @JsonKey(name: 'join_type') this.joinType,
    @JsonKey(name: 'member_role') this.memberRole,
    @JsonKey(name: 'joining_guide') this.joiningGuide,
    @JsonKey(name: 'joined_guide') this.joinedGuide,
    this.owner,
  }) : _groupTabs = groupTabs,
       _feedTags = feedTags,
       super._();

  factory _$GroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatar;
  @override
  @JsonKey(name: 'large_avatar')
  final String? largeAvatar;
  @override
  final String? desc;
  @override
  @JsonKey(name: 'desc_abstract')
  final String? descAbstract;
  @override
  final String? subtitle;
  @override
  final String? slogan;
  @override
  @JsonKey(name: 'member_count')
  final int? memberCount;
  @override
  @JsonKey(name: 'member_count_text')
  final String? memberCountText;
  @override
  @JsonKey(name: 'member_name')
  final String? memberName;
  @override
  @JsonKey(name: 'topic_count')
  final int? topicCount;
  // 部分接口（如 recommend_feed 的 owner）把这些字段返成 0/1 整数而非布尔，
  // 用 [_boolFromJson] 容错，否则 `int as bool?` 会抛类型错误。
  @override
  @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson)
  final bool? isSubscribed;
  @override
  @JsonKey(name: 'is_official', fromJson: _boolFromJson)
  final bool? isOfficial;
  @override
  @JsonKey(name: 'sharing_url')
  final String? sharingUrl;
  @override
  @JsonKey(name: 'background_mask_color')
  final String? backgroundMaskColor;
  @override
  @JsonKey(name: 'rules_desc')
  final String? rulesDesc;
  final List<GroupTab>? _groupTabs;
  @override
  @JsonKey(name: 'group_tabs')
  List<GroupTab>? get groupTabs {
    final value = _groupTabs;
    if (value == null) return null;
    if (_groupTabs is EqualUnmodifiableListView) return _groupTabs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<FeedTag>? _feedTags;
  @override
  @JsonKey(name: 'feed_tags')
  List<FeedTag>? get feedTags {
    final value = _feedTags;
    if (value == null) return null;
    if (_feedTags is EqualUnmodifiableListView) return _feedTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// 小组本身的加入方式：'A'=自动通过；'R'=需要填写申请理由审核。
  /// 注意：这反映的是小组规则，**不是**当前用户是否已加入。
  @override
  @JsonKey(name: 'join_type')
  final String? joinType;

  /// 当前用户在该小组的角色 / 加入状态。详见 [GroupJoinStatus]。
  /// 1000=未加入；1001=普通成员（含 1002+ 管理员）；1005=申请中。
  @override
  @JsonKey(name: 'member_role')
  final int? memberRole;

  /// 未加入时展示的申请说明（管理员留言）。
  @override
  @JsonKey(name: 'joining_guide')
  final GroupGuide? joiningGuide;

  /// 加入成功后展示的欢迎语。
  @override
  @JsonKey(name: 'joined_guide')
  final GroupGuide? joinedGuide;
  @override
  final Author? owner;

  @override
  String toString() {
    return 'Group(id: $id, name: $name, avatar: $avatar, largeAvatar: $largeAvatar, desc: $desc, descAbstract: $descAbstract, subtitle: $subtitle, slogan: $slogan, memberCount: $memberCount, memberCountText: $memberCountText, memberName: $memberName, topicCount: $topicCount, isSubscribed: $isSubscribed, isOfficial: $isOfficial, sharingUrl: $sharingUrl, backgroundMaskColor: $backgroundMaskColor, rulesDesc: $rulesDesc, groupTabs: $groupTabs, feedTags: $feedTags, joinType: $joinType, memberRole: $memberRole, joiningGuide: $joiningGuide, joinedGuide: $joinedGuide, owner: $owner)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.largeAvatar, largeAvatar) ||
                other.largeAvatar == largeAvatar) &&
            (identical(other.desc, desc) || other.desc == desc) &&
            (identical(other.descAbstract, descAbstract) ||
                other.descAbstract == descAbstract) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.slogan, slogan) || other.slogan == slogan) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.memberCountText, memberCountText) ||
                other.memberCountText == memberCountText) &&
            (identical(other.memberName, memberName) ||
                other.memberName == memberName) &&
            (identical(other.topicCount, topicCount) ||
                other.topicCount == topicCount) &&
            (identical(other.isSubscribed, isSubscribed) ||
                other.isSubscribed == isSubscribed) &&
            (identical(other.isOfficial, isOfficial) ||
                other.isOfficial == isOfficial) &&
            (identical(other.sharingUrl, sharingUrl) ||
                other.sharingUrl == sharingUrl) &&
            (identical(other.backgroundMaskColor, backgroundMaskColor) ||
                other.backgroundMaskColor == backgroundMaskColor) &&
            (identical(other.rulesDesc, rulesDesc) ||
                other.rulesDesc == rulesDesc) &&
            const DeepCollectionEquality().equals(
              other._groupTabs,
              _groupTabs,
            ) &&
            const DeepCollectionEquality().equals(other._feedTags, _feedTags) &&
            (identical(other.joinType, joinType) ||
                other.joinType == joinType) &&
            (identical(other.memberRole, memberRole) ||
                other.memberRole == memberRole) &&
            (identical(other.joiningGuide, joiningGuide) ||
                other.joiningGuide == joiningGuide) &&
            (identical(other.joinedGuide, joinedGuide) ||
                other.joinedGuide == joinedGuide) &&
            (identical(other.owner, owner) || other.owner == owner));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    avatar,
    largeAvatar,
    desc,
    descAbstract,
    subtitle,
    slogan,
    memberCount,
    memberCountText,
    memberName,
    topicCount,
    isSubscribed,
    isOfficial,
    sharingUrl,
    backgroundMaskColor,
    rulesDesc,
    const DeepCollectionEquality().hash(_groupTabs),
    const DeepCollectionEquality().hash(_feedTags),
    joinType,
    memberRole,
    joiningGuide,
    joinedGuide,
    owner,
  ]);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      __$$GroupImplCopyWithImpl<_$GroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupImplToJson(this);
  }
}

abstract class _Group extends Group {
  const factory _Group({
    required final String id,
    required final String name,
    final String? avatar,
    @JsonKey(name: 'large_avatar') final String? largeAvatar,
    final String? desc,
    @JsonKey(name: 'desc_abstract') final String? descAbstract,
    final String? subtitle,
    final String? slogan,
    @JsonKey(name: 'member_count') final int? memberCount,
    @JsonKey(name: 'member_count_text') final String? memberCountText,
    @JsonKey(name: 'member_name') final String? memberName,
    @JsonKey(name: 'topic_count') final int? topicCount,
    @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson)
    final bool? isSubscribed,
    @JsonKey(name: 'is_official', fromJson: _boolFromJson)
    final bool? isOfficial,
    @JsonKey(name: 'sharing_url') final String? sharingUrl,
    @JsonKey(name: 'background_mask_color') final String? backgroundMaskColor,
    @JsonKey(name: 'rules_desc') final String? rulesDesc,
    @JsonKey(name: 'group_tabs') final List<GroupTab>? groupTabs,
    @JsonKey(name: 'feed_tags') final List<FeedTag>? feedTags,
    @JsonKey(name: 'join_type') final String? joinType,
    @JsonKey(name: 'member_role') final int? memberRole,
    @JsonKey(name: 'joining_guide') final GroupGuide? joiningGuide,
    @JsonKey(name: 'joined_guide') final GroupGuide? joinedGuide,
    final Author? owner,
  }) = _$GroupImpl;
  const _Group._() : super._();

  factory _Group.fromJson(Map<String, dynamic> json) = _$GroupImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatar;
  @override
  @JsonKey(name: 'large_avatar')
  String? get largeAvatar;
  @override
  String? get desc;
  @override
  @JsonKey(name: 'desc_abstract')
  String? get descAbstract;
  @override
  String? get subtitle;
  @override
  String? get slogan;
  @override
  @JsonKey(name: 'member_count')
  int? get memberCount;
  @override
  @JsonKey(name: 'member_count_text')
  String? get memberCountText;
  @override
  @JsonKey(name: 'member_name')
  String? get memberName;
  @override
  @JsonKey(name: 'topic_count')
  int? get topicCount; // 部分接口（如 recommend_feed 的 owner）把这些字段返成 0/1 整数而非布尔，
  // 用 [_boolFromJson] 容错，否则 `int as bool?` 会抛类型错误。
  @override
  @JsonKey(name: 'is_subscribed', fromJson: _boolFromJson)
  bool? get isSubscribed;
  @override
  @JsonKey(name: 'is_official', fromJson: _boolFromJson)
  bool? get isOfficial;
  @override
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl;
  @override
  @JsonKey(name: 'background_mask_color')
  String? get backgroundMaskColor;
  @override
  @JsonKey(name: 'rules_desc')
  String? get rulesDesc;
  @override
  @JsonKey(name: 'group_tabs')
  List<GroupTab>? get groupTabs;
  @override
  @JsonKey(name: 'feed_tags')
  List<FeedTag>? get feedTags;

  /// 小组本身的加入方式：'A'=自动通过；'R'=需要填写申请理由审核。
  /// 注意：这反映的是小组规则，**不是**当前用户是否已加入。
  @override
  @JsonKey(name: 'join_type')
  String? get joinType;

  /// 当前用户在该小组的角色 / 加入状态。详见 [GroupJoinStatus]。
  /// 1000=未加入；1001=普通成员（含 1002+ 管理员）；1005=申请中。
  @override
  @JsonKey(name: 'member_role')
  int? get memberRole;

  /// 未加入时展示的申请说明（管理员留言）。
  @override
  @JsonKey(name: 'joining_guide')
  GroupGuide? get joiningGuide;

  /// 加入成功后展示的欢迎语。
  @override
  @JsonKey(name: 'joined_guide')
  GroupGuide? get joinedGuide;
  @override
  Author? get owner;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupTab _$GroupTabFromJson(Map<String, dynamic> json) {
  return _GroupTab.fromJson(json);
}

/// @nodoc
mixin _$GroupTab {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;
  int? get seq => throw _privateConstructorUsedError;

  /// Serializes this GroupTab to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupTab
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupTabCopyWith<GroupTab> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupTabCopyWith<$Res> {
  factory $GroupTabCopyWith(GroupTab value, $Res Function(GroupTab) then) =
      _$GroupTabCopyWithImpl<$Res, GroupTab>;
  @useResult
  $Res call({String id, String name, String? type, String? uri, int? seq});
}

/// @nodoc
class _$GroupTabCopyWithImpl<$Res, $Val extends GroupTab>
    implements $GroupTabCopyWith<$Res> {
  _$GroupTabCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupTab
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? uri = freezed,
    Object? seq = freezed,
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
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
            seq: freezed == seq
                ? _value.seq
                : seq // ignore: cast_nullable_to_non_nullable
                      as int?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupTabImplCopyWith<$Res>
    implements $GroupTabCopyWith<$Res> {
  factory _$$GroupTabImplCopyWith(
    _$GroupTabImpl value,
    $Res Function(_$GroupTabImpl) then,
  ) = __$$GroupTabImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? type, String? uri, int? seq});
}

/// @nodoc
class __$$GroupTabImplCopyWithImpl<$Res>
    extends _$GroupTabCopyWithImpl<$Res, _$GroupTabImpl>
    implements _$$GroupTabImplCopyWith<$Res> {
  __$$GroupTabImplCopyWithImpl(
    _$GroupTabImpl _value,
    $Res Function(_$GroupTabImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupTab
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = freezed,
    Object? uri = freezed,
    Object? seq = freezed,
  }) {
    return _then(
      _$GroupTabImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
        seq: freezed == seq
            ? _value.seq
            : seq // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupTabImpl implements _GroupTab {
  const _$GroupTabImpl({
    required this.id,
    required this.name,
    this.type,
    this.uri,
    this.seq,
  });

  factory _$GroupTabImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupTabImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? type;
  @override
  final String? uri;
  @override
  final int? seq;

  @override
  String toString() {
    return 'GroupTab(id: $id, name: $name, type: $type, uri: $uri, seq: $seq)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupTabImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.seq, seq) || other.seq == seq));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, type, uri, seq);

  /// Create a copy of GroupTab
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupTabImplCopyWith<_$GroupTabImpl> get copyWith =>
      __$$GroupTabImplCopyWithImpl<_$GroupTabImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupTabImplToJson(this);
  }
}

abstract class _GroupTab implements GroupTab {
  const factory _GroupTab({
    required final String id,
    required final String name,
    final String? type,
    final String? uri,
    final int? seq,
  }) = _$GroupTabImpl;

  factory _GroupTab.fromJson(Map<String, dynamic> json) =
      _$GroupTabImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get type;
  @override
  String? get uri;
  @override
  int? get seq;

  /// Create a copy of GroupTab
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupTabImplCopyWith<_$GroupTabImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GroupGuide _$GroupGuideFromJson(Map<String, dynamic> json) {
  return _GroupGuide.fromJson(json);
}

/// @nodoc
mixin _$GroupGuide {
  String? get text => throw _privateConstructorUsedError;
  List<String>? get links => throw _privateConstructorUsedError;

  /// Serializes this GroupGuide to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupGuide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupGuideCopyWith<GroupGuide> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupGuideCopyWith<$Res> {
  factory $GroupGuideCopyWith(
    GroupGuide value,
    $Res Function(GroupGuide) then,
  ) = _$GroupGuideCopyWithImpl<$Res, GroupGuide>;
  @useResult
  $Res call({String? text, List<String>? links});
}

/// @nodoc
class _$GroupGuideCopyWithImpl<$Res, $Val extends GroupGuide>
    implements $GroupGuideCopyWith<$Res> {
  _$GroupGuideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupGuide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = freezed, Object? links = freezed}) {
    return _then(
      _value.copyWith(
            text: freezed == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String?,
            links: freezed == links
                ? _value.links
                : links // ignore: cast_nullable_to_non_nullable
                      as List<String>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$GroupGuideImplCopyWith<$Res>
    implements $GroupGuideCopyWith<$Res> {
  factory _$$GroupGuideImplCopyWith(
    _$GroupGuideImpl value,
    $Res Function(_$GroupGuideImpl) then,
  ) = __$$GroupGuideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? text, List<String>? links});
}

/// @nodoc
class __$$GroupGuideImplCopyWithImpl<$Res>
    extends _$GroupGuideCopyWithImpl<$Res, _$GroupGuideImpl>
    implements _$$GroupGuideImplCopyWith<$Res> {
  __$$GroupGuideImplCopyWithImpl(
    _$GroupGuideImpl _value,
    $Res Function(_$GroupGuideImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of GroupGuide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? text = freezed, Object? links = freezed}) {
    return _then(
      _$GroupGuideImpl(
        text: freezed == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
        links: freezed == links
            ? _value._links
            : links // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupGuideImpl implements _GroupGuide {
  const _$GroupGuideImpl({this.text, final List<String>? links})
    : _links = links;

  factory _$GroupGuideImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupGuideImplFromJson(json);

  @override
  final String? text;
  final List<String>? _links;
  @override
  List<String>? get links {
    final value = _links;
    if (value == null) return null;
    if (_links is EqualUnmodifiableListView) return _links;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GroupGuide(text: $text, links: $links)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupGuideImpl &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._links, _links));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    text,
    const DeepCollectionEquality().hash(_links),
  );

  /// Create a copy of GroupGuide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupGuideImplCopyWith<_$GroupGuideImpl> get copyWith =>
      __$$GroupGuideImplCopyWithImpl<_$GroupGuideImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupGuideImplToJson(this);
  }
}

abstract class _GroupGuide implements GroupGuide {
  const factory _GroupGuide({final String? text, final List<String>? links}) =
      _$GroupGuideImpl;

  factory _GroupGuide.fromJson(Map<String, dynamic> json) =
      _$GroupGuideImpl.fromJson;

  @override
  String? get text;
  @override
  List<String>? get links;

  /// Create a copy of GroupGuide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupGuideImplCopyWith<_$GroupGuideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FeedTag _$FeedTagFromJson(Map<String, dynamic> json) {
  return _FeedTag.fromJson(json);
}

/// @nodoc
mixin _$FeedTag {
  String get sortby => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;

  /// Serializes this FeedTag to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FeedTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedTagCopyWith<FeedTag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedTagCopyWith<$Res> {
  factory $FeedTagCopyWith(FeedTag value, $Res Function(FeedTag) then) =
      _$FeedTagCopyWithImpl<$Res, FeedTag>;
  @useResult
  $Res call({String sortby, String title});
}

/// @nodoc
class _$FeedTagCopyWithImpl<$Res, $Val extends FeedTag>
    implements $FeedTagCopyWith<$Res> {
  _$FeedTagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sortby = null, Object? title = null}) {
    return _then(
      _value.copyWith(
            sortby: null == sortby
                ? _value.sortby
                : sortby // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FeedTagImplCopyWith<$Res> implements $FeedTagCopyWith<$Res> {
  factory _$$FeedTagImplCopyWith(
    _$FeedTagImpl value,
    $Res Function(_$FeedTagImpl) then,
  ) = __$$FeedTagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String sortby, String title});
}

/// @nodoc
class __$$FeedTagImplCopyWithImpl<$Res>
    extends _$FeedTagCopyWithImpl<$Res, _$FeedTagImpl>
    implements _$$FeedTagImplCopyWith<$Res> {
  __$$FeedTagImplCopyWithImpl(
    _$FeedTagImpl _value,
    $Res Function(_$FeedTagImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedTag
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? sortby = null, Object? title = null}) {
    return _then(
      _$FeedTagImpl(
        sortby: null == sortby
            ? _value.sortby
            : sortby // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FeedTagImpl implements _FeedTag {
  const _$FeedTagImpl({required this.sortby, required this.title});

  factory _$FeedTagImpl.fromJson(Map<String, dynamic> json) =>
      _$$FeedTagImplFromJson(json);

  @override
  final String sortby;
  @override
  final String title;

  @override
  String toString() {
    return 'FeedTag(sortby: $sortby, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedTagImpl &&
            (identical(other.sortby, sortby) || other.sortby == sortby) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sortby, title);

  /// Create a copy of FeedTag
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedTagImplCopyWith<_$FeedTagImpl> get copyWith =>
      __$$FeedTagImplCopyWithImpl<_$FeedTagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FeedTagImplToJson(this);
  }
}

abstract class _FeedTag implements FeedTag {
  const factory _FeedTag({
    required final String sortby,
    required final String title,
  }) = _$FeedTagImpl;

  factory _FeedTag.fromJson(Map<String, dynamic> json) = _$FeedTagImpl.fromJson;

  @override
  String get sortby;
  @override
  String get title;

  /// Create a copy of FeedTag
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedTagImplCopyWith<_$FeedTagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
