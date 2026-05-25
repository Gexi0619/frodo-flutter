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
