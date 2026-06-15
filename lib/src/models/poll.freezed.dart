// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Poll _$PollFromJson(Map<String, dynamic> json) {
  return _Poll.fromJson(json);
}

/// @nodoc
mixin _$Poll {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'expire_time')
  String? get expireTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_correct_answer')
  bool get hasCorrectAnswer => throw _privateConstructorUsedError;
  @JsonKey(name: 'input_type')
  String? get inputType => throw _privateConstructorUsedError;
  List<PollOption> get options => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  String? get ownerId => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'vote_limit')
  int get voteLimit => throw _privateConstructorUsedError;
  @JsonKey(name: 'voted_user_count')
  int get votedUserCount => throw _privateConstructorUsedError;

  /// Serializes this Poll to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Poll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollCopyWith<Poll> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollCopyWith<$Res> {
  factory $PollCopyWith(Poll value, $Res Function(Poll) then) =
      _$PollCopyWithImpl<$Res, Poll>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'expire_time') String? expireTime,
    @JsonKey(name: 'has_correct_answer') bool hasCorrectAnswer,
    @JsonKey(name: 'input_type') String? inputType,
    List<PollOption> options,
    @JsonKey(name: 'owner_id') String? ownerId,
    String? title,
    @JsonKey(name: 'vote_limit') int voteLimit,
    @JsonKey(name: 'voted_user_count') int votedUserCount,
  });
}

/// @nodoc
class _$PollCopyWithImpl<$Res, $Val extends Poll>
    implements $PollCopyWith<$Res> {
  _$PollCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Poll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expireTime = freezed,
    Object? hasCorrectAnswer = null,
    Object? inputType = freezed,
    Object? options = null,
    Object? ownerId = freezed,
    Object? title = freezed,
    Object? voteLimit = null,
    Object? votedUserCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            expireTime: freezed == expireTime
                ? _value.expireTime
                : expireTime // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasCorrectAnswer: null == hasCorrectAnswer
                ? _value.hasCorrectAnswer
                : hasCorrectAnswer // ignore: cast_nullable_to_non_nullable
                      as bool,
            inputType: freezed == inputType
                ? _value.inputType
                : inputType // ignore: cast_nullable_to_non_nullable
                      as String?,
            options: null == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as List<PollOption>,
            ownerId: freezed == ownerId
                ? _value.ownerId
                : ownerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: freezed == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String?,
            voteLimit: null == voteLimit
                ? _value.voteLimit
                : voteLimit // ignore: cast_nullable_to_non_nullable
                      as int,
            votedUserCount: null == votedUserCount
                ? _value.votedUserCount
                : votedUserCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PollImplCopyWith<$Res> implements $PollCopyWith<$Res> {
  factory _$$PollImplCopyWith(
    _$PollImpl value,
    $Res Function(_$PollImpl) then,
  ) = __$$PollImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'expire_time') String? expireTime,
    @JsonKey(name: 'has_correct_answer') bool hasCorrectAnswer,
    @JsonKey(name: 'input_type') String? inputType,
    List<PollOption> options,
    @JsonKey(name: 'owner_id') String? ownerId,
    String? title,
    @JsonKey(name: 'vote_limit') int voteLimit,
    @JsonKey(name: 'voted_user_count') int votedUserCount,
  });
}

