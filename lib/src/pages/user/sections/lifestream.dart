import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/lifestream.dart';
import '../../../models/topic.dart';
import '../../../repositories/user_repository.dart';
import '../../../routing/app_routes.dart';
import '../../../theme.dart';
import '../../../utils/link_launcher.dart';
import '../../../utils/time.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/topic_card.dart';
import '../../topic/providers.dart';

/// lifestream 翻页游标：先取 timeslices（首次 [slices]==null），再在每个 slice 内
/// 用 next_filter_after 翻页，翻完一个 slice 就顺移到下一个。
class _Cursor {
  const _Cursor(this.slices, this.sliceIndex, this.filterAfter);

  final List<String>? slices;
  final int sliceIndex;
  final String filterAfter;

  static const initial = _Cursor(null, 0, '');
}

/// 用户主页「动态」子页：混排的动态帖子流，复用 [TopicCard] 渲染。
/// 作为 sliver 嵌进 [UserPage] 的 CustomScrollView。
class UserLifestreamView extends ConsumerStatefulWidget {
  const UserLifestreamView({super.key, required this.userId});

  final String userId;

  @override
  ConsumerState<UserLifestreamView> createState() =>
      _UserLifestreamViewState();
}

class _UserLifestreamViewState extends ConsumerState<UserLifestreamView> {
  late final PagingController<_Cursor, LifestreamItem> _controller;

  @override
  void initState() {
    super.initState();
    _controller = PagingController<_Cursor, LifestreamItem>(
      firstPageKey: _Cursor.initial,
      invisibleItemsThreshold: 8,
    )..addPageRequestListener(_load);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _load(_Cursor cursor) async {
    try {
      final repo = ref.read(userRepositoryProvider);
      final slices =
          cursor.slices ?? await repo.fetchLifestreamTimeslices(widget.userId);
      if (slices.isEmpty) {
        _controller.appendLastPage(const []);
        return;
      }

      var sliceIndex = cursor.sliceIndex;
      var filterAfter = cursor.filterAfter;
      final collected = <LifestreamItem>[];
      _Cursor? next;

      // 单次翻页内最多跨 8 个分片，跳过空分片直到攒到内容或全部翻完，
      // 避免分页器因「空页」停住。
      for (var guard = 0; guard < 8; guard++) {
        if (sliceIndex >= slices.length) {
          next = null;
          break;
        }
        final res = await repo.fetchLifestream(
          widget.userId,
          slice: slices[sliceIndex],
          filterAfter: filterAfter,
        );
        collected.addAll(res.items);
        if (res.nextFilterAfter != null && res.items.isNotEmpty) {
          next = _Cursor(slices, sliceIndex, res.nextFilterAfter!);
        } else {
          sliceIndex += 1;
          filterAfter = '';
          next = sliceIndex < slices.length
              ? _Cursor(slices, sliceIndex, '')
              : null;
        }
        if (collected.isNotEmpty) break;
      }

      if (next == null) {
        _controller.appendLastPage(collected);
      } else {
        _controller.appendPage(collected, next);
      }
    } catch (e) {
      _controller.error = e;
    }
  }

  void _onTap(LifestreamItem item) {
    // 小组讨论直接进站内详情（带 seed 秒开）；其余类型交给 openLink 解析深链。
    if (item.type == 'topic') {
      prefetchTopic(ref, item.topic.id);
      context.push(AppRoutes.topic(item.topic.id), extra: item.topic);
    } else if (item.url != null && item.url!.isNotEmpty) {
      openLink(context, item.url!);
    } else if (item.uri != null && item.uri!.isNotEmpty) {
      openLink(context, item.uri!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PagedSliverList<_Cursor, LifestreamItem>.separated(
      pagingController: _controller,
      separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.3),
      builderDelegate: PagedChildBuilderDelegate<LifestreamItem>(
        itemBuilder: (context, item, _) => TopicCard(
          topic: item.topic,
          header: _ActivityHeader(typeCn: item.typeCn, topic: item.topic),
          onTap: () => _onTap(item),
        ),
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
          child: Center(child: Text('暂无动态')),
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

/// 卡片头部：类型标签（小组讨论 / 广播 …）+ 相对时间，替换 [TopicCard] 默认的
/// 小组信息行。
class _ActivityHeader extends StatelessWidget {
  const _ActivityHeader({required this.typeCn, required this.topic});

  final String? typeCn;
  final Topic topic;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final micro = theme.extension<AppTextStyles>()?.micro;
    final time = formatRelativeTime(topic.updateTime ?? topic.createTime) ?? '';
    return Row(
      children: [
        if (typeCn != null && typeCn!.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: scheme.secondaryContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              typeCn!,
              style: micro?.copyWith(color: scheme.onSecondaryContainer),
            ),
          ),
        const Spacer(),
        if (time.isNotEmpty)
          Text(
            time,
            style: micro?.copyWith(color: scheme.outline),
          ),
      ],
    );
  }
}
