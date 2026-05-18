/// 精确到秒/分钟/小时的相对时间。
/// 豆瓣接口返回 CST (UTC+8) 但不带时区标记，这里补 `+08:00` 以免设备时区不同导致计算偏差。
String? formatRelativeTime(String? raw) {
  final dt = _parseCst(raw);
  if (dt == null) return raw == null || raw.isEmpty ? null : raw;
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inSeconds < 60) return '${diff.inSeconds} 秒前';
  if (diff.inMinutes < 60) return '${diff.inMinutes} 分钟前';
  if (diff.inHours < 24) return '${diff.inHours} 小时前';
  if (diff.inDays < 7) return '${diff.inDays} 天前';
  if (dt.year == now.year) return '${_pad2(dt.month)}-${_pad2(dt.day)}';
  return '${dt.year}-${_pad2(dt.month)}-${_pad2(dt.day)}';
}

/// 精确到天的相对时间：今天 / 昨天 / N 天前 / 月-日 / 年-月-日。
/// 用于"收藏时间"这种天级粒度即可的场景。
String formatRelativeDate(String? raw) {
  if (raw == null || raw.isEmpty) return '';
  final dt = _parseCst(raw);
  if (dt == null) return raw;
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final that = DateTime(dt.year, dt.month, dt.day);
  final dayDiff = today.difference(that).inDays;
  if (dayDiff == 0) return '今天';
  if (dayDiff == 1) return '昨天';
  if (dayDiff < 7) return '$dayDiff 天前';
  if (dt.year == now.year) return '${_pad2(dt.month)}-${_pad2(dt.day)}';
  return '${dt.year}-${_pad2(dt.month)}-${_pad2(dt.day)}';
}

DateTime? _parseCst(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  return DateTime.tryParse('${raw.replaceFirst(' ', 'T')}+08:00');
}

String _pad2(int v) => v.toString().padLeft(2, '0');
