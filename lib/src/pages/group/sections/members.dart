import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/author.dart';
import '../../../repositories/group_repository.dart';
import '../../../ui/scroll_behavior.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';
import '../../../utils/parsing.dart';
import '../../../utils/time.dart';

class GroupMembersPage extends ConsumerStatefulWidget {
  const GroupMembersPage({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends ConsumerState<GroupMembersPage>
    with PagingMixin<Author, GroupMembersPage> {
  @override
  Future<void> onLoadPage(int start) async {
    final page = await ref
        .read(groupRepositoryProvider)
        .fetchMembers(widget.groupId, start: start, count: kPageSize);
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    final group = ref.watch(groupDetailProvider(widget.groupId)).valueOrNull;
    final bg = hexToColor(group?.backgroundMaskColor);
    final onBg = contrastOn(bg);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          group != null
              ? '${group.memberName ?? "成员"} · ${group.memberCountText ?? (group.memberCount != null ? "${group.memberCount}" : "")}'
              : '成员',
        ),
        backgroundColor: bg,
        foregroundColor: onBg,
      ),
      body: CustomScrollView(
        physics: kRefreshScrollPhysics,
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async => pagingController.refresh(),
          ),
          PagedSliverList<int, Author>.separated(
            pagingController: pagingController,
            separatorBuilder: (_, __) =>
                const Divider(height: 0, thickness: 0.3, indent: 64),
            builderDelegate: frodoPagedDelegate<Author>(
              controller: pagingController,
              emptyText: '暂无成员',
              itemBuilder: (context, member, _) => _MemberTile(member: member),
            ),
          ),
        ],
      ),
    );
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile({required this.member});

  final Author member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      child: Row(
        children: [
          UserAvatar(url: member.avatar, radius: 22, userId: member.id),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              member.name,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (member.loc != null ||
              member.gender != null ||
              member.regTime != null) ...[
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (member.regTime != null) ...[
                  Text(
                    formatRelativeTime(member.regTime) ?? '',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (member.gender != null || member.loc != null)
                    const SizedBox(width: 4),
                ],
                if (member.gender != null && member.gender!.isNotEmpty) ...[
                  Text(
                    member.gender!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (member.loc != null) const SizedBox(width: 4),
                ],
                if (member.loc != null)
                  Text(
                    member.loc!.name,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
