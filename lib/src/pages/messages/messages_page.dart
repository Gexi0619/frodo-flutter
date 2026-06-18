import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'chat_list_tab.dart';
import 'notifications_tab.dart';
import 'providers.dart';

/// 「消息」页：分「通知」「私信」两个 tab。
///
/// - 通知：互动通知（点赞 / 回复 / 关注等，`GET /api/v2/mine/notifications`）。
/// - 私信：会话列表（`GET /api/v2/chat_list`），点开进入会话详情。
///
/// 两个 tab 标题各带未读角标，数字来自 [notificationChartProvider]；进入本页时
/// 主动刷新一次，保证角标尽量新鲜。
class MessagesPage extends ConsumerStatefulWidget {
  const MessagesPage({super.key});

  @override
  ConsumerState<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends ConsumerState<MessagesPage> {
  @override
  void initState() {
    super.initState();
    // 进入消息页时立即拉一次最新未读数。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(notificationChartProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chart = ref.watch(notificationChartProvider).valueOrNull;
    final notificationCount = chart?.notification ?? 0;
    final chatCount = chart?.chat ?? 0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('消息'),
          bottom: TabBar(
            tabs: [
              _badgedTab('通知', notificationCount),
              _badgedTab('私信', chatCount),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            NotificationsTab(),
            ChatListTab(),
          ],
        ),
      ),
    );
  }

  /// 带未读角标的 tab 标题：`count > 0` 时在文字右侧加红色数字角标。
  Widget _badgedTab(String text, int count) {
    return Tab(
      child: count > 0
          ? Badge.count(
              count: count,
              alignment: AlignmentDirectional.centerEnd,
              offset: const Offset(18, -4),
              child: Text(text),
            )
          : Text(text),
    );
  }
}
