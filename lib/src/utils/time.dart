String? formatRelativeTime(String? raw) {
  if (raw == null || raw.isEmpty) return null;
  // Douban API returns CST (UTC+8) without timezone marker; append +08:00 so
  // DateTime.difference works correctly regardless of device timezone.
  final dt = DateTime.tryParse('${raw.replaceFirst(' ', 'T')}+08:00');
  if (dt == null) return raw;
  final now = DateTime.now();
  final diff = now.difference(dt);
  if (diff.inSeconds < 60) return '${diff.inSeconds} 秒前';
  if (diff.inMinutes < 60) return '${diff.inMinutes} 分钟前';
  if (diff.inHours < 24) return '${diff.inHours} 小时前';
  if (diff.inDays < 7) return '${diff.inDays} 天前';
  if (dt.year == now.year) return '${_pad2(dt.month)}-${_pad2(dt.day)}';
  return '${dt.year}-${_pad2(dt.month)}-${_pad2(dt.day)}';
}

String _pad2(int v) => v.toString().padLeft(2, '0');
