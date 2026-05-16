// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'collection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Collection _$CollectionFromJson(Map<String, dynamic> json) {
  return _Collection.fromJson(json);
}

/// @nodoc
mixin _$Collection {
  Doulist get doulist => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;

  /// Serializes this Collection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Collection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CollectionCopyWith<Collection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CollectionCopyWith<$Res> {
  factory $CollectionCopyWith(
    Collection value,
    $Res Function(Collection) then,
  ) = _$CollectionCopyWithImpl<$Res, Collection>;
  @useResult
  $Res call({Doulist doulist, String time});

  $DoulistCopyWith<$Res> get doulist;
}

/// @nodoc
class _$CollectionCopyWithImpl<$Res, $Val extends Collection>
    implements $CollectionCopyWith<$Res> {
  _$CollectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Collection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? doulist = null, Object? time = null}) {
    return _then(
      _value.copyWith(
            doulist: null == doulist
                ? _value.doulist
                : doulist // ignore: cast_nullable_to_non_nullable
                      as Doulist,
            time: null == time
                ? _value.time
                : time // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of Collection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $DoulistCopyWith<$Res> get doulist {
    return $DoulistCopyWith<$Res>(_value.doulist, (value) {
      return _then(_value.copyWith(doulist: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CollectionImplCopyWith<$Res>
    implements $CollectionCopyWith<$Res> {
  factory _$$CollectionImplCopyWith(
    _$CollectionImpl value,
    $Res Function(_$CollectionImpl) then,
  ) = __$$CollectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Doulist doulist, String time});

  @override
  $DoulistCopyWith<$Res> get doulist;
}

/// @nodoc
class __$$CollectionImplCopyWithImpl<$Res>
    extends _$CollectionCopyWithImpl<$Res, _$CollectionImpl>
    implements _$$CollectionImplCopyWith<$Res> {
  __$$CollectionImplCopyWithImpl(
    _$CollectionImpl _value,
    $Res Function(_$CollectionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Collection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? doulist = null, Object? time = null}) {
    return _then(
      _$CollectionImpl(
        doulist: null == doulist
            ? _value.doulist
            : doulist // ignore: cast_nullable_to_non_nullable
                  as Doulist,
        time: null == time
            ? _value.time
            : time // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CollectionImpl implements _Collection {
  const _$CollectionImpl({required this.doulist, required this.time});

  factory _$CollectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CollectionImplFromJson(json);

  @override
  final Doulist doulist;
  @override
  final String time;

  @override
  String toString() {
    return 'Collection(doulist: $doulist, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CollectionImpl &&
            (identical(other.doulist, doulist) || other.doulist == doulist) &&
            (identical(other.time, time) || other.time == time));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, doulist, time);

  /// Create a copy of Collection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CollectionImplCopyWith<_$CollectionImpl> get copyWith =>
      __$$CollectionImplCopyWithImpl<_$CollectionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CollectionImplToJson(this);
  }
}

abstract class _Collection implements Collection {
  const factory _Collection({
    required final Doulist doulist,
    required final String time,
  }) = _$CollectionImpl;

  factory _Collection.fromJson(Map<String, dynamic> json) =
      _$CollectionImpl.fromJson;

  @override
  Doulist get doulist;
  @override
  String get time;

  /// Create a copy of Collection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CollectionImplCopyWith<_$CollectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Doulist _$DoulistFromJson(Map<String, dynamic> json) {
  return _Doulist.fromJson(json);
}

/// @nodoc
mixin _$Doulist {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Author get owner => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'list_type')
  String? get listType => throw _privateConstructorUsedError;
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'cover_url')
  String? get coverUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_count')
  int? get itemsCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'followers_count')
  int? get followersCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_private')
  bool? get isPrivate => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  @JsonKey(name: 'create_time')
  String? get createTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'update_time')
  String? get updateTime => throw _privateConstructorUsedError;

  /// Serializes this Doulist to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Doulist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DoulistCopyWith<Doulist> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DoulistCopyWith<$Res> {
  factory $DoulistCopyWith(Doulist value, $Res Function(Doulist) then) =
      _$DoulistCopyWithImpl<$Res, Doulist>;
  @useResult
  $Res call({
    String id,
    String title,
    Author owner,
    String? uri,
    String? url,
    String? type,
    @JsonKey(name: 'list_type') String? listType,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'items_count') int? itemsCount,
    @JsonKey(name: 'followers_count') int? followersCount,
    @JsonKey(name: 'is_private') bool? isPrivate,
    String? category,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'update_time') String? updateTime,
  });

  $AuthorCopyWith<$Res> get owner;
}

