import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_models.dart';
import '../../auth/auth_providers.dart';
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
        label: const Text('添加 Token'),
      ),
      body: asyncState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
        data: (state) {
          if (state.accounts.isEmpty) return const _EmptyView();
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
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
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_circle_outlined, size: 64, color: scheme.outline),
            const SizedBox(height: 12),
            Text(
              '还没有添加任何账号',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              '点击右下角按钮粘贴 access token',
              style: Theme.of(context).textTheme.bodySmall,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: ExpansionTile(
        initiallyExpanded: isActive,
        leading: UserAvatar(url: account.avatar, radius: 20),
        title: Row(
          children: [
            Flexible(
              child: Text(account.name, overflow: TextOverflow.ellipsis),
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '当前',
                  style: TextStyle(
                    fontSize: 11,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text('id ${account.userId} · ${account.tokens.length} 个 token'),
        trailing: PopupMenuButton<String>(
          onSelected: (v) => _onAccountAction(context, ref, v),
          itemBuilder: (_) => [
            if (!isActive)
              const PopupMenuItem(value: 'activate', child: Text('设为当前账号')),
            const PopupMenuItem(value: 'remove', child: Text('删除整个账号')),
          ],
        ),
        children: [
          for (final t in account.tokens)
            _TokenTile(
              account: account,
              token: t,
              isAccountActive: isActive,
              isTokenActive: t.value == account.activeToken,
            ),
        ],
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

class _TokenTile extends ConsumerWidget {
  const _TokenTile({
    required this.account,
    required this.token,
    required this.isAccountActive,
    required this.isTokenActive,
  });

  final Account account;
  final AccessToken token;
  final bool isAccountActive;
  final bool isTokenActive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final title = token.label?.isNotEmpty == true
        ? token.label!
        : '未命名 token';
    return ListTile(
      dense: true,
      leading: Icon(
        isTokenActive ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isTokenActive ? scheme.primary : scheme.outline,
        size: 20,
      ),
      title: Text(title),
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
          PopupMenuItem(value: 'rename', child: Text('重命名')),
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
          title: '重命名 token',
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
