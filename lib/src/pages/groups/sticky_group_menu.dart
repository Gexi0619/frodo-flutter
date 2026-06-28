import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/group.dart';
import 'providers.dart';

/// 长按小组弹出 iOS 风格 ActionSheet「置顶 / 取消置顶」，确认后翻转状态并给出反馈。
///
/// 首页横向 dock 与「我的小组」整页共用，保证交互一致。
Future<void> showGroupStickyMenu(
  BuildContext context,
  WidgetRef ref,
  Group group,
) async {
  final isSticky = group.isSticky == true;
  HapticFeedback.mediumImpact();
  final confirmed = await showCupertinoModalPopup<bool>(
    context: context,
    builder: (sheetCtx) => CupertinoActionSheet(
      title: Text(group.name),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(sheetCtx, true),
          child: Text(isSticky ? '取消置顶' : '置顶小组'),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(sheetCtx, false),
        child: const Text('取消'),
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
