import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'sections/joined_groups_section.dart';
import 'sections/topics_feed_section.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('小组')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(joinedGroupsProvider);
          ref.read(topicsFeedRefreshTickProvider.notifier).state++;
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            JoinedGroupsSection(
              onRetry: () => ref.invalidate(joinedGroupsProvider),
            ),
            const TopicsFeedSection(),
            const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
          ],
        ),
      ),
    );
  }
}
