import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/author.dart';
import '../../../models/group.dart';
import '../../../utils/parsing.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/linkified_text.dart';
import '../../../widgets/user_avatar.dart';
import '../providers.dart';

class GroupInfoPage extends ConsumerWidget {
  const GroupInfoPage({super.key, required this.groupId});

  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(groupDetailProvider(groupId));
    final bg = hexToColor(async.valueOrNull?.backgroundMaskColor);
    final onBg = contrastOn(bg);
    return Scaffold(
      appBar: AppBar(
        title: const Text('小组介绍'),
        backgroundColor: bg,
        foregroundColor: onBg,
      ),
      body: async.when(
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (e, _) => ErrorView(
          error: e,
          onRetry: () => ref.invalidate(groupDetailProvider(groupId)),
        ),
        data: (g) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(groupDetailProvider(groupId)),
          child: _Body(group: g),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final hasDesc = group.desc != null && group.desc!.isNotEmpty;
    final hasRules = group.rulesDesc != null && group.rulesDesc!.isNotEmpty;
    final hasSlogan = group.slogan != null && group.slogan!.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _Banner(group: group),
        const SizedBox(height: 16),
        _StatsRow(group: group),
        if (hasSlogan) ...[
          const SizedBox(height: 16),
          _Section(
            title: '宣言',
            child: LinkifiedText(
              group.slogan!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
        if (group.owner != null) ...[
          const SizedBox(height: 16),
          _Section(
            title: '组长',
            child: _OwnerRow(owner: group.owner!),
          ),
        ],
        if (hasDesc) ...[
          const SizedBox(height: 16),
          _Section(
            title: '小组简介',
            child: LinkifiedText(
              group.desc!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.55),
            ),
          ),
        ],
        if (hasRules) ...[
          const SizedBox(height: 16),
          _Section(
            title: '发言规则',
            child: LinkifiedText(
              group.rulesDesc!,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.55),
            ),
          ),
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = hexToColor(group.backgroundMaskColor);
    final onBg = contrastOn(bg);
    final dimmed = onBg.withValues(alpha: 0.75);

    return ColoredBox(
      color: bg,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 72,
                height: 72,
                child: (group.largeAvatar ?? group.avatar) != null
                    ? FrodoImage(
                        imageUrl: group.largeAvatar ?? group.avatar!,
                        fit: BoxFit.cover,
                      )
                    : const ColoredBox(color: Colors.black26),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      group.name,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: onBg,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (group.isOfficial == true) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.verified, size: 18, color: dimmed),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.group});

  final Group group;

  @override
  Widget build(BuildContext context) {
    final memberLabel = group.memberName ?? '成员';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (group.memberCount != null)
            Expanded(
              child: _StatTile(
                label: memberLabel,
                value: group.memberCountText ?? '${group.memberCount}',
              ),
            ),
          if (group.topicCount != null)
            Expanded(
              child: _StatTile(
                label: '讨论',
                value: '${group.topicCount}',
              ),
            ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: theme.colorScheme.outline),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _OwnerRow extends StatelessWidget {
  const _OwnerRow({required this.owner});

  final Author owner;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        UserAvatar(url: owner.avatar, radius: 18, userId: owner.id),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            owner.name,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
