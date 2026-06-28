import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/count_badge.dart';
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

    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          middle: const Text('消息'),
          backgroundColor: scheme.surface,
          border: Border(
            bottom: BorderSide(
              color: scheme.onSurface.withValues(alpha: 0.12),
              width: 0.0,
            ),
          ),
        ),
        body: Column(
          children: [
            // 段控与 TabBarView 双向同步：点段 → animateTo；
            // 滑动切 tab → AnimatedBuilder 监听 controller 把高亮挪过去。
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Builder(
                builder: (context) {
                  final controller = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) =>
                        CupertinoSlidingSegmentedControl<int>(
                          groupValue: controller.index,
                          onValueChanged: (i) {
                            if (i != null) controller.animateTo(i);
                          },
                          children: {
                            0: _segmentLabel('通知', notificationCount),
                            1: _segmentLabel('私信', chatCount),
                          },
                        ),
                  );
                },
              ),
            ),
            const Expanded(
              child: TabBarView(children: [NotificationsTab(), ChatListTab()]),
            ),
          ],
        ),
      ),
    );
  }

  /// 段标签：`count > 0` 时在文字右侧加一个 iOS 风格红色未读角标。
  Widget _segmentLabel(String text, int count) {
    if (count <= 0) return Text(text);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        const SizedBox(width: 6),
        CountBadge(count: count),
      ],
    );
  }
}
