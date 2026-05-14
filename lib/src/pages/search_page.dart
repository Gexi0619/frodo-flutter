import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/topic.dart';
import '../repositories/group_repository.dart';
import '../widgets/error_view.dart';
import '../widgets/topic_tile.dart';

final searchKeywordProvider = StateProvider<String>((_) => '');

final searchResultsProvider =
    FutureProvider.autoDispose<List<Topic>>((ref) async {
  final q = ref.watch(searchKeywordProvider);
  if (q.trim().isEmpty) return const [];
  final page =
      await ref.watch(groupRepositoryProvider).searchTopics(q, count: 30);
  return page.items;
});

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      ref.read(searchKeywordProvider.notifier).state = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);
    final keyword = ref.watch(searchKeywordProvider);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: false,
          decoration: const InputDecoration(
            hintText: '搜索小组讨论',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
        ),
      ),
      body: keyword.trim().isEmpty
          ? const Center(child: Text('输入关键词搜索小组讨论'))
          : results.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => ErrorView(
                error: e,
                onRetry: () => ref.invalidate(searchResultsProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return const Center(child: Text('没有匹配结果'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 0.5),
                  itemBuilder: (context, i) {
                    final t = items[i];
                    return TopicTile(
                      topic: t,
                      onTap: () => context.go('/search/topic/${t.id}'),
                    );
                  },
                );
              },
            ),
    );
  }
}
