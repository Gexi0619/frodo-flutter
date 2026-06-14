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
    final currentSeed = ref.watch(seedColorProvider);
    final currentLayout = ref.watch(groupsLayoutProvider);
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
          _SubLabel('主题色'),
          _SeedColorPicker(
            current: currentSeed,
            onSelect: (c) => ref.read(seedColorProvider.notifier).select(c),
          ),
          _SectionHeader('交互'),
          SwitchListTile(
            title: const Text('下滑收起底部栏'),
            subtitle: const Text('上滑时自动弹出'),
            value: ref.watch(hideNavOnScrollProvider),
            onChanged: (v) => ref.read(hideNavOnScrollProvider.notifier).toggle(v),
          ),
          _SubLabel('小组页布局'),
          RadioGroup<GroupsLayout>(
            groupValue: currentLayout,
            onChanged: (v) => ref
                .read(groupsLayoutProvider.notifier)
                .select(v ?? GroupsLayout.topGrid),
            child: Column(
              children: [
                for (final opt in kGroupsLayoutOptions)
                  RadioListTile<GroupsLayout>(
                    title: Text(opt.label),
                    subtitle: Text(opt.hint),
                    value: opt.layout,
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

/// 一行可横向滚动的圆形色板，当前选中项描边并打勾。
class _SeedColorPicker extends StatelessWidget {
  const _SeedColorPicker({required this.current, required this.onSelect});

  final Color current;
  final ValueChanged<Color> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        itemCount: kSeedColorOptions.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final opt = kSeedColorOptions[i];
          final selected = opt.color.toARGB32() == current.toARGB32();
          return Semantics(
            label: opt.label,
            selected: selected,
            button: true,
            child: GestureDetector(
              onTap: () => onSelect(opt.color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: opt.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? Theme.of(context).colorScheme.onSurface
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
                child: selected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            ),
          );
        },
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
