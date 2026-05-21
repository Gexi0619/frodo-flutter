// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccessTokenImpl _$$AccessTokenImplFromJson(Map<String, dynamic> json) =>
    _$AccessTokenImpl(
      value: json['value'] as String,
      label: json['label'] as String?,
      createdAt: (json['createdAt'] as num).toInt(),
    );

Map<String, dynamic> _$$AccessTokenImplToJson(_$AccessTokenImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'createdAt': instance.createdAt,
    };

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      userId: json['userId'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      tokens:
          (json['tokens'] as List<dynamic>?)
              ?.map((e) => AccessToken.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AccessToken>[],
      activeToken: json['activeToken'] as String,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'avatar': instance.avatar,
      'tokens': instance.tokens,
      'activeToken': instance.activeToken,
    };

_$AuthStateImpl _$$AuthStateImplFromJson(Map<String, dynamic> json) =>
    _$AuthStateImpl(
      accounts:
          (json['accounts'] as List<dynamic>?)
              ?.map((e) => Account.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <Account>[],
      activeUserId: json['activeUserId'] as String?,
    );

Map<String, dynamic> _$$AuthStateImplToJson(_$AuthStateImpl instance) =>
    <String, dynamic>{
      'accounts': instance.accounts,
      'activeUserId': instance.activeUserId,
    };
