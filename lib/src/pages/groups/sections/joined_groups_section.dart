import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';
import '../../../models/group.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/frodo_image.dart';

final joinedGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final page = await ref
      .watch(groupRepositoryProvider)
      .fetchJoinedGroups(FrodoConstants.defaultUserId);
  return page.items;
});

// 2 rows + spacing + vertical padding
const double _itemWidth = 90.0;
const double _itemHeight = 116.0;
const double _crossSpacing = 6.0;
const double _vertPadding = 12.0;
const double _gridHeight = _vertPadding * 2 + _itemHeight * 2 + _crossSpacing;

class JoinedGroupsSection extends ConsumerWidget {
  const JoinedGroupsSection({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joined = ref.watch(joinedGroupsProvider);
    return SliverMainAxisGroup(
      slivers: [
        _SectionHeader(title: '我的小组'),
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
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w600),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: _vertPadding),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: _crossSpacing,
              mainAxisSpacing: 10,
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: _vertPadding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: _crossSpacing,
                mainAxisSpacing: 10,
                mainAxisExtent: _itemWidth,
              ),
              itemCount: groups.length,
              itemBuilder: (context, i) => _GroupIconItem(
                group: groups[i],
                onTap: () => context.go('/group/${groups[i].id}'),
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

class _GroupIconItem extends StatelessWidget {
  const _GroupIconItem({required this.group, required this.onTap});

  final Group group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = group.avatar ?? group.largeAvatar;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: url != null && url.isNotEmpty
                  ? FrodoImage(
                      imageUrl: url,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 64,
                        height: 64,
                        color: scheme.surfaceContainerHighest,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 64,
                        height: 64,
                        color: scheme.surfaceContainerHighest,
                        child:
                            Icon(Icons.group, color: scheme.outline, size: 30),
                      ),
                    )
                  : Container(
                      width: 64,
                      height: 64,
                      color: scheme.surfaceContainerHighest,
                      child: Icon(Icons.group, color: scheme.outline, size: 30),
                    ),
            ),
            const SizedBox(height: 6),
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
        padding: const EdgeInsets.only(top: 4),
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
            const SizedBox(height: 6),
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
