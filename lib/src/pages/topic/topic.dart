import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/error_view.dart';
import 'providers.dart';
import 'sections/comments.dart';
import 'sections/post.dart';

class TopicPage extends ConsumerWidget {
  const TopicPage({super.key, required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(topicDetailProvider(topicId));
    final theme = Theme.of(context);
    final topic = async.valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('讨论')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(topicDetailProvider(topicId));
          ref.read(topicCommentsRefreshTickProvider(topicId).notifier).state++;
        },
        child: CustomScrollView(
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
                  onRetry: () => ref.invalidate(topicDetailProvider(topicId)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
