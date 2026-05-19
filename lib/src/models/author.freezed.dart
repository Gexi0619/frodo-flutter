// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'author.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AuthorLoc _$AuthorLocFromJson(Map<String, dynamic> json) {
  return _AuthorLoc.fromJson(json);
}

/// @nodoc
mixin _$AuthorLoc {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get uid => throw _privateConstructorUsedError;

  /// Serializes this AuthorLoc to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthorLoc
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthorLocCopyWith<AuthorLoc> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthorLocCopyWith<$Res> {
  factory $AuthorLocCopyWith(AuthorLoc value, $Res Function(AuthorLoc) then) =
      _$AuthorLocCopyWithImpl<$Res, AuthorLoc>;
  @useResult
  $Res call({String id, String name, String? uid});
}

/// @nodoc
class _$AuthorLocCopyWithImpl<$Res, $Val extends AuthorLoc>
    implements $AuthorLocCopyWith<$Res> {
  _$AuthorLocCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthorLoc
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? uid = freezed}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AuthorLocImplCopyWith<$Res>
    implements $AuthorLocCopyWith<$Res> {
  factory _$$AuthorLocImplCopyWith(
    _$AuthorLocImpl value,
    $Res Function(_$AuthorLocImpl) then,
  ) = __$$AuthorLocImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? uid});
}

/// @nodoc
class __$$AuthorLocImplCopyWithImpl<$Res>
    extends _$AuthorLocCopyWithImpl<$Res, _$AuthorLocImpl>
    implements _$$AuthorLocImplCopyWith<$Res> {
  __$$AuthorLocImplCopyWithImpl(
    _$AuthorLocImpl _value,
    $Res Function(_$AuthorLocImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthorLoc
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null, Object? uid = freezed}) {
    return _then(
      _$AuthorLocImpl(
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
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthorLocImpl implements _AuthorLoc {
  const _$AuthorLocImpl({required this.id, required this.name, this.uid});

  factory _$AuthorLocImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthorLocImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? uid;

  @override
  String toString() {
    return 'AuthorLoc(id: $id, name: $name, uid: $uid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthorLocImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.uid, uid) || other.uid == uid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, uid);

  /// Create a copy of AuthorLoc
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthorLocImplCopyWith<_$AuthorLocImpl> get copyWith =>
      __$$AuthorLocImplCopyWithImpl<_$AuthorLocImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthorLocImplToJson(this);
  }
}

abstract class _AuthorLoc implements AuthorLoc {
  const factory _AuthorLoc({
    required final String id,
    required final String name,
    final String? uid,
  }) = _$AuthorLocImpl;

  factory _AuthorLoc.fromJson(Map<String, dynamic> json) =
      _$AuthorLocImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get uid;

  /// Create a copy of AuthorLoc
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthorLocImplCopyWith<_$AuthorLocImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Author _$AuthorFromJson(Map<String, dynamic> json) {
  return _Author.fromJson(json);
}

/// @nodoc
mixin _$Author {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get avatar => throw _privateConstructorUsedError;
  String? get uri => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get gender => throw _privateConstructorUsedError;
  @JsonKey(name: 'reg_time')
  String? get regTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'large_avatar')
  String? get largeAvatar => throw _privateConstructorUsedError;
  AuthorLoc? get loc => throw _privateConstructorUsedError;

  /// Serializes this Author to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Author
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthorCopyWith<Author> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthorCopyWith<$Res> {
  factory $AuthorCopyWith(Author value, $Res Function(Author) then) =
      _$AuthorCopyWithImpl<$Res, Author>;
  @useResult
  $Res call({
    String id,
    String name,
    String? avatar,
    String? uri,
    String? type,
    String? gender,
    @JsonKey(name: 'reg_time') String? regTime,
    @JsonKey(name: 'large_avatar') String? largeAvatar,
    AuthorLoc? loc,
  });

  $AuthorLocCopyWith<$Res>? get loc;
}

/// @nodoc
class _$AuthorCopyWithImpl<$Res, $Val extends Author>
    implements $AuthorCopyWith<$Res> {
  _$AuthorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Author
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? uri = freezed,
    Object? type = freezed,
    Object? gender = freezed,
    Object? regTime = freezed,
    Object? largeAvatar = freezed,
    Object? loc = freezed,
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
            uri: freezed == uri
                ? _value.uri
                : uri // ignore: cast_nullable_to_non_nullable
                      as String?,
            type: freezed == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String?,
            gender: freezed == gender
                ? _value.gender
                : gender // ignore: cast_nullable_to_non_nullable
                      as String?,
            regTime: freezed == regTime
                ? _value.regTime
                : regTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            largeAvatar: freezed == largeAvatar
                ? _value.largeAvatar
                : largeAvatar // ignore: cast_nullable_to_non_nullable
                      as String?,
            loc: freezed == loc
                ? _value.loc
                : loc // ignore: cast_nullable_to_non_nullable
                      as AuthorLoc?,
          )
          as $Val,
    );
  }

  /// Create a copy of Author
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
}

/// @nodoc
abstract class _$$AuthorImplCopyWith<$Res> implements $AuthorCopyWith<$Res> {
  factory _$$AuthorImplCopyWith(
    _$AuthorImpl value,
    $Res Function(_$AuthorImpl) then,
  ) = __$$AuthorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? avatar,
    String? uri,
    String? type,
    String? gender,
    @JsonKey(name: 'reg_time') String? regTime,
    @JsonKey(name: 'large_avatar') String? largeAvatar,
    AuthorLoc? loc,
  });

  @override
  $AuthorLocCopyWith<$Res>? get loc;
}

