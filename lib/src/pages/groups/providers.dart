import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../models/group.dart';
import '../../repositories/group_repository.dart';

/// GroupsDock 跨页面共享的横向滚动偏移量。
///
/// Dock 在 /groups 与 /group/:id 之间会随页面重建而重新挂载，
/// ScrollController 跟随 widget 生命周期；用这个 provider 把"位置"
/// 这一纯数据跨页面缓存，挂载时还原、滚动时回写。
final groupsDockScrollOffsetProvider = StateProvider<double>((ref) => 0.0);

/// 首页横向小组 dock：用 page=home 一并返回「加入 + 关注」的全部小组。
final joinedGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final page = await ref
      .read(groupRepositoryProvider)
      .fetchJoinedGroups(userId, page: 'home');
  return page.items;
});

/// 置顶 / 取消置顶某小组。
///
/// set_sticky_groups 接口要求**全量**提交当前所有置顶 id，所以这里先从
/// [joinedGroupsProvider] 取现有置顶集合，再加入或移除目标 id 后整体回传，
/// 成功后刷新「我的小组」与整页列表，让钉住标志即时更新。
final stickyGroupControllerProvider =
    Provider<StickyGroupController>((ref) => StickyGroupController(ref));

class StickyGroupController {
  StickyGroupController(this._ref);

  final Ref _ref;

  /// 翻转 [group] 的置顶状态。返回翻转后的目标态（true=已置顶）。
  Future<bool> toggle(Group group) async {
    final repo = _ref.read(groupRepositoryProvider);

    // 全量提交要求拿到当前所有置顶 id。两个入口（首页横向 dock / 我的小组整页）
    // 数据源不同，取两者并集以免漏掉只在某一处加载过的置顶小组。
    final ids = <String>[];
    for (final list in [
      _ref.read(joinedGroupsProvider).valueOrNull,
      _ref.read(myGroupsProvider).valueOrNull,
    ]) {
      for (final g in list ?? const <Group>[]) {
        if (g.isSticky == true && !ids.contains(g.id)) ids.add(g.id);
      }
    }

    final makeSticky = group.isSticky != true;
    if (makeSticky) {
      if (!ids.contains(group.id)) ids.add(group.id);
    } else {
      ids.remove(group.id);
    }

    await repo.setStickyGroups(_ref.read(currentUserIdProvider), ids);
    _ref.invalidate(joinedGroupsProvider);
    _ref.invalidate(myGroupsProvider);
    return makeSticky;
  }
}

/// 「我的小组」整页用：page=home 一并拉「加入 + 关注」的小组，按需翻页拿全量。
/// 每条带 member_role，页面据此分「已加入 / 申请中 / 我关注的」。
final myGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final repo = ref.read(groupRepositoryProvider);
  final all = <Group>[];
  var start = 0;
  // 防御性上限，避免接口异常时无限翻页。
  for (var i = 0; i < 50; i++) {
    final page = await repo.fetchJoinedGroups(
      userId,
      start: start,
      page: 'home',
    );
    all.addAll(page.items);
    start += page.items.length;
    if (page.items.isEmpty || all.length >= page.total) break;
  }
  return all;
});
