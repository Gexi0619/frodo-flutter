import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../auth/auth_providers.dart';
import '../../../models/doulist_post.dart';
import '../../../repositories/topic_repository.dart';
import '../../../routing/app_routes.dart';
import '../../topic/providers.dart';
import '../../../widgets/doulist_post_card.dart';
import '../../../widgets/paged_builders.dart';
import '../../../widgets/paging_mixin.dart';

class MyCollectedPosts extends ConsumerStatefulWidget {
  const MyCollectedPosts({super.key});

  @override
  ConsumerState<MyCollectedPosts> createState() => _MyCollectedPostsState();
}

class _MyCollectedPostsState extends ConsumerState<MyCollectedPosts>
    with PagingMixin<DoulistPost, MyCollectedPosts> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  // 当前生效的搜索词；为空表示展示全部收藏。
  String _query = '';

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Future<void> onLoadPage(int start) async {
    final repo = ref.read(topicRepositoryProvider);
    final page = _query.isEmpty
        ? await repo.fetchDoulistPosts(
            ref.read(currentUserIdProvider),
            start: start,
            count: kPageSize,
          )
        : await repo.searchDoulistItems(
            _query,
            start: start,
            count: kPageSize,
          );
    appendPaged(start, page);
  }

  /// 输入即时刷新清除按钮，搜索本身做 400ms 防抖。
  void _onChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _apply(value));
  }

  void _apply(String value) {
    final q = value.trim();
    if (q == _query) return;
    setState(() => _query = q);
    pagingController.refresh();
  }

  void _clear() {
    _debounce?.cancel();
    _searchController.clear();
    setState(() {});
    if (_query.isNotEmpty) {
      setState(() => _query = '');
      pagingController.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          primary: false,
          pinned: true,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          toolbarHeight: 64,
          title: Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: '搜索我的收藏',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _clear,
                      )
                    : null,
                filled: true,
                fillColor: scheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: _onChanged,
              onSubmitted: (v) {
                _debounce?.cancel();
                _apply(v);
              },
            ),
          ),
        ),
        PagedSliverList<int, DoulistPost>.separated(
          pagingController: pagingController,
          separatorBuilder: (_, __) => const Divider(height: 0, thickness: 0.6),
          builderDelegate: frodoPagedDelegate<DoulistPost>(
            controller: pagingController,
            emptyText: _query.isEmpty ? '还没有收录的帖子' : '没有找到相关收藏',
            itemBuilder: (context, post, _) {
              final doulist = post.doulist;
              return DoulistPostCard(
                post: post,
                editableDoulistId: doulist?.id,
                onDoulistTap: doulist != null
                    ? () => context.push(AppRoutes.doulist(doulist.id))
                    : null,
                onTap: () {
                  final id = post.content?.id ?? post.id;
                  prefetchTopic(ref, id);
                  context.push(AppRoutes.topic(id));
                },
              );
            },
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }
}
