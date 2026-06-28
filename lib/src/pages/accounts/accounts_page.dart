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

    return Scaffold(
      appBar: AppBar(title: const Text('账号管理')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/login'),
        icon: const Icon(Icons.add),
        label: const Text('添加账号'),
      ),
      body: asyncState.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (state) {
          if (state.accounts.isEmpty) return const _EmptyView();
          return ListView.builder(
            padding: const EdgeInsets.only(top: Dim.sm, bottom: 96),
            itemCount: state.accounts.length,
            itemBuilder: (_, i) {
              final a = state.accounts[i];
              return _AccountTile(
                account: a,
                isActive: a.userId == state.activeUserId,
              );
            },
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
            Icon(Icons.account_circle_outlined,
                size: Dim.avatarLg, color: scheme.outline),
            const SizedBox(height: Dim.md),
            Text('还没有添加任何账号', style: theme.textTheme.titleMedium),
            const SizedBox(height: Dim.xs),
            Text(
              '点击右下角加号，用账号密码 / 短信验证码 / Token 登录',
              style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends ConsumerWidget {
  const _AccountTile({required this.account, required this.isActive});

  final Account account;
  final bool isActive;

  /// 当前激活 token 的备注，无备注时回退到 id。
  String _subtitle() {
    for (final t in account.tokens) {
      if (t.value == account.activeToken) {
        final label = t.label?.trim();
        if (label != null && label.isNotEmpty) return label;
      }
    }
    return 'id ${account.userId}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.fromLTRB(Dim.pageH, Dim.md, Dim.pageH, 0),
      decoration: BoxDecoration(
        color: isActive ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(Dim.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Theme(
        // 去掉 ExpansionTile 展开时的上下分隔线，让卡片更干净。
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isActive,
          tilePadding:
              const EdgeInsets.symmetric(horizontal: Dim.lg, vertical: Dim.xs),
          childrenPadding: const EdgeInsets.only(bottom: Dim.sm),
          leading: _AccountAvatar(url: account.avatar, active: isActive),
          title: Row(
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
          subtitle: Text(_subtitle(),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: scheme.outline),
            onSelected: (v) => _onAccountAction(context, ref, v),
            itemBuilder: (_) => [
              if (!isActive)
                const PopupMenuItem(value: 'activate', child: Text('设为当前账号')),
              const PopupMenuItem(value: 'remove', child: Text('删除整个账号')),
            ],
          ),
          children: [
            for (final t in account.tokens)
              _TokenTile(account: account, token: t),
          ],
        ),
      ),
    );
  }

  Future<void> _onAccountAction(
    BuildContext context,
    WidgetRef ref,
    String action,
  ) async {
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
    final scheme = Theme.of(context).colorScheme;
    final title = token.label?.isNotEmpty == true
        ? token.label!
        : '未命名 token';
    return ListTile(
      dense: true,
      title: Text(title, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        _maskedToken(token.value),
        style: TextStyle(fontFamily: 'monospace', color: scheme.outline),
      ),
      onTap: () => ref
          .read(authProvider.notifier)
          .switchToken(account.userId, token.value),
      trailing: PopupMenuButton<String>(
        onSelected: (v) => _onTokenAction(context, ref, v),
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'rename', child: Text('修改备注')),
          PopupMenuItem(value: 'copy', child: Text('复制完整 token')),
          PopupMenuItem(value: 'remove', child: Text('删除该 token')),
        ],
      ),
    );
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
  final res = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('取消')),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          onPressed: () => Navigator.pop(context, true),
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
  final res = await showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('取消')),
        FilledButton(
          onPressed: () => Navigator.pop(context, ctrl.text),
          child: const Text('确定'),
        ),
      ],
    ),
  );
  ctrl.dispose();
  return res;
}
