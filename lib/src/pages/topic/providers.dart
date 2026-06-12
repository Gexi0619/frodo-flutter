import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/collection.dart';
import '../../models/topic.dart';
import '../../repositories/topic_repository.dart';
import '../../widgets/paging_mixin.dart';

/// 讨论详情数据源（post / comments section 共用）。
final topicDetailProvider =
    FutureProvider.autoDispose.family<Topic, String>((ref, id) async {
  return ref.watch(topicRepositoryProvider).fetchTopic(id);
});

/// 路由跳转前预热 [topicDetailProvider]：提前发起网络请求，并用
/// [WidgetRef.listenManual] 维持一个短期监听，桥接到 [TopicPage] 挂载前的
/// autoDispose 真空期。挂载后页面自身的 `ref.watch` 接手生命周期。
void prefetchTopic(
  WidgetRef ref,
  String topicId, {
  Duration keepAlive = const Duration(seconds: 10),
}) {
  final sub = ref.listenManual<AsyncValue<Topic>>(
    topicDetailProvider(topicId),
    (_, __) {},
  );
  Timer(keepAlive, sub.close);
}

/// 自增即可同时刷新 topicId 对应的评论 / 点赞 / 收藏 / 转发四个分页列表。
/// 外壳 RefreshIndicator 用 [bumpTopicListsRefresh]，section 用 `ref.listen`。
final topicListsRefreshTickProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 评论排序方式，'time_asc' 或 'time_desc'。
final topicCommentOrderProvider =
    StateProvider.autoDispose.family<String, String>((ref, _) => 'time_asc');

/// 评论区是否只看楼主。
final topicCommentOpOnlyProvider =
    StateProvider.autoDispose.family<bool, String>((ref, _) => false);

/// 评论区跳页偏移量（正序模式专用），值为 start 参数（0-based）。
final topicCommentJumpStartProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 评论区总条数，首页加载完成后由 TopicComments 写入，供排序栏计算总页数。
final topicCommentTotalProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 评论区当前可见的「首个 item」绝对索引（0-based，含 jumpStart 偏移）。
/// 由 TopicComments 滚动时上报，排序栏据此把滑块定位到对应页。
final topicCommentVisibleStartProvider =
    StateProvider.autoDispose.family<int, String>((ref, _) => 0);

/// 底部翻页滑块是否展开（用户在互动栏手动开关）。
final topicCommentPagerOpenProvider =
    StateProvider.autoDispose.family<bool, String>((ref, _) => false);

/// 翻页滑块是否可用：正序且评论多于一页时才有翻页意义。
/// 同时驱动滑块本身与互动栏里的开关按钮是否出现。
final topicCommentPagerAvailableProvider =
    Provider.autoDispose.family<bool, String>((ref, topicId) {
  final order = ref.watch(topicCommentOrderProvider(topicId));
  final total = ref.watch(topicCommentTotalProvider(topicId));
  final totalPages = total > 0 ? (total / kPageSize).ceil() : 0;
  return order != 'time_desc' && totalPages > 1;
});

/// 给 [topicListsRefreshTickProvider] 加一，触发所有监听 section 刷新。
void bumpTopicListsRefresh(WidgetRef ref, String topicId) {
  ref.read(topicListsRefreshTickProvider(topicId).notifier).state++;
}

// ---------------------------------------------------------------------------
// 点赞
// ---------------------------------------------------------------------------

typedef TopicReactState = ({bool liked, int count});

class TopicReactNotifier
    extends AutoDisposeFamilyNotifier<AsyncValue<TopicReactState>, String> {
  @override
  AsyncValue<TopicReactState> build(String arg) {
    final topic = ref.watch(topicDetailProvider(arg)).valueOrNull;
    if (topic == null) return const AsyncValue.loading();
    return AsyncData((
      liked: topic.reactionType == 1,
      count: topic.reactionsCount ?? 0,
    ));
  }

  Future<void> toggle() async {
    final current = state.valueOrNull;
    if (current == null) return;
    final newLiked = !current.liked;
    state = AsyncData((liked: newLiked, count: current.count));
    try {
      final result =
          await ref.read(topicRepositoryProvider).reactTopic(arg, newLiked ? 1 : 0);
      state = AsyncData((
        liked: result.reactionType == 1,
        count: result.reactionsCount,
      ));
    } catch (_) {
      state = AsyncData(current);
    }
  }
}

final topicReactProvider = NotifierProvider.autoDispose
    .family<TopicReactNotifier, AsyncValue<TopicReactState>, String>(
  TopicReactNotifier.new,
);

// ---------------------------------------------------------------------------
// 收藏
// ---------------------------------------------------------------------------

typedef TopicCollectState = ({bool anyCollected, List<Doulist> doulists});

class TopicCollectNotifier
    extends AutoDisposeFamilyAsyncNotifier<TopicCollectState, String> {
  @override
  Future<TopicCollectState> build(String arg) async {
    final paged = await ref
        .read(topicRepositoryProvider)
        .fetchAvailableDoulists(arg, count: 100);
    final doulists = paged.items;
    return (
      anyCollected: doulists.any((d) => d.isCollected == true),
      doulists: doulists,
    );
  }

  Future<void> toggle(Doulist doulist) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final wasCollected = doulist.isCollected ?? false;
    final updated = current.doulists
        .map((d) =>
            d.id == doulist.id ? d.copyWith(isCollected: !wasCollected) : d)
        .toList();
    state = AsyncData((
      anyCollected: updated.any((d) => d.isCollected == true),
      doulists: updated,
    ));
    try {
      final repo = ref.read(topicRepositoryProvider);
      if (wasCollected) {
        await repo.uncollectTopic(arg, doulist.id);
      } else {
        await repo.collectTopic(arg, doulist.id);
      }
    } catch (_) {
      state = AsyncData(current);
      rethrow;
    }
  }
}

final topicCollectProvider = AsyncNotifierProvider.autoDispose
    .family<TopicCollectNotifier, TopicCollectState, String>(
  TopicCollectNotifier.new,
);
