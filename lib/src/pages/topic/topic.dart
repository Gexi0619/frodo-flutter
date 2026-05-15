import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/error_view.dart';
import '../../widgets/scroll_to_top_fab.dart';
import 'providers.dart';
import 'sections/comments.dart';
import 'sections/post.dart';

class TopicPage extends ConsumerStatefulWidget {
  const TopicPage({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends ConsumerState<TopicPage> {
  final _scrollController = ScrollController();
  bool _showFab = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.offset > 300;
    if (show != _showFab) setState(() => _showFab = show);
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(topicDetailProvider(widget.topicId));
    final theme = Theme.of(context);
    final topic = async.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('讨论')),
      floatingActionButton: ScrollToTopFab(
        visible: _showFab,
        onPressed: () => _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(topicDetailProvider(widget.topicId));
          ref.read(topicCommentsRefreshTickProvider(widget.topicId).notifier).state++;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (topic != null) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    TopicPost(topic: topic),
                    const Divider(height: 32),
                    Text('评论', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: TopicComments(topicId: topic.id),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ] else if (async.isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else
              SliverFillRemaining(
                hasScrollBody: false,
                child: ErrorView(
                  error: async.error ?? '未知错误',
                  onRetry: () => ref.invalidate(topicDetailProvider(widget.topicId)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
