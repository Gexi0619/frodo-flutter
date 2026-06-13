import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants.dart';
import '../../models/group.dart';
import '../../repositories/group_repository.dart';

/// GroupsDock 跨页面共享的横向滚动偏移量。
///
/// Dock 在 /groups 与 /group/:id 之间会随页面重建而重新挂载，
/// ScrollController 跟随 widget 生命周期；用这个 provider 把"位置"
/// 这一纯数据跨页面缓存，挂载时还原、滚动时回写。
final groupsDockScrollOffsetProvider = StateProvider<double>((ref) => 0.0);

final joinedGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final page = await ref
      .read(groupRepositoryProvider)
      .fetchJoinedGroups(FrodoConstants.defaultUserId);
  return page.items;
});

/// 「我的小组」整页用：page=home 一并拉「加入 + 关注」的小组，按需翻页拿全量。
/// 每条带 member_role，页面据此分「已加入 / 申请中 / 我关注的」。
final myGroupsProvider = FutureProvider<List<Group>>((ref) async {
  final repo = ref.read(groupRepositoryProvider);
  final all = <Group>[];
  var start = 0;
  // 防御性上限，避免接口异常时无限翻页。
  for (var i = 0; i < 50; i++) {
    final page = await repo.fetchJoinedGroups(
      FrodoConstants.defaultUserId,
      start: start,
      page: 'home',
    );
    all.addAll(page.items);
    start += page.items.length;
    if (page.items.isEmpty || all.length >= page.total) break;
  }
  return all;
});