/// @nodoc
class __$$PollImplCopyWithImpl<$Res>
    extends _$PollCopyWithImpl<$Res, _$PollImpl>
    implements _$$PollImplCopyWith<$Res> {
  __$$PollImplCopyWithImpl(_$PollImpl _value, $Res Function(_$PollImpl) _then)
    : super(_value, _then);

  /// Create a copy of Poll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? expireTime = freezed,
    Object? hasCorrectAnswer = null,
    Object? inputType = freezed,
    Object? options = null,
    Object? ownerId = freezed,
    Object? title = freezed,
    Object? voteLimit = null,
    Object? votedUserCount = null,
  }) {
    return _then(
      _$PollImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        expireTime: freezed == expireTime
            ? _value.expireTime
            : expireTime // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasCorrectAnswer: null == hasCorrectAnswer
            ? _value.hasCorrectAnswer
            : hasCorrectAnswer // ignore: cast_nullable_to_non_nullable
                  as bool,
        inputType: freezed == inputType
            ? _value.inputType
            : inputType // ignore: cast_nullable_to_non_nullable
                  as String?,
        options: null == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<PollOption>,
        ownerId: freezed == ownerId
            ? _value.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: freezed == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String?,
        voteLimit: null == voteLimit
            ? _value.voteLimit
            : voteLimit // ignore: cast_nullable_to_non_nullable
                  as int,
        votedUserCount: null == votedUserCount
            ? _value.votedUserCount
            : votedUserCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PollImpl extends _Poll {
  const _$PollImpl({
    required this.id,
    @JsonKey(name: 'expire_time') this.expireTime,
    @JsonKey(name: 'has_correct_answer') this.hasCorrectAnswer = false,
    @JsonKey(name: 'input_type') this.inputType,
    final List<PollOption> options = const <PollOption>[],
    @JsonKey(name: 'owner_id') this.ownerId,
    this.title,
    @JsonKey(name: 'vote_limit') this.voteLimit = 1,
    @JsonKey(name: 'voted_user_count') this.votedUserCount = 0,
  }) : _options = options,
       super._();

  factory _$PollImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'expire_time')
  final String? expireTime;
  @override
  @JsonKey(name: 'has_correct_answer')
  final bool hasCorrectAnswer;
  @override
  @JsonKey(name: 'input_type')
  final String? inputType;
  final List<PollOption> _options;
  @override
  @JsonKey()
  List<PollOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  @JsonKey(name: 'owner_id')
  final String? ownerId;
  @override
  final String? title;
  @override
  @JsonKey(name: 'vote_limit')
  final int voteLimit;
  @override
  @JsonKey(name: 'voted_user_count')
  final int votedUserCount;

  @override
  String toString() {
    return 'Poll(id: $id, expireTime: $expireTime, hasCorrectAnswer: $hasCorrectAnswer, inputType: $inputType, options: $options, ownerId: $ownerId, title: $title, voteLimit: $voteLimit, votedUserCount: $votedUserCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.expireTime, expireTime) ||
                other.expireTime == expireTime) &&
            (identical(other.hasCorrectAnswer, hasCorrectAnswer) ||
                other.hasCorrectAnswer == hasCorrectAnswer) &&
            (identical(other.inputType, inputType) ||
                other.inputType == inputType) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.voteLimit, voteLimit) ||
                other.voteLimit == voteLimit) &&
            (identical(other.votedUserCount, votedUserCount) ||
                other.votedUserCount == votedUserCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    expireTime,
    hasCorrectAnswer,
    inputType,
    const DeepCollectionEquality().hash(_options),
    ownerId,
    title,
    voteLimit,
    votedUserCount,
  );

  /// Create a copy of Poll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollImplCopyWith<_$PollImpl> get copyWith =>
      __$$PollImplCopyWithImpl<_$PollImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollImplToJson(this);
  }
}

abstract class _Poll extends Poll {
  const factory _Poll({
    required final String id,
    @JsonKey(name: 'expire_time') final String? expireTime,
    @JsonKey(name: 'has_correct_answer') final bool hasCorrectAnswer,
    @JsonKey(name: 'input_type') final String? inputType,
    final List<PollOption> options,
    @JsonKey(name: 'owner_id') final String? ownerId,
    final String? title,
    @JsonKey(name: 'vote_limit') final int voteLimit,
    @JsonKey(name: 'voted_user_count') final int votedUserCount,
  }) = _$PollImpl;
  const _Poll._() : super._();

  factory _Poll.fromJson(Map<String, dynamic> json) = _$PollImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'expire_time')
  String? get expireTime;
  @override
  @JsonKey(name: 'has_correct_answer')
  bool get hasCorrectAnswer;
  @override
  @JsonKey(name: 'input_type')
  String? get inputType;
  @override
  List<PollOption> get options;
  @override
  @JsonKey(name: 'owner_id')
  String? get ownerId;
  @override
  String? get title;
  @override
  @JsonKey(name: 'vote_limit')
  int get voteLimit;
  @override
  @JsonKey(name: 'voted_user_count')
  int get votedUserCount;

  /// Create a copy of Poll
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollImplCopyWith<_$PollImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PollOption _$PollOptionFromJson(Map<String, dynamic> json) {
  return _PollOption.fromJson(json);
}

/// @nodoc
mixin _$PollOption {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_correct')
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_voted')
  bool get isVoted => throw _privateConstructorUsedError;
  @JsonKey(name: 'poll_id')
  String? get pollId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'voted_user_count')
  int get votedUserCount => throw _privateConstructorUsedError;

  /// Serializes this PollOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PollOptionCopyWith<PollOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PollOptionCopyWith<$Res> {
  factory $PollOptionCopyWith(
    PollOption value,
    $Res Function(PollOption) then,
  ) = _$PollOptionCopyWithImpl<$Res, PollOption>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'is_voted') bool isVoted,
    @JsonKey(name: 'poll_id') String? pollId,
    String title,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'voted_user_count') int votedUserCount,
  });
}

