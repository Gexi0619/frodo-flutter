import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/parsing.dart';
import '../../widgets/scroll_to_top_fab.dart';
import 'providers.dart';
import 'sections/search_topics.dart';

class GroupSearchPage extends ConsumerStatefulWidget {
  const GroupSearchPage({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupSearchPage> createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends ConsumerState<GroupSearchPage>
    with SingleTickerProviderStateMixin, FabVisibilityMixin {
  final _textController = TextEditingController();
  String _keyword = '';
  bool _hasText = false;
  late final TabController _tabController;
  late final List<ScrollController> _scrollControllers;

  static const _tabCount = 2;

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

  void _onTextChanged() {
    final has = _textController.text.isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
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

  void _clearSearch() {
    _textController.clear();
    setState(() => _keyword = '');
  }

  void _doSearch() {
    setState(() => _keyword = _textController.text);
  }

  @override
  Widget build(BuildContext context) {
    final group = ref.watch(groupDetailProvider(widget.groupId)).valueOrNull;
    final bgColor =
        group == null ? null : hexToColor(group.backgroundMaskColor);
    final fgColor = bgColor != null ? contrastOn(bgColor) : null;

    return Scaffold(
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: _scrollToTop,
      ),
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        iconTheme: fgColor != null ? IconThemeData(color: fgColor) : null,
        title: TextField(
          controller: _textController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: fgColor != null ? TextStyle(color: fgColor) : null,
          cursorColor: fgColor,
          decoration: InputDecoration(
            hintText: '在小组内搜索',
            hintStyle: fgColor != null
                ? TextStyle(color: fgColor.withValues(alpha: 0.6))
                : null,
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
          labelColor: fgColor,
          unselectedLabelColor: fgColor?.withValues(alpha: 0.6),
          indicatorColor: fgColor,
          tabs: const [
            Tab(text: '最相关'),
            Tab(text: '最新'),
          ],
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: TabBarView(
          controller: _tabController,
          children: [
            GroupSearchTopicsTab(
              groupId: widget.groupId,
              keyword: _keyword,
              sort: 'relevance',
              scrollController: _scrollControllers[0],
            ),
            GroupSearchTopicsTab(
              groupId: widget.groupId,
              keyword: _keyword,
              sort: 'time',
              scrollController: _scrollControllers[1],
            ),
          ],
        ),
      ),
    );
  }
}
