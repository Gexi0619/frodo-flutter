import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/topic.dart';
import '../../widgets/error_view.dart';
import '../../widgets/scroll_to_top_fab.dart';
import 'providers.dart';
import 'sections/collections.dart';
import 'sections/comments.dart';
import 'sections/post.dart';
import 'sections/reactions.dart';
import 'sections/resharers.dart';

class TopicPage extends ConsumerStatefulWidget {
  const TopicPage({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends ConsumerState<TopicPage> {
  final _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.offset > 300;
    if (show != _showFab) setState(() => _showFab = show);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(topicDetailProvider(widget.topicId));
    final topic = async.valueOrNull;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(title: const Text('讨论')),
        floatingActionButton: ScrollToTopFab(
          visible: _showFab,
          onPressed: () => _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
          ),
        ),
        body: _buildBody(topic, async),
      ),
    );
  }

  Widget _buildBody(Topic? topic, AsyncValue<Topic> async) {
    if (topic == null) {
      if (async.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return ErrorView(
        error: async.error ?? '未知错误',
        onRetry: () => ref.invalidate(topicDetailProvider(widget.topicId)),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(topicDetailProvider(widget.topicId));
        ref
            .read(topicCommentsRefreshTickProvider(widget.topicId).notifier)
            .state++;
        ref
            .read(topicReactionsRefreshTickProvider(widget.topicId).notifier)
            .state++;
        ref
            .read(topicCollectionsRefreshTickProvider(widget.topicId).notifier)
            .state++;
        ref
            .read(topicResharersRefreshTickProvider(widget.topicId).notifier)
            .state++;
      },
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: TopicPost(topic: topic),
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                commentsCount: topic.commentsCount,
                reactionsCount: topic.reactionsCount,
                collectionsCount: topic.collectionsCount,
                resharesCount: topic.resharesCount,
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            _TabBody(sliver: TopicComments(topicId: topic.id)),
            _TabBody(sliver: TopicReactions(topicId: topic.id)),
            _TabBody(sliver: TopicCollections(topicId: topic.id)),
            _TabBody(sliver: TopicResharers(topicId: topic.id)),
          ],
        ),
      ),
    );
  }
}

/// 每个 tab 的内容容器：注入 NestedScrollView 的 overlap 偏移量后再放 sliver。
class _TabBody extends StatelessWidget {
  const _TabBody({required this.sliver});

  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: sliver,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate({
    this.commentsCount,
    this.reactionsCount,
    this.collectionsCount,
    this.resharesCount,
  });

  final int? commentsCount;
  final int? reactionsCount;
  final int? collectionsCount;
  final int? resharesCount;

  static const double _height = 48.0;

  String _label(String title, int? count) =>
      count != null ? '$title $count' : title;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        tabs: [
          Tab(text: _label('评论', commentsCount)),
          Tab(text: _label('点赞', reactionsCount)),
          Tab(text: _label('收藏', collectionsCount)),
          Tab(text: _label('转发', resharesCount)),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      commentsCount != old.commentsCount ||
      reactionsCount != old.reactionsCount ||
      collectionsCount != old.collectionsCount ||
      resharesCount != old.resharesCount;
}
