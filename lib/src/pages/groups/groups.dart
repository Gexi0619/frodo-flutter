import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/scroll_to_top_fab.dart';
import 'sections/joined_groups_section.dart';
import 'sections/topics_feed_section.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({super.key});

  @override
  ConsumerState<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends ConsumerState<GroupsPage>
    with FabVisibilityMixin {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(
        () => updateFabVisibility(_scrollController.offset));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('小组')),
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: () => animateScrollToTop(_scrollController),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(joinedGroupsProvider);
          ref.read(topicsFeedRefreshTickProvider.notifier).state++;
        },
        child: CustomScrollView(
          controller: _scrollController,
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
