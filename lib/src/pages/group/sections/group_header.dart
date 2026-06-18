import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/share.dart';

import '../../../models/group.dart';
import '../../../repositories/group_repository.dart';
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
    this.showScrollToTop = false,
    this.onScrollToTop,
  });

  final String groupId;

  /// 标题是否显示的局部可监听位，由外层 [GroupPage] 注入。
  /// 用 [ValueListenable] 而不是 [bool] 是为了让滚动时只重建标题 slot，
  /// 而不是整个 SliverAppBar 子树。
  final ValueListenable<bool> showTitle;

  final VoidCallback? onTitleTap;

  /// 是否显示 topbar 上的"回到顶部"按钮，由外层滚动状态驱动。
  final bool showScrollToTop;

  final VoidCallback? onScrollToTop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupDetailProvider(groupId)).valueOrNull;
    final bg = hexToColor(group?.backgroundMaskColor);
    final fg = headerForeground(bg);
    return SliverAppBar(
      pinned: true,
      forceElevated: true,
      titleSpacing: 0,
      backgroundColor: bg,
      foregroundColor: fg,
      surfaceTintColor: Colors.transparent,
      title: _AppBarTitle(
        group: group,
        visible: showTitle,
        onTap: onTitleTap,
        foreground: fg,
      ),
      actions: [
        if (showScrollToTop)
          IconButton(
            icon: const Icon(Icons.vertical_align_top),
            tooltip: '回到顶部',
            padding: const EdgeInsets.symmetric(horizontal: 4),
            onPressed: onScrollToTop,
          ),
        IconButton(
          icon: const Icon(Icons.search),
          tooltip: '搜索',
          padding: const EdgeInsets.symmetric(horizontal: 4),
          onPressed: () => context.push(AppRoutes.groupSearch(groupId)),
        ),
        IconButton(
          icon: const Icon(Icons.share_outlined),
          tooltip: '分享',
          padding: const EdgeInsets.fromLTRB(4, 0, 16, 0),
          // 数据未加载时按钮禁用，但禁用色对齐前景色，避免与其它图标的颜色不一致。
          disabledColor: fg,
          onPressed: group == null
              ? null
              : () => shareText(
                    '${group.name}\nhttps://www.douban.com/group/$groupId/',
                  ),
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
    final onBg = headerForeground(bg);
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
              crossAxisAlignment: CrossAxisAlignment.center,
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
                const SizedBox(width: 8),
                _JoinButton(group: group, onBg: onBg),
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
                                // 正文用 onBg，与简介一致，避免规则看起来更淡。
                                textColor: onBg,
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
  const _AppBarTitle({
    required this.group,
    required this.visible,
    required this.foreground,
    this.onTap,
  });

  final Group? group;
  final ValueListenable<bool> visible;
  final Color foreground;
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
                Text(
                  group!.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: foreground),
                ),
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

/// 加入按钮：根据 `member_role` 区分 未加入 / 申请中 / 已加入，
/// 仅在"未加入"时可点；`join_type='R'` 时弹窗收集申请理由，'A' 时直接加入。
class _JoinButton extends ConsumerStatefulWidget {
  const _JoinButton({required this.group, required this.onBg});

  final Group group;
  final Color onBg;

  @override
  ConsumerState<_JoinButton> createState() => _JoinButtonState();
}

class _JoinButtonState extends ConsumerState<_JoinButton> {
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final status = widget.group.joinStatus;
    if (status == GroupJoinStatus.unknown) return const SizedBox.shrink();

    final fg = widget.onBg;
    final disabledBg = fg.withValues(alpha: 0.12);
    final disabledFg = fg.withValues(alpha: 0.7);

    switch (status) {
      case GroupJoinStatus.joined:
        return _ChipButton(
          label: '已加入',
          background: disabledBg,
          foreground: disabledFg,
          onTap: null,
        );
      case GroupJoinStatus.applying:
        return _ChipButton(
          label: '申请中',
          background: disabledBg,
          foreground: disabledFg,
          onTap: null,
        );
      case GroupJoinStatus.notJoined:
        return _ChipButton(
          label: _submitting ? '处理中…' : '加入小组',
          background: fg,
          foreground: contrastOn(fg),
          onTap: _submitting ? null : _onTap,
        );
      case GroupJoinStatus.unknown:
        return const SizedBox.shrink();
    }
  }

  Future<void> _onTap() async {
    final group = widget.group;
    final needsReason = group.joinType == 'R';

    String? reason = '';
    if (needsReason) {
      reason = await showDialog<String?>(
        context: context,
        builder: (_) => _JoinDialog(
          groupName: group.name,
          guideText: group.joiningGuide?.text,
        ),
      );
      if (reason == null) return;
    }

    setState(() => _submitting = true);
    try {
      await ref
          .read(groupRepositoryProvider)
          .joinGroup(group.id, reason: reason);
      if (!mounted) return;
      ref.invalidate(groupDetailProvider(group.id));
      // 'A' 直接加入：用 joined_guide 的欢迎语；'R' 仅是提交申请。
      final feedback = needsReason
          ? '已提交申请'
          : (group.joinedGuide?.text ?? '已加入');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(feedback)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加入失败：${_joinErrorMessage(e)}')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

String _joinErrorMessage(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map) {
      return (data['localized_message'] ?? data['msg'] ?? data.toString())
          as String;
    }
    return data?.toString() ?? e.message ?? e.toString();
  }
  return e.toString();
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(6));
    return Material(
      color: background,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ),
    );
  }
}

class _JoinDialog extends StatefulWidget {
  const _JoinDialog({
    required this.groupName,
    required this.guideText,
  });

  final String groupName;
  final String? guideText;

  @override
  State<_JoinDialog> createState() => _JoinDialogState();
}

class _JoinDialogState extends State<_JoinDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guide = widget.guideText;
    return AlertDialog(
      title: Text('申请加入「${widget.groupName}」'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (guide != null && guide.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(guide, style: Theme.of(context).textTheme.bodyMedium),
            ),
          TextField(
            controller: _controller,
            autofocus: true,
            maxLines: 4,
            minLines: 3,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: '请填写申请理由',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            final reason = _controller.text.trim();
            if (reason.isEmpty) return;
            Navigator.of(context).pop(reason);
          },
          child: const Text('提交申请'),
        ),
      ],
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
