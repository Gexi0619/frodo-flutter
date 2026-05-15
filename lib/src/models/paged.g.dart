// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PagedImpl<T> _$$PagedImplFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => _$PagedImpl<T>(
  items: (json['items'] as List<dynamic>).map(fromJsonT).toList(),
  total: (json['total'] as num?)?.toInt() ?? 0,
  start: (json['start'] as num?)?.toInt() ?? 0,
  count: (json['count'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$$PagedImplToJson<T>(
  _$PagedImpl<T> instance,
  Object? Function(T value) toJsonT,
) => <String, dynamic>{
  'items': instance.items.map(toJsonT).toList(),
  'total': instance.total,
  'start': instance.start,
  'count': instance.count,
};
