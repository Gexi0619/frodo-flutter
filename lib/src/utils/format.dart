/// 数字简写：`1234` → `1.2k`，`12345` → `1.2w`。
String formatCount(int n) {
  if (n < 1000) return '$n';
  if (n < 10000) return '${(n / 1000).toStringAsFixed(1)}k';
  return '${(n / 10000).toStringAsFixed(1)}w';
}
