import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/author.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';

/// 用户详情数据源（header 等子区共用）。
final userDetailProvider =
    FutureProvider.family<User, String>((ref, userId) async {
  return ref.watch(userRepositoryProvider).fetchUser(userId);
});

/// 用户加入的小组总数（profile_group_info 的 `groups_total`）。
/// 由「小组」列表加载首页时回写，TabBar 读它显示「小组 N」。未加载时为 null。
final userGroupsTotalProvider =
    StateProvider.family<int?, String>((ref, userId) => null);

/// 用户的关注列表。
final userFollowingProvider =
    FutureProvider.family<List<Author>, String>((ref, userId) async {
  return ref.watch(userRepositoryProvider).fetchFollowing(userId);
});

/// 用户的被关注列表。
final userFollowersProvider =
    FutureProvider.family<List<Author>, String>((ref, userId) async {
  return ref.watch(userRepositoryProvider).fetchFollowers(userId);
});
