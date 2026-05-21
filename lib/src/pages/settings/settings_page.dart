import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_providers.dart';
import '../../widgets/user_avatar.dart';
import 'providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFont = ref.watch(fontFamilyProvider);
    final currentMode = ref.watch(themeModeProvider);
    final activeAccount = ref.watch(activeAccountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          _SectionHeader('账号'),
          ListTile(
            leading: UserAvatar(url: activeAccount?.avatar, radius: 18),
            title: Text(activeAccount?.name ?? '未登录'),
            subtitle: Text(
              activeAccount == null
                  ? '使用内置 demo token，点此添加自己的账号'
                  : '${activeAccount.tokens.length} 个 token · 点击管理',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(
              activeAccount == null ? '/login' : '/accounts',
            ),
          ),
          _SectionHeader('外观'),
          _SubLabel('字体'),
          RadioGroup<String?>(
            groupValue: currentFont,
            onChanged: (v) => ref.read(fontFamilyProvider.notifier).select(v),
            child: Column(
              children: [
                for (final opt in kFontOptions)
                  RadioListTile<String?>(
                    title: Text(opt.label),
                    value: opt.fontFamily,
                  ),
              ],
            ),
          ),
          _SubLabel('主题'),
          RadioGroup<ThemeMode>(
            groupValue: currentMode,
            onChanged: (v) =>
                ref.read(themeModeProvider.notifier).select(v ?? ThemeMode.system),
            child: Column(
              children: [
                for (final opt in kThemeModeOptions)
                  RadioListTile<ThemeMode>(
                    title: Text(opt.label),
                    value: opt.mode,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}

class _SubLabel extends StatelessWidget {
  const _SubLabel(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
    );
  }
}