/// @nodoc
class __$$AuthorImplCopyWithImpl<$Res>
    extends _$AuthorCopyWithImpl<$Res, _$AuthorImpl>
    implements _$$AuthorImplCopyWith<$Res> {
  __$$AuthorImplCopyWithImpl(
    _$AuthorImpl _value,
    $Res Function(_$AuthorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Author
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatar = freezed,
    Object? uri = freezed,
    Object? type = freezed,
    Object? gender = freezed,
    Object? regTime = freezed,
    Object? largeAvatar = freezed,
    Object? loc = freezed,
  }) {
    return _then(
      _$AuthorImpl(
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
        uri: freezed == uri
            ? _value.uri
            : uri // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: freezed == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String?,
        gender: freezed == gender
            ? _value.gender
            : gender // ignore: cast_nullable_to_non_nullable
                  as String?,
        regTime: freezed == regTime
            ? _value.regTime
            : regTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        largeAvatar: freezed == largeAvatar
            ? _value.largeAvatar
            : largeAvatar // ignore: cast_nullable_to_non_nullable
                  as String?,
        loc: freezed == loc
            ? _value.loc
            : loc // ignore: cast_nullable_to_non_nullable
                  as AuthorLoc?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthorImpl implements _Author {
  const _$AuthorImpl({
    required this.id,
    required this.name,
    this.avatar,
    this.uri,
    this.type,
    this.gender,
    @JsonKey(name: 'reg_time') this.regTime,
    @JsonKey(name: 'large_avatar') this.largeAvatar,
    this.loc,
  });

  factory _$AuthorImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthorImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? avatar;
  @override
  final String? uri;
  @override
  final String? type;
  @override
  final String? gender;
  @override
  @JsonKey(name: 'reg_time')
  final String? regTime;
  @override
  @JsonKey(name: 'large_avatar')
  final String? largeAvatar;
  @override
  final AuthorLoc? loc;

  @override
  String toString() {
    return 'Author(id: $id, name: $name, avatar: $avatar, uri: $uri, type: $type, gender: $gender, regTime: $regTime, largeAvatar: $largeAvatar, loc: $loc)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthorImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.uri, uri) || other.uri == uri) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.regTime, regTime) || other.regTime == regTime) &&
            (identical(other.largeAvatar, largeAvatar) ||
                other.largeAvatar == largeAvatar) &&
            (identical(other.loc, loc) || other.loc == loc));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    avatar,
    uri,
    type,
    gender,
    regTime,
    largeAvatar,
    loc,
  );

  /// Create a copy of Author
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthorImplCopyWith<_$AuthorImpl> get copyWith =>
      __$$AuthorImplCopyWithImpl<_$AuthorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthorImplToJson(this);
  }
}

abstract class _Author implements Author {
  const factory _Author({
    required final String id,
    required final String name,
    final String? avatar,
    final String? uri,
    final String? type,
    final String? gender,
    @JsonKey(name: 'reg_time') final String? regTime,
    @JsonKey(name: 'large_avatar') final String? largeAvatar,
    final AuthorLoc? loc,
  }) = _$AuthorImpl;

  factory _Author.fromJson(Map<String, dynamic> json) = _$AuthorImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get avatar;
  @override
  String? get uri;
  @override
  String? get type;
  @override
  String? get gender;
  @override
  @JsonKey(name: 'reg_time')
  String? get regTime;
  @override
  @JsonKey(name: 'large_avatar')
  String? get largeAvatar;
  @override
  AuthorLoc? get loc;

  /// Create a copy of Author
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthorImplCopyWith<_$AuthorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
