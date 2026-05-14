import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';
import '../../models/group.dart';
import '../../repositories/group_repository.dart';
import '../../widgets/error_view.dart';
import '../../widgets/group_card.dart';

final _joinedGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final page = await ref
      .watch(groupRepositoryProvider)
      .fetchJoinedGroups(FrodoConstants.defaultUserId);
  return page.items;
});

final _recommendedGroupsProvider = FutureProvider<List<Group>>((ref) async {
  return ref.watch(groupRepositoryProvider).fetchRecommended();
});

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joined = ref.watch(_joinedGroupsProvider);
    final recommended = ref.watch(_recommendedGroupsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('小组')),
      body: RefreshIndicator(
        onRefresh: () async => Future.wait([
          ref.refresh(_joinedGroupsProvider.future),
          ref.refresh(_recommendedGroupsProvider.future),
        ]),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const _SectionHeader(title: '我的小组'),
            _GroupsSliver(
              async: joined,
              emptyMessage: '还没有加入任何小组',
              onRetry: () => ref.invalidate(_joinedGroupsProvider),
            ),
            const _SectionHeader(title: '推荐小组'),
            _GroupsSliver(
              async: recommended,
              emptyMessage: '没有推荐内容',
              onRetry: () => ref.invalidate(_recommendedGroupsProvider),
            ),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
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
      loading: () => SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverList.separated(
          itemCount: 3,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, __) => const _ShimmerCard(),
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
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList.separated(
            itemCount: groups.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) => GroupCard(
              group: groups[i],
              onTap: () => context.go('/group/${groups[i].id}'),
            )
                .animate()
                .fadeIn(duration: 220.ms, delay: (i * 30).ms)
                .slideY(begin: 0.05, end: 0),
          ),
        );
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerHighest,
      child: Container(
        height: 96,
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
