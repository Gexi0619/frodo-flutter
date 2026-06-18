import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/notification.dart';
import '../../repositories/notification_repository.dart';
import '../../theme.dart';
import '../../ui/dimens.dart';
import '../../utils/link_launcher.dart';
import '../../utils/time.dart';
import '../../widgets/paged_builders.dart';
import '../../widgets/paging_mixin.dart';

/// 「通知」tab：当前账号收到的互动通知（点赞 / 回复 / 关注等）。
///
/// 数据来自 `GET /api/v2/mine/notifications`，下拉无限翻页。点击某条消息会按
/// `target_uri` 跳到对应的站内页面或外链。
class NotificationsTab extends ConsumerStatefulWidget {
  const NotificationsTab({super.key});

  @override
  ConsumerState<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends ConsumerState<NotificationsTab>
    with PagingMixin<NotificationItem, NotificationsTab> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref.read(notificationRepositoryProvider).fetchNotifications(
          start: start,
          count: kPageSize,
        );
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => pagingController.refresh(),
      child: PagedListView<int, NotificationItem>.separated(
        pagingController: pagingController,
        separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.6),
        builderDelegate: frodoPagedDelegate<NotificationItem>(
          controller: pagingController,
          emptyText: '还没有新消息',
          itemBuilder: (context, item, _) => _NotificationTile(item: item),
        ),
      ),
    );
  }
}

/// 单条通知：右侧文案（高亮片段加粗）+ 标签 / 时间。未读用主色圆点标记。
class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final time = formatRelativeTime(item.time);
    final label = item.label;
    final uri = item.targetUri;

    return InkWell(
      onTap: (uri != null && uri.isNotEmpty)
          ? () => openLink(context, uri)
          : null,
      // 未读用淡主色背景区分（已读则透明）。
      child: Container(
        color: item.isRead ? null : scheme.primary.withValues(alpha: 0.08),
        padding: Dim.tile,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _emphasizedText(context, item),
            if (label != null && label.isNotEmpty ||
                (time != null && time.isNotEmpty))
              Padding(
                padding: const EdgeInsets.only(top: Dim.xs),
                child: Text(
                  [
                    if (label != null && label.isNotEmpty) label,
                    if (time != null && time.isNotEmpty) time,
                  ].join(' · '),
                  style: theme
                      .extension<AppTextStyles>()
                      ?.micro
                      .copyWith(color: scheme.outline),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// 把 `text` 按 `emphasizes` 区间拆成普通 / 加粗的富文本。区间越界或缺失时
  /// 直接整段普通显示。
  Widget _emphasizedText(BuildContext context, NotificationItem item) {
    final theme = Theme.of(context);
    final base = theme.textTheme.bodyMedium;
    final text = item.text ?? '';
    if (text.isEmpty) {
      return Text('（无内容）', style: base?.copyWith(color: theme.colorScheme.outline));
    }

    // 按 start 排序后逐段切分，跳过越界 / 反向的脏区间。
    final ranges = item.emphasizes
        .where((e) => e.start >= 0 && e.end <= text.length && e.start < e.end)
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    if (ranges.isEmpty) {
      return Text(text, style: base);
    }

    final spans = <TextSpan>[];
    var cursor = 0;
    for (final r in ranges) {
      if (r.start < cursor) continue; // 与已输出片段重叠，跳过。
      if (r.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, r.start)));
      }
      spans.add(TextSpan(
        text: text.substring(r.start, r.end),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ));
      cursor = r.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return Text.rich(TextSpan(style: base, children: spans));
  }
}
