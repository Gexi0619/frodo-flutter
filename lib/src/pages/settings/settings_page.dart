import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/cupertino_tappable.dart';
import 'providers.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFont = ref.watch(fontFamilyProvider);
    final currentMode = ref.watch(themeModeProvider);
    final currentSeed = ref.watch(seedColorProvider);
    final currentLayout = ref.watch(groupsLayoutProvider);
    final currentPagerStyle = ref.watch(commentPagerStyleProvider);

    return Scaffold(
      appBar: const CupertinoNavigationBar(middle: Text('设置')),
      body: ListView(
        children: [
          _SectionHeader('外观'),
          _SubLabel('字体'),
          for (final opt in kFontOptions)
            _SelectRow(
              title: opt.label,
              selected: opt.fontFamily == currentFont,
              onTap: () =>
                  ref.read(fontFamilyProvider.notifier).select(opt.fontFamily),
            ),
          _SubLabel('主题'),
          for (final opt in kThemeModeOptions)
            _SelectRow(
              title: opt.label,
              selected: opt.mode == currentMode,
              onTap: () => ref.read(themeModeProvider.notifier).select(opt.mode),
            ),
          _SubLabel('主题色'),
          _SeedColorPicker(
            current: currentSeed,
            onSelect: (c) => ref.read(seedColorProvider.notifier).select(c),
          ),
          _SwitchRow(
            title: '会员头衔使用原色',
            subtitle: '关闭则头衔标签统一用主题色',
            value: ref.watch(memberTitleOriginalColorProvider),
            onChanged: (v) =>
                ref.read(memberTitleOriginalColorProvider.notifier).toggle(v),
          ),
          _SectionHeader('交互'),
          _SwitchRow(
            title: '下滑收起底部栏',
            subtitle: '上滑时自动弹出',
            value: ref.watch(hideNavOnScrollProvider),
            onChanged: (v) => ref.read(hideNavOnScrollProvider.notifier).toggle(v),
          ),
          _SubLabel('小组页布局'),
          for (final opt in kGroupsLayoutOptions)
            _SelectRow(
              title: opt.label,
              subtitle: opt.hint,
              selected: opt.layout == currentLayout,
              onTap: () =>
                  ref.read(groupsLayoutProvider.notifier).select(opt.layout),
            ),
          _SubLabel('评论翻页按钮样式'),
          for (final opt in kCommentPagerStyleOptions)
            _SelectRow(
              title: opt.label,
              subtitle: opt.hint,
              selected: opt.style == currentPagerStyle,
              onTap: () =>
                  ref.read(commentPagerStyleProvider.notifier).select(opt.style),
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
                    ? const Icon(CupertinoIcons.checkmark, color: Colors.white, size: 20)
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

/// iOS 风格的开关行：标题 / 副标题在左，右侧 [CupertinoSwitch]。
/// 与 iOS 设置一致——只有开关本身可切换，点行其它区域不触发。
class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _RowLabel(title: title, subtitle: subtitle)),
          const SizedBox(width: 12),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// iOS 风格的单选行：整行点击选中，选中项右侧打主题色对勾。
class _SelectRow extends StatelessWidget {
  const _SelectRow({
    required this.title,
    this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoTappable(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(child: _RowLabel(title: title, subtitle: subtitle)),
            if (selected) ...[
              const SizedBox(width: 12),
              Icon(
                CupertinoIcons.checkmark,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 设置行通用的标题 + 可选副标题排版。
class _RowLabel extends StatelessWidget {
  const _RowLabel({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodyLarge),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
