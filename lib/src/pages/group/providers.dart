import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/group.dart';
import '../../repositories/group_repository.dart';

/// 小组详情数据源（header / control bar 共用）。
final groupDetailProvider =
    FutureProvider.family<Group, String>((ref, id) async {
  return ref.watch(groupRepositoryProvider).fetchDetail(id);
});

/// 当前选中的 feed_tag sortby（new / hot / elite 等）；
/// null 表示沿用服务端默认（UI 上会回落到第一个 tag 高亮）。
final selectedSortByProvider =
    StateProvider.autoDispose.family<String?, String>((ref, _) => null);

/// 当前选中的 group_tab id；null 表示"全部"。
final selectedGroupTabIdProvider =
    StateProvider.autoDispose.family<String?, String>((ref, _) => null);
