import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/group.dart';
import '../../../models/paged.dart';
import '../../../repositories/group_repository.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/group_card.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../providers.dart';
import 'keyword_tab_mixin.dart';

class SearchGroupsTab extends ConsumerStatefulWidget {
  const SearchGroupsTab({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  ConsumerState<SearchGroupsTab> createState() => _SearchGroupsTabState();
}

class _SearchGroupsTabState extends ConsumerState<SearchGroupsTab>
    with
        PagingMixin<Group, SearchGroupsTab>,
        AutomaticKeepAliveClientMixin<SearchGroupsTab>,
        KeywordPagingMixin<Group, SearchGroupsTab> {
  @override
  ProviderListenable<String> get keywordProvider => searchKeywordProvider;

  @override
  String get emptyHint => '输入关键词搜索小组';

  @override
  Future<Paged<Group>> fetchPage(String keyword, int start) =>
      ref.read(groupRepositoryProvider).searchGroups(
            keyword,
            start: start,
            count: kPageSize,
          );

  @override
  Widget buildBody(BuildContext context) {
    return PagedListView<int, Group>(
      pagingController: pagingController,
      scrollController: widget.scrollController,
      builderDelegate: frodoPagedDelegate<Group>(
        controller: pagingController,
        emptyText: '没有匹配结果',
        itemBuilder: (context, group, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: GroupCard(
            group: group,
            onTap: () => context.go(AppRoutes.group(group.id)),
          ),
        ),
      ),
    );
  }
}
