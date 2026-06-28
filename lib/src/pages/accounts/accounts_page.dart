import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_models.dart';
import '../../auth/auth_providers.dart';
import '../../ui/dimens.dart';
import '../../widgets/user_avatar.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(authProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('账号管理'),
        // iOS 习惯：新增入口放导航栏右上角「+」，而非 Material 的悬浮按钮。
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: () => context.push('/login'),
          child: const Icon(CupertinoIcons.add, size: 26),
        ),
      ),
      child: asyncState.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (state) {
          if (state.accounts.isEmpty) return const _EmptyView();
          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: Dim.sm, bottom: Dim.xxl),
              itemCount: state.accounts.length,
              itemBuilder: (_, i) {
                final a = state.accounts[i];
                return _AccountTile(
                  account: a,
                  isActive: a.userId == state.activeUserId,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dim.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.person_crop_circle,
                size: Dim.avatarLg, color: scheme.outline),
            const SizedBox(height: Dim.md),
            Text('还没有添加任何账号', style: theme.textTheme.titleMedium),
            const SizedBox(height: Dim.xs),
            Text(
              '点击右上角加号，用账号密码 / 短信验证码 / Token 登录',
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// 「更多操作」按钮：iOS 风格的省略号，点开 [CupertinoActionSheet]。
Widget _moreButton(Color color, VoidCallback onPressed) => CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Icon(CupertinoIcons.ellipsis, color: color, size: 22),
    );

class _AccountTile extends ConsumerStatefulWidget {
  const _AccountTile({required this.account, required this.isActive});

  final Account account;
  final bool isActive;

  @override
  ConsumerState<_AccountTile> createState() => _AccountTileState();
}

class _AccountTileState extends ConsumerState<_AccountTile> {
  late bool _expanded = widget.isActive;

  /// 当前激活 token 的备注，无备注时回退到 id。
  String _subtitle() {
    final account = widget.account;
    for (final t in account.tokens) {
      if (t.value == account.activeToken) {
        final label = t.label?.trim();
        if (label != null && label.isNotEmpty) return label;
      }
    }
    return 'id ${account.userId}';
  }

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    final isActive = widget.isActive;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(Dim.pageH, Dim.md, Dim.pageH, 0),
      decoration: BoxDecoration(
        color: isActive
            ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(Dim.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // 头部：点按整行展开/收起 token 列表（与原 ExpansionTile 交互一致）。
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dim.lg, vertical: Dim.sm),
              child: Row(
                children: [
                  _AccountAvatar(url: account.avatar, active: isActive),
                  const SizedBox(width: Dim.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(account.name,
                                  style: theme.textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            if (isActive) ...[
                              const SizedBox(width: Dim.sm),
                              _Pill(text: '当前'),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _subtitle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  _moreButton(scheme.outline, _showAccountActions),
                ],
              ),
            ),
          ),
          // token 列表：展开时随高度动画淡入。
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: _expanded
                ? Column(
                    children: [
                      for (final t in account.tokens)
                        _TokenTile(account: account, token: t),
                      const SizedBox(height: Dim.sm),
                    ],
                  )
                : const SizedBox(width: double.infinity),
          ),
        ],
      ),
    );
  }

  Future<void> _showAccountActions() async {
    final account = widget.account;
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: Text(account.name),
        actions: [
          if (!widget.isActive)
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(ctx, 'activate'),
              child: const Text('设为当前账号'),
            ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, 'remove'),
            child: const Text('删除整个账号'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('取消'),
        ),
      ),
    );
    if (action == null || !mounted) return;
    await _onAccountAction(action);
  }

  Future<void> _onAccountAction(String action) async {
    final account = widget.account;
    final notifier = ref.read(authProvider.notifier);
    switch (action) {
      case 'activate':
        await notifier.switchAccount(account.userId);
      case 'remove':
        final ok = await _confirm(
          context,
          title: '删除账号 ${account.name}？',
          body: '将同时删除该账号下的全部 ${account.tokens.length} 个 token。',
        );
        if (ok) await notifier.removeAccount(account.userId);
    }
  }
}

/// 列表头像：当前账号外加一圈主色描边，作为低调的「激活」指示。
class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.url, required this.active});

  final String? url;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final avatar = UserAvatar(url: url, radius: Dim.avatarMd / 2);
    if (!active) return avatar;
    return Container(
      padding: const EdgeInsets.all(Dim.xxs),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: scheme.primary, width: 2),
      ),
      child: avatar,
    );
  }
}

/// 小圆角标签（如「当前」）。
class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dim.sm, vertical: Dim.xxs),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(Dim.radiusSm),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onPrimary),
      ),
    );
  }
}

class _TokenTile extends ConsumerWidget {
  const _TokenTile({required this.account, required this.token});

  final Account account;
  final AccessToken token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title =
        token.label?.isNotEmpty == true ? token.label! : '未命名 token';
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => ref
          .read(authProvider.notifier)
          .switchToken(account.userId, token.value),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: Dim.lg, vertical: Dim.xs),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    _maskedToken(token.value),
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                        fontFamily: 'monospace', color: scheme.outline),
                  ),
                ],
              ),
            ),
            _moreButton(scheme.outline, () => _showTokenActions(context, ref)),
          ],
        ),
      ),
    );
  }

  Future<void> _showTokenActions(BuildContext context, WidgetRef ref) async {
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, 'rename'),
            child: const Text('修改备注'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(ctx, 'copy'),
            child: const Text('复制完整 token'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.pop(ctx, 'remove'),
            child: const Text('删除该 token'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx),
          child: const Text('取消'),
        ),
      ),
    );
    if (action == null || !context.mounted) return;
    await _onTokenAction(context, ref, action);
  }

  Future<void> _onTokenAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
    final notifier = ref.read(authProvider.notifier);
    switch (action) {
      case 'rename':
        final newLabel = await _promptText(
          context,
          title: '修改备注',
          initial: token.label ?? '',
          hint: '如 iPhone / 备用',
        );
        if (newLabel != null) {
          await notifier.renameToken(account.userId, token.value, newLabel);
        }
      case 'copy':
        await Clipboard.setData(ClipboardData(text: token.value));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已复制到剪贴板')),
          );
        }
      case 'remove':
        final ok = await _confirm(
          context,
          title: '删除该 token？',
          body: account.tokens.length == 1
              ? '这是该账号最后一个 token，删除后账号也会一并移除。'
              : '该 token 将立即失效，可重新添加。',
        );
        if (ok) await notifier.removeToken(account.userId, token.value);
    }
  }
}

String _maskedToken(String value) {
  if (value.length <= 8) return value;
  return '${value.substring(0, 4)}…${value.substring(value.length - 4)}';
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String body,
}) async {
  final res = await showCupertinoDialog<bool>(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(body),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('取消'),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('删除'),
        ),
      ],
    ),
  );
  return res ?? false;
}

Future<String?> _promptText(
  BuildContext context, {
  required String title,
  String initial = '',
  String? hint,
}) async {
  final ctrl = TextEditingController(text: initial);
  final res = await showCupertinoDialog<String>(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: CupertinoTextField(
          controller: ctrl,
          autofocus: true,
          placeholder: hint,
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('取消'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx, ctrl.text),
          child: const Text('确定'),
        ),
      ],
    ),
  );
  ctrl.dispose();
  return res;
}
