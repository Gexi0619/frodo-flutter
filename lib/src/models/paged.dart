import 'package:freezed_annotation/freezed_annotation.dart';

part 'paged.freezed.dart';
part 'paged.g.dart';

/// 通用分页响应（小组讨论、评论列表都用 start/count/total/items）。
@Freezed(genericArgumentFactories: true)
class Paged<T> with _$Paged<T> {
  const factory Paged({
    required List<T> items,
    @Default(0) int total,
    @Default(0) int start,
    @Default(0) int count,
  }) = _Paged<T>;

  factory Paged.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PagedFromJson(json, fromJsonT);
}

/// 从 frodo 接口响应里抽列表字段（按 `itemsKeys` 先后尝试），逐项过 `fromJson`，
/// 包成 [Paged]. 字段命名约定：start/count/total 三件套，缺失则用本地推算值兜底。
Paged<T> parsePagedList<T>(
  Map<String, dynamic> data, {
  List<String> itemsKeys = const ['items'],
  required T Function(Map<String, dynamic> json) fromJson,
  required int fallbackStart,
}) {
  List<dynamic> raw = const [];
  for (final key in itemsKeys) {
    final v = data[key];
    if (v is List) {
      raw = v;
      break;
    }
  }
  final items =
      raw.whereType<Map<String, dynamic>>().map(fromJson).toList(growable: false);
  return Paged<T>(
    items: items,
    total: (data['total'] as int?) ?? items.length,
    start: (data['start'] as int?) ?? fallbackStart,
    count: (data['count'] as int?) ?? items.length,
  );
}
