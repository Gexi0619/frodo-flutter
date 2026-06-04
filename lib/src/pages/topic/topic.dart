import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/topic.dart';
import '../../routing/app_routes.dart';
import '../../widgets/error_view.dart';
import '../../widgets/frodo_image.dart';
import '../../widgets/reading_progress_bar.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../../utils/share.dart';
import 'providers.dart';
import 'sections/collections.dart';
import 'sections/comments.dart';
import 'sections/comments_sort_bar.dart';
import 'sections/interaction.dart';
import 'sections/post.dart';
import 'sections/reactions.dart';
import 'sections/resharers.dart';

class TopicPage extends ConsumerStatefulWidget {
  const TopicPage({
    super.key,
    required this.topicId,
    this.showGroupLink = true,
    this.seed,
  });

  final String topicId;
  final bool showGroupLink;

  /// 来自列表页的"种子"数据，用于在网络请求完成前立即渲染骨架。
  /// 仅当 [seed.id] 与 [topicId] 一致时生效。
  final Topic? seed;

  @override
  ConsumerState<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends ConsumerState<TopicPage>
    with FabVisibilityMixin {
  final _scrollController = ScrollController();
  bool _showTopicTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      updateFabVisibility(_scrollController.offset);
      _updateTitleMode();
    });
  }

  void _updateTitleMode() {
    final show = _scrollController.offset > 0;
    if (show != _showTopicTitle) setState(() => _showTopicTitle = show);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// 仅当 seed 的 id 与当前 topicId 一致时才作为种子使用。
  Topic? get _seed =>
      (widget.seed != null && widget.seed!.id == widget.topicId)
          ? widget.seed
          : null;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(topicDetailProvider(widget.topicId));
    final topic = async.valueOrNull ?? _seed;

    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: _buildAppBarTitle(topic),
          titleSpacing: 0,
          actions: [
            if (showScrollToTopFab)
              IconButton(
                icon: const Icon(Icons.vertical_align_top),
                tooltip: '回到顶部',
                padding: const EdgeInsets.symmetric(horizontal: 4),
                onPressed: () => animateScrollToTop(_scrollController),
              ),
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: '分享',
              padding: const EdgeInsets.symmetric(horizontal: 16),
              onPressed: topic == null
                  ? null
                  : () => shareText(
                        '${topic.title}\nhttps://www.douban.com/group/topic/${topic.id}/',
                      ),
            ),
          ],
        ),
        bottomNavigationBar: topic == null
            ? null
            : TopicInteraction(topicId: topic.id),
        body: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            return AnimatedBuilder(
              animation: tabController,
              builder: (_, __) => _buildBody(
                topic,
                async,
                showSortBar: tabController.index == 1,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBarTitle(Topic? topic) {
    if (_showTopicTitle && topic != null) {
      return GestureDetector(
        onTap: () => animateScrollToTop(_scrollController),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: double.infinity,
          child: Text(
            topic.title,
            style: const TextStyle(fontSize: 17),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    }
    if (!widget.showGroupLink) return const SizedBox.shrink();
    final group = topic?.group;
    if (group == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => context.push(AppRoutes.group(group.id)),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(group.name, style: const TextStyle(fontSize: 17)),
            if (group.avatar != null) ...[
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FrodoImage(
                  imageUrl: group.avatar!,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
            ],
            const Icon(Icons.chevron_right, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(Topic? topic, AsyncValue<Topic> async,
      {bool showSortBar = false}) {
    if (topic == null) {
      if (async.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }
      return ErrorView(
        error: async.error ?? '未知错误',
        onRetry: () => ref.invalidate(topicDetailProvider(widget.topicId)),
      );
    }

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(topicDetailProvider(widget.topicId));
            bumpTopicListsRefresh(ref, widget.topicId);
          },
          child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: TopicPost(
                topic: topic,
                isContentLoading: topic.content == null && async.isLoading,
              ),
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(
                topicId: topic.id,
                showSortBar: showSortBar,
                commentsCount: topic.commentsCount,
                reactionsCount: topic.reactionsCount,
                collectionsCount: topic.collectionsCount,
                resharesCount: topic.resharesCount,
              ),
            ),
          ),
        ],
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _TabBody(sliver: TopicResharers(topicId: topic.id)),
            _TabBody(sliver: TopicComments(topicId: topic.id)),
            _TabBody(sliver: TopicReactions(topicId: topic.id)),
            _TabBody(sliver: TopicCollections(topicId: topic.id)),
          ],
        ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          width: 3,
          child: ReadingProgressBar(controller: _scrollController),
        ),
      ],
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
    required this.topicId,
    required this.showSortBar,
    this.commentsCount,
    this.reactionsCount,
    this.collectionsCount,
    this.resharesCount,
  });

  final String topicId;
  final bool showSortBar;
  final int? commentsCount;
  final int? reactionsCount;
  final int? collectionsCount;
  final int? resharesCount;

  static const double _tabBarHeight = 48.0;
  static const double _sortBarHeight = 48.0;

  double get _height =>
      showSortBar ? _tabBarHeight + _sortBarHeight : _tabBarHeight;

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
      child: Column(
        children: [
          SizedBox(
            height: _tabBarHeight,
            child: TabBar(
              unselectedLabelColor: Colors.grey,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              tabs: [
                Tab(text: _label('转', resharesCount)),
                Tab(text: _label('回复', commentsCount)),
                Tab(text: _label('赞', reactionsCount)),
                Tab(text: _label('收藏', collectionsCount)),
              ],
            ),
          ),
          if (showSortBar)
            SizedBox(
              height: _sortBarHeight,
              child: TopicCommentsSortBar(topicId: topicId),
            ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      showSortBar != old.showSortBar ||
      topicId != old.topicId ||
      commentsCount != old.commentsCount ||
      reactionsCount != old.reactionsCount ||
      collectionsCount != old.collectionsCount ||
      resharesCount != old.resharesCount;
}
