import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/group.dart';
import '../../../widgets/frodo_image.dart';
import '../providers.dart';

class GroupHeader extends ConsumerWidget {
  const GroupHeader({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(groupDetailProvider(groupId));
    return SliverAppBar(
      pinned: true,
      expandedHeight: 220,
      forceElevated: true,
      flexibleSpace: async.maybeWhen(
        data: (g) => _Background(group: g),
        orElse: () => const FlexibleSpaceBar(),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background({required this.group});

  final Group group;

  Color get _bgColor {
    final hex = group.backgroundMaskColor;
    if (hex == null || hex.isEmpty) return const Color(0xFF6B6B6B);
    final cleaned = hex.replaceFirst('#', '');
    try {
      return Color(int.parse('FF$cleaned', radix: 16));
    } on FormatException {
      return const Color(0xFF6B6B6B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = _bgColor;
    final onBg = ThemeData.estimateBrightnessForColor(bg) == Brightness.dark
        ? Colors.white
        : Colors.black;
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
