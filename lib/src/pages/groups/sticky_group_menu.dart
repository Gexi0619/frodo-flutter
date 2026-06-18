import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/group.dart';
import 'providers.dart';

/// 长按小组弹出「置顶 / 取消置顶」操作表，确认后翻转状态并给出反馈。
///
/// 首页横向 dock 与「我的小组」整页共用，保证交互一致。
Future<void> showGroupStickyMenu(
  BuildContext context,
  WidgetRef ref,
  Group group,
) async {
  final isSticky = group.isSticky == true;
  HapticFeedback.mediumImpact();
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    builder: (sheetCtx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            title: Text(
              group.name,
              style: Theme.of(sheetCtx).textTheme.titleSmall,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading:
                Icon(isSticky ? Icons.push_pin_outlined : Icons.push_pin),
            title: Text(isSticky ? '取消置顶' : '置顶小组'),
            onTap: () => Navigator.pop(sheetCtx, true),
          ),
        ],
      ),
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final messenger = ScaffoldMessenger.of(context);
  try {
    final nowSticky = await ref.read(stickyGroupControllerProvider).toggle(group);
    messenger.showSnackBar(
      SnackBar(content: Text(nowSticky ? '已置顶' : '已取消置顶')),
    );
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('操作失败：$e')),
    );
  }
}
