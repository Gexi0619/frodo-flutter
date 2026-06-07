import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../routing/app_routes.dart';
import '../ui/dimens.dart';
import 'frodo_image.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.url, this.radius = Dim.avatarSm, this.userId});

  final String? url;
  final double radius;

  /// 用户 id。非空时头像可点，点击进入该用户主页（[AppRoutes.user]）。
  /// 列表里某些来源拿不到 id（如搜索结果作者占位），传 null/'' 即退化为纯展示。
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final avatar = _buildAvatar(context);
    final id = userId;
    if (id == null || id.isEmpty) return avatar;
    return GestureDetector(
      onTap: () => context.push(AppRoutes.user(id)),
      child: avatar,
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = radius * 2;
    if (url != null && url!.isNotEmpty) {
      return ClipOval(
        child: FrodoImage(
          imageUrl: url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.surfaceContainerHighest,
      child: Icon(Icons.person, size: radius, color: scheme.outline),
    );
  }
}
