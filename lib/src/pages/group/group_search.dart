import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/search_header.dart';
import '../../widgets/tabbed_search_scaffold.dart';
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
    return SearchHeaderBar(
      topPadding: MediaQuery.of(context).padding.top,
      contentHeight: 100,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 12, 6),
          child: Row(
            children: [
              CupertinoNavigationBarBackButton(
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Expanded(
                child: CupertinoSearchTextField(
                  controller: textController,
                  autofocus: true,
                  placeholder: '在小组内搜索',
                  onSubmitted: (_) => _doSearch(),
                  onSuffixTap: _clearSearch,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
          child: TabSegmentedControl(
            controller: tabController,
            labels: const ['最相关', '最新'],
          ),
        ),
      ],
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
