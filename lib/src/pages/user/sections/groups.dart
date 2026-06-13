import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/group.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/group_list_tile.dart';
import '../providers.dart';

/// 用户主页「小组」子页：统一用 profile_group_info，自己和别人都走同一接口，
/// 不区分创建/加入/关注。竖排小组列表，start/count 翻页，作为 sliver 嵌进
/// [UserPage] 的 CustomScrollView。
class UserGroupsView extends ConsumerStatefulWidget {
  const UserGroupsView({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UserGroupsView> createState() => _UserGroupsViewState();
}

class _UserGroupsViewState extends ConsumerState<UserGroupsView> {
  static const _pageSize = 20;

  // page key = 下一页的 start 偏移。
  late final PagingController<int, Group> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PagingController<int, Group>(firstPageKey: 0)
      ..addPageRequestListener(_load);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load(int start) async {
    try {
      final page = await ref.read(groupRepositoryProvider).fetchProfileGroups(
            widget.userId,
            start: start,
            count: _pageSize,
          );
      // 首页回写小组总数，给 TabBar 显示「小组 N」。
      if (start == 0) {
        ref.read(userGroupsTotalProvider(widget.userId).notifier).state =
            page.total;
      }
      final nextStart = start + page.items.length;
      // 到底判定：本页为空、本页不足一页（服务端给的比要的少），或已取够 total。
      // 不足一页这条最稳，能兜住 total 字段缺失/不一致的情况。
      final isLast = page.items.isEmpty ||
          page.items.length < _pageSize ||
          nextStart >= page.total;
      if (isLast) {
        _controller.appendLastPage(page.items);
      } else {
        _controller.appendPage(page.items, nextStart);
      }
    } catch (e) {
      _controller.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverList<int, Group>.separated(
      pagingController: _controller,
      separatorBuilder: (_, __) => const Divider(height: 0.5, indent: 84),
      builderDelegate: PagedChildBuilderDelegate<Group>(
        itemBuilder: (context, group, _) => GroupListTile(group: group),
        firstPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: CircularProgressIndicator()),
        ),
        newPageProgressIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: CircularProgressIndicator()),
        ),
        noItemsFoundIndicatorBuilder: (_) => const Padding(
          padding: EdgeInsets.all(48),
          child: Center(child: Text('暂无小组')),
        ),
        firstPageErrorIndicatorBuilder: (_) => Padding(
          padding: const EdgeInsets.all(24),
          child: ErrorView(
            error: _controller.error ?? '未知错误',
            onRetry: _controller.refresh,
          ),
        ),
      ),
    );
  }
}
