import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants.dart';
import '../../../models/group.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/group_card.dart';
import '../../../widgets/shimmer_loading.dart';

final joinedGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final paged = await ref
      .watch(groupRepositoryProvider)
      .fetchJoinedGroups(FrodoConstants.defaultUserId);
  return paged.items;
});

class GroupsMineSection extends ConsumerWidget {
  const GroupsMineSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(joinedGroupsProvider);
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(joinedGroupsProvider.future),
      child: async.when(
        loading: () => const ShimmerList(),
        error: (e, _) => ListView(
          children: [
            const SizedBox(height: 80),
            ErrorView(
              error: e,
              onRetry: () => ref.invalidate(joinedGroupsProvider),
            ),
          ],
        ),
        data: (groups) {
          if (groups.isEmpty) {
            return ListView(children: const [
              SizedBox(height: 120),
              Center(child: Text('还没有加入任何小组')),
            ]);
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: groups.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final g = groups[i];
              return GroupCard(
                group: g,
                onTap: () => context.go('/group/${g.id}'),
              )
                  .animate()
                  .fadeIn(duration: 220.ms, delay: (i * 30).ms)
                  .slideY(begin: 0.05, end: 0);
            },
          );
        },
      ),
    );
  }
}
