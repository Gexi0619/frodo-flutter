import 'package:flutter/material.dart';

import '../models/group.dart';
import '../ui/dimens.dart';
import 'frodo_image.dart';

class GroupCard extends StatelessWidget {
  const GroupCard({super.key, required this.group, this.onTap});

  final Group group;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final memberText = group.memberCountText ??
        (group.memberCount != null ? '${group.memberCount}' : null);
    final desc = group.descAbstract ?? group.subtitle ?? group.slogan;

    return Card(
      color: scheme.surfaceContainerLow,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dim.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dim.radiusMd),
                child: _Avatar(url: group.avatar ?? group.largeAvatar),
              ),
              const SizedBox(width: Dim.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            group.name,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (group.isOfficial == true) ...[
                          const SizedBox(width: Dim.sm),
                          Icon(Icons.verified,
                              size: Dim.iconSm, color: scheme.primary),
                        ],
                      ],
                    ),
                    if (memberText != null || group.topicCount != null) ...[
                      const SizedBox(height: Dim.xs),
                      Text(
                        [
                          if (memberText != null) '$memberText 成员',
                          if (group.topicCount != null)
                            '${group.topicCount} 讨论',
                        ].join(' · '),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: scheme.outline),
                      ),
                    ],
                    if (desc != null && desc.isNotEmpty) ...[
                      const SizedBox(height: Dim.sm),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  static const double _size = 56;

  final String? url;

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      final scheme = Theme.of(context).colorScheme;
      return Container(
        width: _size,
        height: _size,
        color: scheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(Icons.group, color: scheme.outline),
      );
    }
    return FrodoImage.tile(
      imageUrl: url!,
      width: _size,
      height: _size,
      errorIconSize: Dim.iconMd,
    );
  }
}
