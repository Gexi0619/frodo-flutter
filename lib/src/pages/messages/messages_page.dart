import 'package:flutter/material.dart';

import 'chat_list_tab.dart';
import 'notifications_tab.dart';

/// 「消息」页：分「通知」「私信」两个 tab。
///
/// - 通知：互动通知（点赞 / 回复 / 关注等，`GET /api/v2/mine/notifications`）。
/// - 私信：会话列表（`GET /api/v2/chat_list`），点开进入会话详情。
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  static const _tabs = [
    Tab(text: '通知'),
    Tab(text: '私信'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('消息'),
          bottom: const TabBar(tabs: _tabs),
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
}