/// @nodoc
class _$DoulistCopyWithImpl<$Res, $Val extends Doulist>
    implements $DoulistCopyWith<$Res> {
  _$DoulistCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Doulist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? owner = null,
    Object? uri = freezed,
    Object? url = freezed,
    Object? type = freezed,
    Object? listType = freezed,
    Object? sharingUrl = freezed,
    Object? coverUrl = freezed,
    Object? itemsCount = freezed,
    Object? followersCount = freezed,
    Object? isPrivate = freezed,
    Object? category = freezed,
    Object? createTime = freezed,
    Object? updateTime = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            owner: null == owner
                ? _value.owner
                : owner // ignore: cast_nullable_to_non_nullable
                      as Author,
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
            url: freezed == url
                ? _value.url
                : url // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            listType: freezed == listType
                ? _value.listType
                : listType // ignore: cast_nullable_to_non_nullable
                      as String?,
            sharingUrl: freezed == sharingUrl
                ? _value.sharingUrl
                : sharingUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            coverUrl: freezed == coverUrl
                ? _value.coverUrl
                : coverUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            itemsCount: freezed == itemsCount
                ? _value.itemsCount
                : itemsCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            followersCount: freezed == followersCount
                ? _value.followersCount
                : followersCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            isPrivate: freezed == isPrivate
                ? _value.isPrivate
                : isPrivate // ignore: cast_nullable_to_non_nullable
                      as bool?,
            category: freezed == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String?,
            createTime: freezed == createTime
                ? _value.createTime
                : createTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            updateTime: freezed == updateTime
                ? _value.updateTime
                : updateTime // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of Doulist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AuthorCopyWith<$Res> get owner {
    return $AuthorCopyWith<$Res>(_value.owner, (value) {
      return _then(_value.copyWith(owner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DoulistImplCopyWith<$Res> implements $DoulistCopyWith<$Res> {
  factory _$$DoulistImplCopyWith(
    _$DoulistImpl value,
    $Res Function(_$DoulistImpl) then,
  ) = __$$DoulistImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    Author owner,
    String? uri,
    String? url,
    String? type,
    @JsonKey(name: 'list_type') String? listType,
    @JsonKey(name: 'sharing_url') String? sharingUrl,
    @JsonKey(name: 'cover_url') String? coverUrl,
    @JsonKey(name: 'items_count') int? itemsCount,
    @JsonKey(name: 'followers_count') int? followersCount,
    @JsonKey(name: 'is_private') bool? isPrivate,
    String? category,
    @JsonKey(name: 'create_time') String? createTime,
    @JsonKey(name: 'update_time') String? updateTime,
  });

  @override
  $AuthorCopyWith<$Res> get owner;
}

/// @nodoc
class __$$DoulistImplCopyWithImpl<$Res>
    extends _$DoulistCopyWithImpl<$Res, _$DoulistImpl>
    implements _$$DoulistImplCopyWith<$Res> {
  __$$DoulistImplCopyWithImpl(
    _$DoulistImpl _value,
    $Res Function(_$DoulistImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Doulist
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? owner = null,
    Object? uri = freezed,
    Object? url = freezed,
    Object? type = freezed,
    Object? listType = freezed,
    Object? sharingUrl = freezed,
    Object? coverUrl = freezed,
    Object? itemsCount = freezed,
    Object? followersCount = freezed,
    Object? isPrivate = freezed,
    Object? category = freezed,
    Object? createTime = freezed,
    Object? updateTime = freezed,
  }) {
    return _then(
      _$DoulistImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        owner: null == owner
            ? _value.owner
            : owner // ignore: cast_nullable_to_non_nullable
                  as Author,
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
        url: freezed == url
            ? _value.url
            : url // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        listType: freezed == listType
            ? _value.listType
            : listType // ignore: cast_nullable_to_non_nullable
                  as String?,
        sharingUrl: freezed == sharingUrl
            ? _value.sharingUrl
            : sharingUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        coverUrl: freezed == coverUrl
            ? _value.coverUrl
            : coverUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        itemsCount: freezed == itemsCount
            ? _value.itemsCount
            : itemsCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        followersCount: freezed == followersCount
            ? _value.followersCount
            : followersCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        isPrivate: freezed == isPrivate
            ? _value.isPrivate
            : isPrivate // ignore: cast_nullable_to_non_nullable
                  as bool?,
        category: freezed == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String?,
        createTime: freezed == createTime
            ? _value.createTime
            : createTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        updateTime: freezed == updateTime
            ? _value.updateTime
            : updateTime // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DoulistImpl implements _Doulist {
  const _$DoulistImpl({
    required this.id,
    required this.title,
    required this.owner,
    this.uri,
    this.url,
    this.type,
    @JsonKey(name: 'list_type') this.listType,
    @JsonKey(name: 'sharing_url') this.sharingUrl,
    @JsonKey(name: 'cover_url') this.coverUrl,
    @JsonKey(name: 'items_count') this.itemsCount,
    @JsonKey(name: 'followers_count') this.followersCount,
    @JsonKey(name: 'is_private') this.isPrivate,
    this.category,
    @JsonKey(name: 'create_time') this.createTime,
    @JsonKey(name: 'update_time') this.updateTime,
  });

  factory _$DoulistImpl.fromJson(Map<String, dynamic> json) =>
      _$$DoulistImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final Author owner;
  @override
  final String? uri;
  @override
  final String? url;
  @override
  final String? type;
  @override
  @JsonKey(name: 'list_type')
  final String? listType;
  @override
  @JsonKey(name: 'sharing_url')
  final String? sharingUrl;
  @override
  @JsonKey(name: 'cover_url')
  final String? coverUrl;
  @override
  @JsonKey(name: 'items_count')
  final int? itemsCount;
  @override
  @JsonKey(name: 'followers_count')
  final int? followersCount;
  @override
  @JsonKey(name: 'is_private')
  final bool? isPrivate;
  @override
  final String? category;
  @override
  @JsonKey(name: 'create_time')
  final String? createTime;
  @override
  @JsonKey(name: 'update_time')
  final String? updateTime;

  @override
  String toString() {
    return 'Doulist(id: $id, title: $title, owner: $owner, uri: $uri, url: $url, type: $type, listType: $listType, sharingUrl: $sharingUrl, coverUrl: $coverUrl, itemsCount: $itemsCount, followersCount: $followersCount, isPrivate: $isPrivate, category: $category, createTime: $createTime, updateTime: $updateTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoulistImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.owner, owner) || other.owner == owner) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.listType, listType) ||
                other.listType == listType) &&
            (identical(other.sharingUrl, sharingUrl) ||
                other.sharingUrl == sharingUrl) &&
            (identical(other.coverUrl, coverUrl) ||
                other.coverUrl == coverUrl) &&
            (identical(other.itemsCount, itemsCount) ||
                other.itemsCount == itemsCount) &&
            (identical(other.followersCount, followersCount) ||
                other.followersCount == followersCount) &&
            (identical(other.isPrivate, isPrivate) ||
                other.isPrivate == isPrivate) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.createTime, createTime) ||
                other.createTime == createTime) &&
            (identical(other.updateTime, updateTime) ||
                other.updateTime == updateTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    owner,
    uri,
    url,
    type,
    listType,
    sharingUrl,
    coverUrl,
    itemsCount,
    followersCount,
    isPrivate,
    category,
    createTime,
    updateTime,
  );

  /// Create a copy of Doulist
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DoulistImplCopyWith<_$DoulistImpl> get copyWith =>
      __$$DoulistImplCopyWithImpl<_$DoulistImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DoulistImplToJson(this);
  }
}

abstract class _Doulist implements Doulist {
  const factory _Doulist({
    required final String id,
    required final String title,
    required final Author owner,
    final String? uri,
    final String? url,
    final String? type,
    @JsonKey(name: 'list_type') final String? listType,
    @JsonKey(name: 'sharing_url') final String? sharingUrl,
    @JsonKey(name: 'cover_url') final String? coverUrl,
    @JsonKey(name: 'items_count') final int? itemsCount,
    @JsonKey(name: 'followers_count') final int? followersCount,
    @JsonKey(name: 'is_private') final bool? isPrivate,
    final String? category,
    @JsonKey(name: 'create_time') final String? createTime,
    @JsonKey(name: 'update_time') final String? updateTime,
  }) = _$DoulistImpl;

  factory _Doulist.fromJson(Map<String, dynamic> json) = _$DoulistImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  Author get owner;
  @override
  String? get uri;
  @override
  String? get url;
  @override
  String? get type;
  @override
  @JsonKey(name: 'list_type')
  String? get listType;
  @override
  @JsonKey(name: 'sharing_url')
  String? get sharingUrl;
  @override
  @JsonKey(name: 'cover_url')
  String? get coverUrl;
  @override
  @JsonKey(name: 'items_count')
  int? get itemsCount;
  @override
  @JsonKey(name: 'followers_count')
  int? get followersCount;
  @override
  @JsonKey(name: 'is_private')
  bool? get isPrivate;
  @override
  String? get category;
  @override
  @JsonKey(name: 'create_time')
  String? get createTime;
  @override
  @JsonKey(name: 'update_time')
  String? get updateTime;

  /// Create a copy of Doulist
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DoulistImplCopyWith<_$DoulistImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
