import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_models.dart';
import '../auth/auth_providers.dart';
import '../ui/dimens.dart';
import 'user_avatar.dart';

/// 账号当前激活 token 的备注（label）。无备注时返回 null，由调用方兜底。
String? _activeTokenLabel(Account a) {
  for (final t in a.tokens) {
    if (t.value == a.activeToken) {
      final label = t.label?.trim();
      return (label != null && label.isNotEmpty) ? label : null;
    }
  }
  return null;
}

/// 弹出账号切换面板。[onManage] 在用户点「管理账号」时回调（通常先关掉面板，
/// 再导航到账号管理页）。面板自身负责列出账号、打勾当前账号并执行切换。
void showAccountSwitcher(
  BuildContext context, {
  required VoidCallback onManage,
}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (_) => _AccountSwitcherSheet(onManage: onManage),
  );
}

/// 账号切换面板：列出全部账号，当前账号打勾，点击其他账号即切换。
/// 底部提供「管理账号」入口（增删 / 改名 / token 管理）。
class _AccountSwitcherSheet extends ConsumerWidget {
  const _AccountSwitcherSheet({required this.onManage});

  final VoidCallback onManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = ref.watch(authProvider).valueOrNull;
    final accounts = state?.accounts ?? const [];
    final activeUserId = state?.activeUserId;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(Dim.pageH, 0, Dim.pageH, Dim.sm),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('切换账号', style: theme.textTheme.titleMedium),
            ),
          ),
          for (final a in accounts)
            ListTile(
              leading: UserAvatar(url: a.avatar, radius: Dim.avatarMd / 2),
              title: Text(a.name, overflow: TextOverflow.ellipsis),
              subtitle: Text(
                _activeTokenLabel(a) ?? 'id ${a.userId}',
                overflow: TextOverflow.ellipsis,
              ),
              trailing: a.userId == activeUserId
                  ? Icon(CupertinoIcons.checkmark_circle_fill, color: scheme.primary)
                  : null,
              onTap: () {
                if (a.userId != activeUserId) {
                  ref.read(authProvider.notifier).switchAccount(a.userId);
                }
                Navigator.of(context).pop();
              },
            ),
          const Divider(height: 1),
          ListTile(
            leading:
                Icon(CupertinoIcons.person_2, color: scheme.primary),
            title: const Text('管理账号'),
            onTap: onManage,
          ),
        ],
      ),
    );
  }
}