/// @nodoc
class _$PollOptionCopyWithImpl<$Res, $Val extends PollOption>
    implements $PollOptionCopyWith<$Res> {
  _$PollOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isCorrect = null,
    Object? isVoted = null,
    Object? pollId = freezed,
    Object? title = null,
    Object? userId = freezed,
    Object? votedUserCount = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            isVoted: null == isVoted
                ? _value.isVoted
                : isVoted // ignore: cast_nullable_to_non_nullable
                      as bool,
            pollId: freezed == pollId
                ? _value.pollId
                : pollId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String?,
            votedUserCount: null == votedUserCount
                ? _value.votedUserCount
                : votedUserCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PollOptionImplCopyWith<$Res>
    implements $PollOptionCopyWith<$Res> {
  factory _$$PollOptionImplCopyWith(
    _$PollOptionImpl value,
    $Res Function(_$PollOptionImpl) then,
  ) = __$$PollOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'is_correct') bool isCorrect,
    @JsonKey(name: 'is_voted') bool isVoted,
    @JsonKey(name: 'poll_id') String? pollId,
    String title,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'voted_user_count') int votedUserCount,
  });
}

/// @nodoc
class __$$PollOptionImplCopyWithImpl<$Res>
    extends _$PollOptionCopyWithImpl<$Res, _$PollOptionImpl>
    implements _$$PollOptionImplCopyWith<$Res> {
  __$$PollOptionImplCopyWithImpl(
    _$PollOptionImpl _value,
    $Res Function(_$PollOptionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? isCorrect = null,
    Object? isVoted = null,
    Object? pollId = freezed,
    Object? title = null,
    Object? userId = freezed,
    Object? votedUserCount = null,
  }) {
    return _then(
      _$PollOptionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        isVoted: null == isVoted
            ? _value.isVoted
            : isVoted // ignore: cast_nullable_to_non_nullable
                  as bool,
        pollId: freezed == pollId
            ? _value.pollId
            : pollId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: freezed == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        votedUserCount: null == votedUserCount
            ? _value.votedUserCount
            : votedUserCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PollOptionImpl implements _PollOption {
  const _$PollOptionImpl({
    required this.id,
    @JsonKey(name: 'is_correct') this.isCorrect = false,
    @JsonKey(name: 'is_voted') this.isVoted = false,
    @JsonKey(name: 'poll_id') this.pollId,
    required this.title,
    @JsonKey(name: 'user_id') this.userId,
    @JsonKey(name: 'voted_user_count') this.votedUserCount = 0,
  });

  factory _$PollOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PollOptionImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'is_correct')
  final bool isCorrect;
  @override
  @JsonKey(name: 'is_voted')
  final bool isVoted;
  @override
  @JsonKey(name: 'poll_id')
  final String? pollId;
  @override
  final String title;
  @override
  @JsonKey(name: 'user_id')
  final String? userId;
  @override
  @JsonKey(name: 'voted_user_count')
  final int votedUserCount;

  @override
  String toString() {
    return 'PollOption(id: $id, isCorrect: $isCorrect, isVoted: $isVoted, pollId: $pollId, title: $title, userId: $userId, votedUserCount: $votedUserCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PollOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.isVoted, isVoted) || other.isVoted == isVoted) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.votedUserCount, votedUserCount) ||
                other.votedUserCount == votedUserCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    isCorrect,
    isVoted,
    pollId,
    title,
    userId,
    votedUserCount,
  );

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PollOptionImplCopyWith<_$PollOptionImpl> get copyWith =>
      __$$PollOptionImplCopyWithImpl<_$PollOptionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PollOptionImplToJson(this);
  }
}

abstract class _PollOption implements PollOption {
  const factory _PollOption({
    required final String id,
    @JsonKey(name: 'is_correct') final bool isCorrect,
    @JsonKey(name: 'is_voted') final bool isVoted,
    @JsonKey(name: 'poll_id') final String? pollId,
    required final String title,
    @JsonKey(name: 'user_id') final String? userId,
    @JsonKey(name: 'voted_user_count') final int votedUserCount,
  }) = _$PollOptionImpl;

  factory _PollOption.fromJson(Map<String, dynamic> json) =
      _$PollOptionImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'is_correct')
  bool get isCorrect;
  @override
  @JsonKey(name: 'is_voted')
  bool get isVoted;
  @override
  @JsonKey(name: 'poll_id')
  String? get pollId;
  @override
  String get title;
  @override
  @JsonKey(name: 'user_id')
  String? get userId;
  @override
  @JsonKey(name: 'voted_user_count')
  int get votedUserCount;

  /// Create a copy of PollOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PollOptionImplCopyWith<_$PollOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
