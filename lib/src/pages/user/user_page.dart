import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../constants.dart';
import '../../widgets/error_view.dart';
import '../../widgets/scroll_to_top_fab.dart';
import '../../widgets/sticky_header_sliver.dart';
import 'providers.dart';
import 'sections/groups.dart';
import 'sections/header.dart';
import 'sections/lifestream.dart';

/// 用户主页。
///
/// [userId] 为空时表示「我的」——解析为当前激活账号的 id（兜底到内置 demo id），
/// 同一个页面也能用来看别的用户（传具体 id）。
///
/// 头部下方是嵌套的子页面（TabBar），目前只有「小组」一页，后续可在
/// [_tabs] 增加广播 / 日记等。
class UserPage extends ConsumerStatefulWidget {
  const UserPage({super.key, this.userId});

  final String? userId;

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage>
    with SingleTickerProviderStateMixin, FabVisibilityMixin {
  final _scrollController = ScrollController();
  final _showTitle = ValueNotifier<bool>(false);

  static const _tabs = <String>['动态', '小组'];
  late final TabController _tabController =
      TabController(length: _tabs.length, vsync: this);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _showTitle.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final p = _scrollController.position.pixels;
    updateFabVisibility(p);
    _showTitle.value = p > 0;
  }

  void _scrollToTop() => animateScrollToTop(_scrollController);

  /// 「小组」tab 标题：加载到总数后显示「小组 N」，未加载时只显示「小组」。
  String _groupTabLabel(int? total) => total == null ? '小组' : '小组 $total';

  /// 当前选中子页对应的 sliver。新增 tab 时在这里分发。
  /// 用 ValueKey 保证切 tab 时 sliver 子树被替换（各自的分页状态独立）。
  Widget _tabSliver(String userId) {
    switch (_tabController.index) {
      case 1:
        return UserGroupsView(
          key: ValueKey('groups-$userId'),
          userId: userId,
        );
      case 0:
      default:
        return UserLifestreamView(
          key: ValueKey('lifestream-$userId'),
          userId: userId,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeUserId = ref.watch(activeAccountProvider)?.userId;
    final userId = widget.userId ?? activeUserId ?? FrodoConstants.defaultUserId;
    final isSelf = widget.userId == null || widget.userId == activeUserId;

    final async = ref.watch(userDetailProvider(userId));
    final groupsTotal = ref.watch(userGroupsTotalProvider(userId));

    // 首次加载失败且无缓存数据：整页错误态，其余情况交给 header 自行降级。
    if (async.hasError && !async.hasValue) {
      return Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: async.error!,
          onRetry: () => ref.invalidate(userDetailProvider(userId)),
        ),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(userDetailProvider(userId));
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            UserHeader(
              userId: userId,
              showTitle: _showTitle,
              isSelf: isSelf,
              showScrollToTop: showScrollToTopFab,
              onScrollToTop: _scrollToTop,
            ),
            UserHeaderBackground(userId: userId),
            StickyHeaderSliver(
              height: 48,
              mode: StickyHeaderMode.pinned,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    for (final t in _tabs)
                      Tab(text: t == '小组' ? _groupTabLabel(groupsTotal) : t),
                  ],
                ),
              ),
            ),
            _tabSliver(userId),
          ],
        ),
      ),
    );
  }
}
