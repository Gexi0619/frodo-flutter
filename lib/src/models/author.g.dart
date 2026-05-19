// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AuthorLocImpl _$$AuthorLocImplFromJson(Map<String, dynamic> json) =>
    _$AuthorLocImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      uid: json['uid'] as String?,
    );

Map<String, dynamic> _$$AuthorLocImplToJson(_$AuthorLocImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'uid': instance.uid,
    };

_$AuthorImpl _$$AuthorImplFromJson(Map<String, dynamic> json) => _$AuthorImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  avatar: json['avatar'] as String?,
  uri: json['uri'] as String?,
  type: json['type'] as String?,
  gender: json['gender'] as String?,
  regTime: json['reg_time'] as String?,
  largeAvatar: json['large_avatar'] as String?,
  loc: json['loc'] == null
      ? null
      : AuthorLoc.fromJson(json['loc'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$AuthorImplToJson(_$AuthorImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'uri': instance.uri,
      'type': instance.type,
      'gender': instance.gender,
      'reg_time': instance.regTime,
      'large_avatar': instance.largeAvatar,
      'loc': instance.loc,
    };
