import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../models/group.dart';
import '../../../routing/app_routes.dart';
import '../../../utils/parsing.dart';
import '../../../widgets/frodo_image.dart';
import '../providers.dart';

class GroupHeader extends ConsumerWidget {
  const GroupHeader({
    super.key,
    required this.groupId,
    required this.showTitle,
    this.onTitleTap,
  });

  final String groupId;

  /// 标题是否显示的局部可监听位，由外层 [GroupPage] 注入。
  /// 用 [ValueListenable] 而不是 [bool] 是为了让滚动时只重建标题 slot，
  /// 而不是整个 SliverAppBar 子树。
  final ValueListenable<bool> showTitle;

  final VoidCallback? onTitleTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupDetailProvider(groupId)).valueOrNull;
    final bg = hexToColor(group?.backgroundMaskColor);
    return SliverAppBar(
      pinned: true,
      forceElevated: true,
      titleSpacing: 0,
      backgroundColor: bg,
      foregroundColor: contrastOn(bg),
      surfaceTintColor: Colors.transparent,
      title: _AppBarTitle(group: group, visible: showTitle, onTap: onTitleTap),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 28),
          tooltip: '搜索',
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onPressed: () => context.push(AppRoutes.groupSearch(groupId)),
        ),
      ],
    );
  }
}

class GroupHeaderBackground extends ConsumerWidget {
  const GroupHeaderBackground({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupDetailProvider(groupId)).valueOrNull;
    if (group == null) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(
      child: _Background(
        group: group,
        onInfoTap: () => context.push(AppRoutes.groupInfo(groupId)),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.group, required this.onInfoTap});

  final Group group;
  final VoidCallback onInfoTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = hexToColor(group.backgroundMaskColor);
    final onBg = contrastOn(bg);
    final dimmed = onBg.withValues(alpha: 0.75);

    final memberText = [
      if (group.memberCountText != null) group.memberCountText!,
      if (group.memberName != null) group.memberName!,
    ].join(' ');

    final onMembersTap = memberText.isNotEmpty
        ? () => context.push(AppRoutes.groupMembers(group.id))
        : null;

    final hasSlogan = group.slogan != null && group.slogan!.isNotEmpty;
    final hasDesc = group.desc != null && group.desc!.isNotEmpty;
    final hasRules = group.rulesDesc != null && group.rulesDesc!.isNotEmpty;

    return ColoredBox(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Avatar(url: group.avatar, size: 56),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        group.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: onBg,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (memberText.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: onMembersTap,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                memberText,
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: dimmed),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Icon(Icons.chevron_right,
                                  size: 14, color: dimmed),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            if (hasSlogan || hasDesc || hasRules) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: onInfoTap,
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasSlogan)
                              _LabeledLine(
                                label: '宣言',
                                text: group.slogan!,
                                labelColor: dimmed,
                                textColor: onBg,
                                theme: theme,
                              ),
                            if (hasSlogan && hasDesc)
                              const SizedBox(height: 2),
                            if (hasDesc)
                              _LabeledLine(
                                label: '简介',
                                text: group.desc!,
                                labelColor: dimmed,
                                textColor: onBg,
                                theme: theme,
                                maxLines: 2,
                              ),
                            if ((hasSlogan || hasDesc) && hasRules)
                              const SizedBox(height: 2),
                            if (hasRules)
                              _LabeledLine(
                                label: '规则',
                                text: group.rulesDesc!,
                                labelColor: dimmed,
                                textColor: dimmed,
                                theme: theme,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 18, color: dimmed),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.group, required this.visible, this.onTap});

  final Group? group;
  final ValueListenable<bool> visible;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, v, _) {
        if (!v || group == null) return const SizedBox(width: double.infinity);
        return GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (group!.avatar != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FrodoImage(
                      imageUrl: group!.avatar!,
                      width: 28,
                      height: 28,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                Text(group!.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url, required this.size});

  final String? url;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        width: size,
        height: size,
        child: url != null
            ? FrodoImage(imageUrl: url!, fit: BoxFit.cover)
            : const ColoredBox(color: Colors.black26),
      ),
    );
  }
}

class _LabeledLine extends StatelessWidget {
  const _LabeledLine({
    required this.label,
    required this.text,
    required this.labelColor,
    required this.textColor,
    required this.theme,
    this.maxLines = 1,
  });

  final String label;
  final String text;
  final Color labelColor;
  final Color textColor;
  final ThemeData theme;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: labelColor,
      fontWeight: FontWeight.w600,
    );
    final textStyle = theme.textTheme.labelSmall?.copyWith(color: textColor);
    final flat = text.replaceAll(RegExp(r'\s+'), ' ').trim();
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '$label  ', style: labelStyle),
          TextSpan(text: flat, style: textStyle),
        ],
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
