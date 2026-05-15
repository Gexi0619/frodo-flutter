import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/topic.dart';
import '../../repositories/topic_repository.dart';

/// 讨论详情数据源（post / comments section 共用）。
final topicDetailProvider =
    FutureProvider.family<Topic, String>((ref, id) async {
  return ref.watch(topicRepositoryProvider).fetchTopic(id);
});

/// 自增即可同时刷新 topicId 对应的评论 / 点赞 / 收藏 / 转发四个分页列表。
/// 外壳 RefreshIndicator 用 [bumpTopicListsRefresh]，section 用 `ref.listen`。
final topicListsRefreshTickProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 给 [topicListsRefreshTickProvider] 加一，触发所有监听 section 刷新。
void bumpTopicListsRefresh(WidgetRef ref, String topicId) {
  ref.read(topicListsRefreshTickProvider(topicId).notifier).state++;
}
