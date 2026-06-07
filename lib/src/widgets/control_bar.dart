import 'package:flutter/material.dart';

import '../ui/dimens.dart';

/// 帖子列表的吸顶控件栏外壳：左侧 [leading] 槽、右侧 [trailing] 槽，
/// 统一 surface 背景 + 轻微抬升。具体放什么由调用方决定
/// （小组页放 group_tabs 下拉 + 排序标签，小组主页放 feed 下拉 + 视图切换）。
class ControlBar extends StatelessWidget {
  const ControlBar({super.key, this.leading, this.trailing});

  final Widget? leading;
  final Widget? trailing;

  static const height = 44.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 1,
      surfaceTintColor: Colors.transparent,
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            if (leading != null) leading!,
            const Spacer(),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

/// [ControlBarDropdown] 的一个选项：[value] 用于回写状态，[label] 是菜单与
/// 收起态显示的文案。
class ControlBarOption<T> {
  const ControlBarOption(this.value, this.label);

  final T value;
  final String label;
}

/// 控件栏左侧的下拉选择器：收起态显示当前项文案 + 下拉箭头，点开是
/// PopupMenu。泛型 [T] 不可为 null（PopupMenuButton 把 null 视作"取消"），
/// 需要"全部"这类空值语义时由调用方用 sentinel 值映射。
class ControlBarDropdown<T> extends StatelessWidget {
  const ControlBarDropdown({
    super.key,
    required this.options,
    required this.value,
    required this.onSelected,
    this.tooltip,
  });

  final List<ControlBarOption<T>> options;
  final T value;
  final ValueChanged<T> onSelected;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedLabel = options
            .where((o) => o.value == value)
            .map((o) => o.label)
            .firstOrNull ??
        (options.isNotEmpty ? options.first.label : '');
    return PopupMenuButton<T>(
      tooltip: tooltip,
      initialValue: value,
      onSelected: onSelected,
      itemBuilder: (_) => [
        for (final o in options)
          PopupMenuItem<T>(value: o.value, child: Text(o.label)),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dim.md, vertical: Dim.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedLabel,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: Dim.xxs),
            Icon(Icons.arrow_drop_down,
                size: 20, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
