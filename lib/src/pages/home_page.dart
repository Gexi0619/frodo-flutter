import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/group.dart';
import '../repositories/group_repository.dart';
import '../widgets/app_drawer.dart';
import '../widgets/error_view.dart';
import '../widgets/group_card.dart';
import '../widgets/shimmer_loading.dart';

final recommendedGroupsProvider = FutureProvider<List<Group>>((ref) async {
  return ref.watch(groupRepositoryProvider).fetchRecommended();
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(recommendedGroupsProvider);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Frodo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '搜索',
            onPressed: () => context.go('/search'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.refresh(recommendedGroupsProvider.future),
        child: groupsAsync.when(
          loading: () => const ShimmerList(),
          error: (e, _) => ListView(
            children: [
              const SizedBox(height: 80),
              ErrorView(
                error: e,
                onRetry: () => ref.invalidate(recommendedGroupsProvider),
              ),
            ],
          ),
          data: (groups) => _GroupList(groups: groups),
        ),
      ),
    );
  }
}

class _GroupList extends StatelessWidget {
  const _GroupList({required this.groups});

  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      return ListView(children: const [
        SizedBox(height: 120),
        Center(child: Text('没有推荐内容')),
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
  }
}
