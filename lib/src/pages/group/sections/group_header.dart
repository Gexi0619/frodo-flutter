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
  });

  final String groupId;

  /// 标题是否显示的局部可监听位，由外层 [GroupPage] 注入。
  /// 用 [ValueListenable] 而不是 [bool] 是为了让滚动时只重建标题 slot，
  /// 而不是整个 SliverAppBar 子树。
  final ValueListenable<bool> showTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupDetailProvider(groupId)).valueOrNull;
    return SliverAppBar(
      pinned: true,
      expandedHeight: 220,
      forceElevated: true,
      titleSpacing: 0,
      title: group == null ? null : _AppBarTitle(group: group, visible: showTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 28),
          tooltip: '搜索',
          padding: const EdgeInsets.symmetric(horizontal: 16),
          onPressed: () => context.push(AppRoutes.groupSearch(groupId)),
        ),
      ],
      flexibleSpace:
          group == null ? const FlexibleSpaceBar() : _Background(group: group),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.group});

  final Group group;

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

    final hasDesc = group.desc != null && group.desc!.isNotEmpty;
    final hasRules = group.rulesDesc != null && group.rulesDesc!.isNotEmpty;

    return FlexibleSpaceBar(
      background: ColoredBox(
        color: bg,
        child: Builder(
          builder: (context) {
            final topInset = MediaQuery.of(context).padding.top + kToolbarHeight;
            return Padding(
              padding: EdgeInsets.fromLTRB(16, topInset + 8, 16, 12),
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
                              Text(
                                memberText,
                                style: theme.textTheme.labelSmall
                                    ?.copyWith(color: dimmed),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (hasDesc || hasRules) ...[
                    const SizedBox(height: 8),
                    if (hasDesc)
                      Text(
                        group.desc!,
                        style: theme.textTheme.bodySmall?.copyWith(color: onBg),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (hasDesc && hasRules) const SizedBox(height: 2),
                    if (hasRules)
                      Text(
                        group.rulesDesc!,
                        style:
                            theme.textTheme.bodySmall?.copyWith(color: dimmed),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle({required this.group, required this.visible});

  final Group group;
  final ValueListenable<bool> visible;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: visible,
      builder: (context, v, _) {
        if (!v) return const SizedBox.shrink();
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (group.avatar != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FrodoImage(
                  imageUrl: group.avatar!,
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(group.name, style: const TextStyle(fontSize: 14)),
          ],
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
