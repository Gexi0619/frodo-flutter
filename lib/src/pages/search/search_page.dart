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
    with SingleTickerProviderStateMixin {
  final _textController = TextEditingController();
  bool _hasText = false;
  late final TabController _tabController;
  late final List<ScrollController> _scrollControllers;
  bool _showFab = false;

  static const _tabCount = 4;

  @override
  void initState() {
    super.initState();
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
    final pos = c.hasClients ? c.position.pixels : 0.0;
    final show = pos > 300;
    if (show != _showFab) setState(() => _showFab = show);
  }

  bool _onScroll(ScrollNotification n) {
    final show = n.metrics.pixels > 300;
    if (show != _showFab) setState(() => _showFab = show);
    return false;
  }

  void _scrollToTop() {
    final c = _scrollControllers[_tabController.index];
    if (c.hasClients) {
      c.animateTo(0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic);
    }
  }

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
        visible: _showFab,
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
