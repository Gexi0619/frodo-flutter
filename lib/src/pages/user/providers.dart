import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/author.dart';
import '../../models/group.dart';
import '../../models/user.dart';
import '../../repositories/group_repository.dart';
import '../../repositories/user_repository.dart';

/// 用户详情数据源（header 等子区共用）。
final userDetailProvider =
    FutureProvider.family<User, String>((ref, userId) async {
  return ref.watch(userRepositoryProvider).fetchUser(userId);
});

/// 用户主页展示的小组：自己 / 别人通用，不区分创建/加入/关注。
class UserGroups {
  const UserGroups({required this.groups, required this.total});

  /// profile_group_info 返回的小组列表（服务端截断，非完整）。
  final List<Group> groups;

  /// 小组总数（groups_total），用于标题旁的计数。
  final int total;
}

/// 统一用 profile_group_info 拉用户主页的小组，自己和别人走同一接口，
/// 不再区分「创建/加入/关注」。返回扁平列表 + 总数。
final userGroupsProvider =
    FutureProvider.family<UserGroups, String>((ref, userId) async {
  final groupRepo = ref.watch(groupRepositoryProvider);
  final res = await groupRepo.fetchProfileGroups(userId);
  return UserGroups(groups: res.groups, total: res.total);
});

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
