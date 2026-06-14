import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/tabbed_search_scaffold.dart';
import '../../widgets/topic_card.dart';
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

class _SearchPageState extends TabbedSearchPageState<SearchPage> {
  final _focusNode = FocusNode();

  @override
  int get tabCount => 4;

  @override
  void initController() {
    final initial = ref.read(searchKeywordProvider);
    textController.text = initial;
    hasText = initial.isNotEmpty;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _clearSearch() {
    textController.clear();
    ref.read(searchKeywordProvider.notifier).state = '';
    _focusNode.requestFocus();
  }

  void _doSearch() {
    ref.read(searchKeywordProvider.notifier).state = textController.text;
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: TextField(
        controller: textController,
        focusNode: _focusNode,
        autofocus: false,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: '搜索全站',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: hasText
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onSubmitted: (_) => _doSearch(),
      ),
      bottom: TabBar(
        controller: tabController,
        tabs: [
          const Tab(text: '综合'),
          Tab(child: _RealtimeViewTab(controller: tabController, index: 1)),
          const Tab(text: '小组'),
          const Tab(text: '用户'),
        ],
      ),
    );
  }

  @override
  List<Widget> buildTabViews() => [
        SearchComprehensiveTab(scrollController: scrollControllers[0]),
        SearchTopicsTab(sort: 'time', scrollController: scrollControllers[1]),
        SearchGroupsTab(scrollController: scrollControllers[2]),
        SearchUsersTab(scrollController: scrollControllers[3]),
      ];
}

/// 「实时」tab：标签 + 下拉箭头，把视图模式收进 tab 自身的下拉菜单，
/// 仿照小组主页的 feed tab。未选中本 tab 时点击先切过来，已选中再点才弹菜单。
class _RealtimeViewTab extends ConsumerWidget {
  const _RealtimeViewTab({required this.controller, required this.index});

  final TabController controller;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(searchRealtimeViewModeProvider);
    final scheme = Theme.of(context).colorScheme;
    // 非默认视图时高亮箭头，提示当前不是动态视图。
    final active = mode != TopicFeedViewMode.card;

    return MenuAnchor(
      builder: (context, menuController, _) => InkWell(
        onTap: () {
          if (controller.index != index) {
            controller.animateTo(index);
          } else if (menuController.isOpen) {
            menuController.close();
          } else {
            menuController.open();
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('实时'),
            Icon(Icons.arrow_drop_down,
                size: 18, color: active ? scheme.primary : null),
          ],
        ),
      ),
      menuChildren: [
        for (final m in TopicFeedViewMode.values)
          MenuItemButton(
            leadingIcon: Icon(mode == m ? Icons.check : null, size: 16),
            onPressed: () =>
                ref.read(searchRealtimeViewModeProvider.notifier).state = m,
            child: Text(_viewModeLabel(m)),
          ),
      ],
    );
  }

  static String _viewModeLabel(TopicFeedViewMode m) => switch (m) {
        TopicFeedViewMode.compact => '紧凑列表',
        TopicFeedViewMode.card => '动态视图',
      };
}
