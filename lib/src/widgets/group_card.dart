import 'package:flutter/material.dart';

import '../models/group.dart';
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
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _Avatar(url: group.avatar ?? group.largeAvatar),
              ),
              const SizedBox(width: 12),
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
                          const SizedBox(width: 6),
                          Icon(Icons.verified,
                              size: 16, color: scheme.primary),
                        ],
                      ],
                    ),
                    if (memberText != null || group.topicCount != null) ...[
                      const SizedBox(height: 4),
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
                      const SizedBox(height: 6),
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

  final String? url;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (url == null || url!.isEmpty) {
      return Container(
        width: 56,
        height: 56,
        color: scheme.surfaceContainerHighest,
        alignment: Alignment.center,
        child: Icon(Icons.group, color: scheme.outline),
      );
    }
    return FrodoImage(
      imageUrl: url!,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      placeholder: (_, __) => Container(
        width: 56,
        height: 56,
        color: scheme.surfaceContainerHighest,
      ),
      errorWidget: (_, __, ___) => Container(
        width: 56,
        height: 56,
        color: scheme.surfaceContainerHighest,
        child: Icon(Icons.broken_image, color: scheme.outline),
      ),
    );
  }
}
