import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/group.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/count_badge.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/frodo_image.dart';
import '../providers.dart';
import '../sticky_group_menu.dart';

// 2 rows + spacing + vertical padding
const double _itemWidth = 90.0;
const double _itemHeight = 116.0;
const double _crossSpacing = 3.0; // 行与行（上下两行头像）间距
const double _colSpacing = 6.0; // 列与列间距
const double _vertPadding = 12.0; // 网格顶部留白
const double _bottomPadding = 4.0; // 网格底部留白：与下方内容更贴近
const double _gridHeight =
    _vertPadding + _bottomPadding + _itemHeight * 2 + _crossSpacing;

class JoinedGroupsSection extends ConsumerWidget {
  const JoinedGroupsSection({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joined = ref.watch(joinedGroupsProvider);
    return SliverMainAxisGroup(
      slivers: [
        _SectionHeader(
          title: '我的小组',
          onTap: () => context.push(AppRoutes.myGroups()),
        ),
        _GroupsSliver(
          async: joined,
          emptyMessage: '还没有加入任何小组',
          onRetry: onRetry,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
              if (onTap != null) ...[
                const Spacer(),
                Text(
                  '全部',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
                Icon(CupertinoIcons.chevron_right,
                    size: 16, color: theme.colorScheme.outline),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupsSliver extends StatelessWidget {
  const _GroupsSliver({
    required this.async,
    required this.emptyMessage,
    required this.onRetry,
  });

  final AsyncValue<List<Group>> async;
  final String emptyMessage;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return async.when(
      loading: () => SliverToBoxAdapter(
        child: SizedBox(
          height: _gridHeight,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(
                16, _vertPadding, 16, _bottomPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: _crossSpacing,
              mainAxisSpacing: _colSpacing,
              mainAxisExtent: _itemWidth,
            ),
            itemCount: 8,
            itemBuilder: (_, __) => const _ShimmerIcon(),
          ),
        ),
      ),
      error: (e, _) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ErrorView(error: e, onRetry: onRetry),
        ),
      ),
      data: (groups) {
        if (groups.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text(emptyMessage)),
            ),
          );
        }
        return SliverToBoxAdapter(
          child: SizedBox(
            height: _gridHeight,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(
                  16, _vertPadding, 16, _bottomPadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: _crossSpacing,
                mainAxisSpacing: _colSpacing,
                mainAxisExtent: _itemWidth,
              ),
              itemCount: groups.length,
              itemBuilder: (context, i) => _GroupIconItem(
                group: groups[i],
                onTap: () => context.go(AppRoutes.group(groups[i].id)),
              )
                  .animate()
                  .fadeIn(duration: 220.ms, delay: (i * 20).ms)
                  .scale(begin: const Offset(0.85, 0.85), end: const Offset(1, 1)),
            ),
          ),
        );
      },
    );
  }
}

class _GroupIconItem extends ConsumerWidget {
  const _GroupIconItem({required this.group, required this.onTap});

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final url = group.avatar ?? group.largeAvatar;
    // "0"/空 视为无新帖，不显示角标；非纯数字（如理论上的 "99+"）按上限显示。
    final unreadStr = group.unreadCountStr;
    final unread = (unreadStr == null || unreadStr.isEmpty || unreadStr == '0')
        ? 0
        : (int.tryParse(unreadStr) ?? 100);

    final avatarImage = ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: url != null && url.isNotEmpty
          ? FrodoImage.tile(
              imageUrl: url,
              width: 64,
              height: 64,
              errorIcon: CupertinoIcons.group_solid,
              errorIconSize: 30,
            )
          : Container(
              width: 64,
              height: 64,
              color: scheme.surfaceContainerHighest,
              child: Icon(
                CupertinoIcons.group_solid,
                color: scheme.outline,
                size: 30,
              ),
            ),
    );

    // 钉住标志：左上角小图钉，与右上角未读角标互不遮挡。
    final avatar = group.isSticky == true
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              avatarImage,
              Positioned(
                top: -5,
                left: -5,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: scheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    CupertinoIcons.pin_fill,
                    size: 11,
                    color: scheme.onPrimary,
                  ),
                ),
              ),
            ],
          )
        : avatarImage;

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => showGroupStickyMenu(context, ref, group),
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CountBadge.overlay(count: unread, child: avatar),
            const SizedBox(height: 4),
            SizedBox(
              height: 36,
              child: Text(
                group.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShimmerIcon extends StatelessWidget {
  const _ShimmerIcon();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 64,
              height: 12,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 44,
              height: 12,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
