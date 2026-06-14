// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationItemImpl _$$NotificationItemImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationItemImpl(
  id: json['id'] as String,
  category: json['category'] as String?,
  text: json['text'] as String?,
  label: json['label'] as String?,
  labelIcon: json['label_icon'] as String?,
  targetUri: json['target_uri'] as String?,
  time: json['time'] as String?,
  isRead: json['is_read'] as bool? ?? false,
  discardable: json['discardable'] as bool? ?? false,
  emphasizes:
      (json['emphasizes'] as List<dynamic>?)
          ?.map((e) => Emphasis.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Emphasis>[],
);

Map<String, dynamic> _$$NotificationItemImplToJson(
  _$NotificationItemImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'category': instance.category,
  'text': instance.text,
  'label': instance.label,
  'label_icon': instance.labelIcon,
  'target_uri': instance.targetUri,
  'time': instance.time,
  'is_read': instance.isRead,
  'discardable': instance.discardable,
  'emphasizes': instance.emphasizes,
};

_$EmphasisImpl _$$EmphasisImplFromJson(Map<String, dynamic> json) =>
    _$EmphasisImpl(
      start: (json['start'] as num?)?.toInt() ?? 0,
      end: (json['end'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$EmphasisImplToJson(_$EmphasisImpl instance) =>
    <String, dynamic>{'start': instance.start, 'end': instance.end};
