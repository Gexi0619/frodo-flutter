// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reshare.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReshareImpl _$$ReshareImplFromJson(Map<String, dynamic> json) =>
    _$ReshareImpl(
      id: json['id'] as String,
      text: json['text'] as String?,
      createTime: json['create_time'] as String?,
      uri: json['uri'] as String?,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ReshareImplToJson(_$ReshareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'create_time': instance.createTime,
      'uri': instance.uri,
      'author': instance.author,
    };
