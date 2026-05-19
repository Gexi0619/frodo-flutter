import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/tabbed_search_scaffold.dart';
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
        autofocus: true,
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
        tabs: const [
          Tab(text: '综合'),
          Tab(text: '实时'),
          Tab(text: '小组'),
          Tab(text: '用户'),
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
