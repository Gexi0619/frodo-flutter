import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_down_button/pull_down_button.dart';
import '../../models/topic.dart';
import '../../routing/app_routes.dart';
import '../../ui/scroll_behavior.dart';
import '../../utils/parsing.dart';
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

class _TopicPageState extends ConsumerState<TopicPage> with FabVisibilityMixin {
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
  Topic? get _seed => (widget.seed != null && widget.seed!.id == widget.topicId)
      ? widget.seed
      : null;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(topicDetailProvider(widget.topicId));
    final topic = async.valueOrNull ?? _seed;

    // 顶栏使用帖子所属小组的底色，前景色随之取对比色。小组色缺省时回退默认主题色。
    // 从小组内进入（不显示小组名）时不染色，沿用默认主题色。
    final groupColorHex = widget.showGroupLink
        ? topic?.group?.backgroundMaskColor
        : null;
    final appBarBg = groupColorHex != null ? hexToColor(groupColorHex) : null;
    final appBarFg = appBarBg != null ? headerForeground(appBarBg) : null;

    final theme = Theme.of(context);
    final barBg = appBarBg ?? theme.colorScheme.surface;
    final barFg = appBarFg ?? theme.colorScheme.onSurface;

    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: barBg,
          // 染色时隐藏底部细线更干净；默认态给一条弱化分隔线。
          border: appBarBg != null
              ? null
              : Border(
                  bottom: BorderSide(
                    color: barFg.withValues(alpha: 0.12),
                    width: 0.0,
                  ),
                ),
          // 跨路由的 nav bar hero 动画在 Material/Cupertino 混排下易出怪，关掉。
          transitionBetweenRoutes: false,
          padding: const EdgeInsetsDirectional.only(start: 4, end: 8),
          leading: CupertinoNavigationBarBackButton(
            color: barFg,
            onPressed: () => context.pop(),
          ),
          middle: _buildAppBarTitle(topic, barFg),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showScrollToTopFab)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  onPressed: () => animateScrollToTop(_scrollController),
                  child: Icon(CupertinoIcons.arrow_up, color: barFg, size: 22),
                ),
              CupertinoButton(
                padding: const EdgeInsets.only(left: 16),
                minimumSize: Size.zero,
                onPressed: topic == null
                    ? null
                    : () => shareText(
                        '${topic.title}\nhttps://www.douban.com/group/topic/${topic.id}/',
                      ),
                child: Icon(CupertinoIcons.share, color: barFg, size: 22),
              ),
            ],
          ),
        ),
        bottomNavigationBar: topic == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 翻页滑块仅在「回复」tab 显示，置于写评论等互动栏上方。
                  Builder(
                    builder: (context) {
                      final tabController = DefaultTabController.of(context);
                      return AnimatedBuilder(
                        animation: tabController,
                        builder: (_, __) => tabController.index == 0
                            ? CommentPageSlider(topicId: topic.id)
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                  TopicInteraction(topicId: topic.id),
                ],
              ),
        body: _buildBody(topic, async),
      ),
    );
  }

  Widget _buildAppBarTitle(Topic? topic, Color? foreground) {
    final titleStyle = Theme.of(
      context,
    ).textTheme.titleLarge?.copyWith(color: foreground);
    if (_showTopicTitle && topic != null) {
      return GestureDetector(
        onTap: () => animateScrollToTop(_scrollController),
        behavior: HitTestBehavior.opaque,
        child: Text(
          topic.title,
          style: titleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }
    if (!widget.showGroupLink) return const SizedBox.shrink();
    final group = topic?.group;
    if (group == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () => context.push(AppRoutes.group(group.id)),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              group.name,
              style: titleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
          Icon(CupertinoIcons.chevron_right, size: 16, color: foreground),
        ],
      ),
    );
  }

  Widget _buildBody(Topic? topic, AsyncValue<Topic> async) {
    if (topic == null) {
      if (async.isLoading) {
        return const Center(child: CupertinoActivityIndicator());
      }
      return ErrorView(
        error: async.error ?? '未知错误',
        onRetry: () => ref.invalidate(topicDetailProvider(widget.topicId)),
      );
    }

    return Stack(
      children: [
        NestedScrollView(
            controller: _scrollController,
            physics: kRefreshScrollPhysics,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  ref.invalidate(topicDetailProvider(widget.topicId));
                  bumpTopicListsRefresh(ref, widget.topicId);
                },
              ),
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
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: _TabBarDelegate(
                    topicId: topic.id,
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
                _TabBody(
                  sliver: TopicComments(topicId: topic.id),
                  horizontalPadding: 0,
                ),
                _TabBody(sliver: TopicReactions(topicId: topic.id)),
                _TabBody(sliver: TopicResharers(topicId: topic.id)),
                _TabBody(sliver: TopicCollections(topicId: topic.id)),
              ],
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

/// 分段控件里单个段的内容：图标 + 数量（数量缺省时仅图标）。
Widget _segmentLabel(IconData icon, int? count) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16),
        if (count != null) ...[const SizedBox(width: 4), Text('$count')],
      ],
    ),
  );
}

