import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/chat.dart';
import '../../ui/scroll_behavior.dart';
import '../../repositories/chat_repository.dart';
import '../../routing/app_routes.dart';
import '../../ui/dimens.dart';
import '../../utils/time.dart';
import '../../widgets/count_badge.dart';
import '../../widgets/cupertino_tappable.dart';
import '../../widgets/paged_builders.dart';
import '../../widgets/paging_mixin.dart';
import '../../widgets/user_avatar.dart';

/// 「私信」tab：会话列表，数据来自 `GET /api/v2/chat_list`，下拉无限翻页。
///
/// 点击某条会话进入会话详情页（[ChatPage]），把 [Chat] 作为 extra 传过去用于
/// 即时渲染头部。
class ChatListTab extends ConsumerStatefulWidget {
  const ChatListTab({super.key});

  @override
  ConsumerState<ChatListTab> createState() => _ChatListTabState();
}

class _ChatListTabState extends ConsumerState<ChatListTab>
    with PagingMixin<Chat, ChatListTab> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref
        .read(chatRepositoryProvider)
        .fetchChats(start: start, count: kPageSize);
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: kRefreshScrollPhysics,
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async => pagingController.refresh(),
        ),
        PagedSliverList<int, Chat>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.6),
          builderDelegate: frodoPagedDelegate<Chat>(
            controller: pagingController,
            emptyText: '还没有私信',
            itemBuilder: (context, chat, _) => _ChatTile(chat: chat),
          ),
        ),
      ],
    );
  }
}

/// 单条会话：左头像，中间昵称 + 最后一条消息预览，右侧时间 + 未读数。
class _ChatTile extends StatelessWidget {
  const _ChatTile({required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = chat.targetUser;
    final name = user?.name ?? '';
    final preview = chat.preview;
    final time = formatRelativeTime(chat.lastMessage?.createTime);
    final unread = chat.unreadCount;

    return CupertinoTappable(
      onTap: () =>
          context.push(AppRoutes.chat(chat.conversationId), extra: chat),
      child: Padding(
        padding: Dim.tile,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(
              url: user?.avatar,
              radius: Dim.avatarMd / 2,
              userId: user?.id,
            ),
            const SizedBox(width: Dim.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (preview.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: Dim.xxs),
                      child: Text(
                        preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.outline,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: Dim.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (time != null && time.isNotEmpty)
                  Text(
                    time,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.outline,
                    ),
                  ),
                if (unread > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: Dim.xs),
                    child: CountBadge(count: unread),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
