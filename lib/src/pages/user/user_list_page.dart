import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/author.dart';
import '../../widgets/error_view.dart';
import '../../widgets/user_tile.dart';
import 'providers.dart';

enum UserListKind { following, followers }

/// 关注 / 被关注 用户列表页。接口一次返回整张表，故用 FutureProvider + 懒加载
/// ListView，不做分页。
class UserListPage extends ConsumerWidget {
  const UserListPage({super.key, required this.userId, required this.kind});

  final String userId;
  final UserListKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFollowing = kind == UserListKind.following;
    final provider =
        isFollowing ? userFollowingProvider : userFollowersProvider;
    final async = ref.watch(provider(userId));

    return Scaffold(
      appBar: CupertinoNavigationBar(middle: Text(isFollowing ? '关注' : '被关注')),
      body: async.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(provider(userId)),
        ),
        data: (List<Author> users) {
          if (users.isEmpty) {
            return Center(child: Text(isFollowing ? '还没有关注的人' : '还没有被关注'));
          }
          return ListView.separated(
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 0.5, indent: 68),
            itemBuilder: (context, i) => UserTile(author: users[i]),
          );
        },
      ),
    );
  }
}
