import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_down_button/pull_down_button.dart';

import '../../widgets/search_header.dart';
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

  static const _tabLabels = ['综合', '实时', '小组', '用户'];

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    // 「实时」tab 的视图模式，watch 以便切换后右侧按钮图标实时更新。
    final viewMode = ref.watch(searchRealtimeViewModeProvider);

    return SearchHeaderBar(
      topPadding: MediaQuery.of(context).padding.top,
      contentHeight: 104,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: CupertinoSearchTextField(
            controller: textController,
            focusNode: _focusNode,
            placeholder: '搜索全站',
            onSubmitted: (_) => _doSearch(),
            onSuffixTap: _clearSearch,
          ),
        ),
        // 段控与 TabBarView 双向同步；「实时」tab（index 1）激活时右侧附带
        // 视图模式切换的 pull-down 菜单。
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: TabSegmentedControl(
            controller: tabController,
            labels: _tabLabels,
            trailingBuilder: (index) => index == 1
                ? PullDownButton(
                    itemBuilder: (context) => [
                      for (final m in TopicFeedViewMode.values)
                        PullDownMenuItem.selectable(
                          title: _viewModeLabel(m),
                          icon: _viewModeIcon(m),
                          selected: viewMode == m,
                          onTap: () => ref
                              .read(searchRealtimeViewModeProvider.notifier)
                              .state = m,
                        ),
                    ],
                    buttonBuilder: (context, showMenu) => CupertinoButton(
                      padding: const EdgeInsets.only(left: 8),
                      minimumSize: Size.zero,
                      onPressed: showMenu,
                      child: Icon(_viewModeIcon(viewMode), size: 22),
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  static IconData _viewModeIcon(TopicFeedViewMode m) => switch (m) {
    TopicFeedViewMode.compact => CupertinoIcons.list_bullet,
    TopicFeedViewMode.card => CupertinoIcons.square_list,
  };

  static String _viewModeLabel(TopicFeedViewMode m) => switch (m) {
    TopicFeedViewMode.compact => '紧凑列表',
    TopicFeedViewMode.card => '动态视图',
  };

  @override
  List<Widget> buildTabViews() => [
    SearchComprehensiveTab(scrollController: scrollControllers[0]),
    SearchTopicsTab(sort: 'time', scrollController: scrollControllers[1]),
    SearchGroupsTab(scrollController: scrollControllers[2]),
    SearchUsersTab(scrollController: scrollControllers[3]),
  ];
}
