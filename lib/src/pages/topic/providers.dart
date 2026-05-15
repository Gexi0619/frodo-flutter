import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/topic.dart';
import '../../repositories/topic_repository.dart';

/// 讨论详情数据源（post / comments section 共用）。
final topicDetailProvider =
    FutureProvider.family<Topic, String>((ref, id) async {
  return ref.watch(topicRepositoryProvider).fetchTopic(id);
});

/// 自增即可触发对应 topicId 的评论列表刷新（外壳 RefreshIndicator 用）。
final topicCommentsRefreshTickProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 自增即可触发对应 topicId 的点赞列表刷新。
final topicReactionsRefreshTickProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 自增即可触发对应 topicId 的收藏列表刷新。
final topicCollectionsRefreshTickProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 自增即可触发对应 topicId 的转发列表刷新。
final topicResharersRefreshTickProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);
