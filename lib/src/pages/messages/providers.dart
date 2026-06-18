import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/notification_chart.dart';
import '../../repositories/notification_repository.dart';

/// 未读消息角标。后台每 60s 轮询一次 `notification_chart`，供底栏「消息」入口
/// 与消息页「通知 / 私信」tab 显示角标。出错时上游 UI 取 `valueOrNull` 兜底为
/// 不显示角标。可对该 provider 调 `ref.invalidate` 立即刷新（如进入消息页时）。
final notificationChartProvider = FutureProvider<NotificationChart>((ref) async {
  final timer = Timer(const Duration(seconds: 60), ref.invalidateSelf);
  ref.onDispose(timer.cancel);
  return ref.watch(notificationRepositoryProvider).fetchNotificationChart();
});