/// 「评论」段右侧的排序按钮：iOS 14 风格 pull-down 菜单（正序/倒序 + 只看楼主），
/// 替代原 [TabBar] 里挂在 tab 上的 [MenuAnchor]。仅「评论」段激活时显示。
class _CommentSortButton extends ConsumerWidget {
  const _CommentSortButton({required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderBy = ref.watch(topicCommentOrderProvider(topicId));
    final isAsc = orderBy != 'time_desc';
    final opOnly = ref.watch(topicCommentOpOnlyProvider(topicId));
    final scheme = Theme.of(context).colorScheme;
    // 任一非默认项（正序 / 只看楼主）生效时高亮，提示"已设置"。
    final active = isAsc || opOnly;

    return PullDownButton(
      itemBuilder: (context) => [
        PullDownMenuItem.selectable(
          title: '正序',
          selected: isAsc,
          onTap: () =>
              ref.read(topicCommentOrderProvider(topicId).notifier).state =
                  'time_asc',
        ),
        PullDownMenuItem.selectable(
          title: '倒序',
          selected: !isAsc,
          onTap: () =>
              ref.read(topicCommentOrderProvider(topicId).notifier).state =
                  'time_desc',
        ),
        const PullDownMenuDivider.large(),
        PullDownMenuItem.selectable(
          title: '只看楼主',
          selected: opOnly,
          onTap: () => ref
              .read(topicCommentOpOnlyProvider(topicId).notifier)
              .update((s) => !s),
        ),
      ],
      buttonBuilder: (context, showMenu) => CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        minimumSize: Size.zero,
        onPressed: showMenu,
        child: Icon(
          CupertinoIcons.arrow_up_arrow_down,
          size: 20,
          color: active ? scheme.primary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// 每个 tab 的内容容器：注入 NestedScrollView 的 overlap 偏移量后再放 sliver。
class _TabBody extends StatelessWidget {
  const _TabBody({required this.sliver, this.horizontalPadding = 16});

  final Widget sliver;

  /// 水平内边距。评论列表传 0，由 CommentTile 自带缩进，使点击区顶到两边。
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
    this.commentsCount,
    this.reactionsCount,
    this.collectionsCount,
    this.resharesCount,
  });

  final String topicId;
  final int? commentsCount;
  final int? reactionsCount;
  final int? collectionsCount;
  final int? resharesCount;

  static const double _tabBarHeight = 48.0;

  @override
  double get minExtent => _tabBarHeight;

  @override
  double get maxExtent => _tabBarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // 分段控件驱动同一个 DefaultTabController：点段 → animateTo；
    // swipe 切 TabBarView → controller 通知 → AnimatedBuilder 把高亮挪过去。
    final controller = DefaultTabController.of(context);
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SizedBox(
        height: _tabBarHeight,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            child: Row(
              children: [
                Expanded(
                  child: CupertinoSlidingSegmentedControl<int>(
                    groupValue: controller.index,
                    onValueChanged: (i) {
                      if (i != null) controller.animateTo(i);
                    },
                    children: {
                      0: _segmentLabel(
                        CupertinoIcons.chat_bubble,
                        commentsCount,
                      ),
                      1: _segmentLabel(
                        CupertinoIcons.hand_thumbsup,
                        reactionsCount,
                      ),
                      2: _segmentLabel(
                        CupertinoIcons.arrow_2_squarepath,
                        resharesCount,
                      ),
                      3: _segmentLabel(
                        CupertinoIcons.bookmark,
                        collectionsCount,
                      ),
                    },
                  ),
                ),
                // 「评论」段激活时，右侧露出排序 pull-down 按钮。
                if (controller.index == 0) _CommentSortButton(topicId: topicId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      topicId != old.topicId ||
      commentsCount != old.commentsCount ||
      reactionsCount != old.reactionsCount ||
      collectionsCount != old.collectionsCount ||
      resharesCount != old.resharesCount;
}
