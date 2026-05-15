import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/scroll_to_top_fab.dart';
import 'providers.dart';
import 'sections/comprehensive.dart';
import 'sections/groups.dart';
import 'sections/topics.dart';
import 'sections/users.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin, FabVisibilityMixin {
  late final TextEditingController _textController;
  bool _hasText = false;
  late final TabController _tabController;
  late final List<ScrollController> _scrollControllers;

  static const _tabCount = 4;

  @override
  void initState() {
    super.initState();
    // 用 provider 当前值初始化输入框，保证从其它 tab 切回来时
    // 输入框文本与底部结果列表保持一致（provider 跨页面留存）。
    final initial = ref.read(searchKeywordProvider);
    _textController = TextEditingController(text: initial);
    _hasText = initial.isNotEmpty;
    _textController.addListener(_onTextChanged);
    _scrollControllers = List.generate(_tabCount, (_) => ScrollController());
    _tabController = TabController(length: _tabCount, vsync: this)
      ..addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    _tabController.dispose();
    for (final c in _scrollControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    final c = _scrollControllers[_tabController.index];
    updateFabVisibility(c.hasClients ? c.position.pixels : 0.0);
  }

  bool _onScroll(ScrollNotification n) {
    updateFabVisibility(n.metrics.pixels);
    return false;
  }

  void _scrollToTop() =>
      animateScrollToTop(_scrollControllers[_tabController.index]);

  void _onTextChanged() {
    final has = _textController.text.isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  void _clearSearch() {
    _textController.clear();
    ref.read(searchKeywordProvider.notifier).state = '';
  }

  void _doSearch() {
    ref.read(searchKeywordProvider.notifier).state = _textController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: _scrollToTop,
      ),
      appBar: AppBar(
        title: TextField(
          controller: _textController,
          autofocus: false,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: '搜索小组讨论',
            border: InputBorder.none,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_hasText)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _doSearch,
                ),
              ],
            ),
          ),
          onSubmitted: (_) => _doSearch(),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '综合'),
            Tab(text: '实时'),
            Tab(text: '小组'),
            Tab(text: '用户'),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: TabBarView(
          controller: _tabController,
          children: [
            SearchComprehensiveTab(scrollController: _scrollControllers[0]),
            SearchTopicsTab(sort: 'time', scrollController: _scrollControllers[1]),
            SearchGroupsTab(scrollController: _scrollControllers[2]),
            SearchUsersTab(scrollController: _scrollControllers[3]),
          ],
        ),
      ),
    );
  }
}
