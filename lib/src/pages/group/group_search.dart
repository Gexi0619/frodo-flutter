import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/parsing.dart';
import '../../widgets/tabbed_search_scaffold.dart';
import 'providers.dart';
import 'sections/search_topics.dart';

class GroupSearchPage extends ConsumerStatefulWidget {
  const GroupSearchPage({super.key, required this.groupId});

  final String groupId;

  @override
  ConsumerState<GroupSearchPage> createState() => _GroupSearchPageState();
}

class _GroupSearchPageState extends TabbedSearchPageState<GroupSearchPage> {
  String _keyword = '';

  @override
  int get tabCount => 2;

  void _clearSearch() {
    textController.clear();
    setState(() => _keyword = '');
  }

  void _doSearch() {
    setState(() => _keyword = textController.text);
  }

  @override
  PreferredSizeWidget buildAppBar(BuildContext context) {
    final group = ref.watch(groupDetailProvider(widget.groupId)).valueOrNull;
    final bgColor =
        group == null ? null : hexToColor(group.backgroundMaskColor);
    final fgColor = bgColor != null ? contrastOn(bgColor) : null;

    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      iconTheme: fgColor != null ? IconThemeData(color: fgColor) : null,
      title: TextField(
        controller: textController,
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
              if (hasText)
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
        controller: tabController,
        labelColor: fgColor,
        unselectedLabelColor: fgColor?.withValues(alpha: 0.6),
        indicatorColor: fgColor,
        tabs: const [
          Tab(text: '最相关'),
          Tab(text: '最新'),
        ],
      ),
    );
  }

  @override
  List<Widget> buildTabViews() => [
        GroupSearchTopicsTab(
          groupId: widget.groupId,
          keyword: _keyword,
          sort: 'relevance',
          scrollController: scrollControllers[0],
        ),
        GroupSearchTopicsTab(
          groupId: widget.groupId,
          keyword: _keyword,
          sort: 'time',
          scrollController: scrollControllers[1],
        ),
      ];
}
