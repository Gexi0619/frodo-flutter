import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../models/author.dart';
import '../../../repositories/group_repository.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

class SearchUsersTab extends ConsumerStatefulWidget {
  const SearchUsersTab({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  ConsumerState<SearchUsersTab> createState() => _SearchUsersTabState();
}

class _SearchUsersTabState extends ConsumerState<SearchUsersTab>
    with PagingMixin<Author, SearchUsersTab>, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> onLoadPage(int start) async {
    final keyword = ref.read(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }
    final page = await ref.read(groupRepositoryProvider).searchUsers(
          keyword,
          start: start,
          count: kPageSize,
        );
    appendPaged(start, page);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<String>(searchKeywordProvider, (_, __) => pagingController.refresh());

    final keyword = ref.watch(searchKeywordProvider);
    if (keyword.trim().isEmpty) {
      return const Center(child: Text('输入关键词搜索用户'));
    }

    return PagedListView<int, Author>.separated(
      pagingController: pagingController,
      scrollController: widget.scrollController,
      separatorBuilder: (_, __) => const Divider(height: 0.5),
      builderDelegate: frodoPagedDelegate<Author>(
        controller: pagingController,
        emptyText: '没有匹配结果',
        itemBuilder: (context, user, _) => _UserTile(author: user),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.author});

  final Author author;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          UserAvatar(url: author.avatar, radius: 20),
          const SizedBox(width: 12),
          Text(
            author.name,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
