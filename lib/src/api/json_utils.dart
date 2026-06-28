/// `data` 是 List 就强转，否则返回空。用于宽容地处理 frodo 接口偶尔
/// 把列表字段省略 / 改成 null 的情况。
List<dynamic> asList(dynamic v) => v is List ? v : const [];

/// frodo 接口里嵌套的 map 可能因为字段缺失变成 null 或其它类型，统一拿一层。
Map<String, dynamic> asMap(dynamic v) =>
    v is Map<String, dynamic> ? v : const <String, dynamic>{};

/// 剥掉搜索结果的 `{ target: {...} }` 包装：search 接口把真正的实体塞在
/// `target` 里，但偶尔直接平铺。target 是非空 map 就取它，否则原样返回 [e]。
Map<String, dynamic> unwrapTarget(Map<String, dynamic> e) {
  final t = e['target'];
  return t is Map<String, dynamic> && t.isNotEmpty ? t : e;
}
