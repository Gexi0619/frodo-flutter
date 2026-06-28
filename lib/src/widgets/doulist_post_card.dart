import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/doulist_post.dart';
import '../repositories/topic_repository.dart';
import '../ui/cupertino_ux.dart';
import '../ui/dimens.dart';
import '../utils/time.dart';
import 'cupertino_tappable.dart';
import 'topic_card.dart';

/// 豆列收藏条目的动态卡片：复用 [TopicCard] 渲染正文/图片/统计，
/// 顶部显示收藏时间（可选豆列名跳转）+ 右上发表时间，底部显示收藏备注。
/// 豆列详情页与「我的收藏」共用，后者通过 [onDoulistTap] 展示来源豆列。
/// [editableDoulistId] 非空时显示编辑按钮，可修改该帖子的收藏语。
class DoulistPostCard extends ConsumerStatefulWidget {
  const DoulistPostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onDoulistTap,
    this.editableDoulistId,
  });

  final DoulistPost post;
  final VoidCallback? onTap;

  /// 非空时在顶部显示来源豆列名（可点击跳转）。豆列详情页内不需要，传 null。
  final VoidCallback? onDoulistTap;

  /// 非空时允许编辑收藏语，使用该豆列 id 调编辑接口（仅自己的收藏可传）。
  final String? editableDoulistId;

  @override
  ConsumerState<DoulistPostCard> createState() => _DoulistPostCardState();
}

class _DoulistPostCardState extends ConsumerState<DoulistPostCard> {
  // 本地保存收藏语，编辑成功后乐观更新，避免刷新整列。
  late String? _reason = widget.post.collectionReason;

  Future<void> _editReason() async {
    final result = await showPromptDialog(
      context,
      title: '编辑收藏语',
      initial: _reason ?? '',
      placeholder: '写点收藏理由…',
      minLines: 3,
      maxLines: 6,
      maxLength: 200,
      confirmText: '保存',
    );
    if (result == null || !mounted) return; // 取消
    try {
      final updated =
          await ref.read(topicRepositoryProvider).editDoulistItemComment(
                widget.editableDoulistId!,
                // item_id 是豆列条目自身 id（uid），不是帖子 id。
                widget.post.uid ?? widget.post.id,
                result,
              );
      if (!mounted) return;
      setState(() => _reason = updated);
      showToast(context, '已更新收藏语');
    } catch (e) {
      if (!mounted) return;
      showToast(context, '更新失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final topic = post.toTopic();
    if (topic == null) return const SizedBox.shrink();
    final hasReason = _reason != null && _reason!.isNotEmpty;
    return TopicCard(
      topic: topic,
      header: _DoulistPostMeta(
        post: post,
        onDoulistTap: widget.onDoulistTap,
        onEdit: widget.editableDoulistId != null ? _editReason : null,
      ),
      footer: hasReason ? _CollectionReason(reason: _reason!) : null,
      onTap: widget.onTap,
    );
  }
}

/// 卡片顶行：左侧收藏时间（可选来源豆列名），右侧帖子发表时间（可选编辑按钮）。
class _DoulistPostMeta extends StatelessWidget {
  const _DoulistPostMeta({
    required this.post,
    this.onDoulistTap,
    this.onEdit,
  });

  final DoulistPost post;
  final VoidCallback? onDoulistTap;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme.labelSmall?.copyWith(color: scheme.outline);
    final collectTime = formatRelativeDate(post.collectionTime);
    final postTime = formatRelativeTime(post.createdTime);
    final doulist = post.doulist;
    final showDoulist = onDoulistTap != null && doulist != null;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(CupertinoIcons.bookmark_fill,
                  size: 14, color: scheme.outline),
              const SizedBox(width: Dim.xs),
              Flexible(
                child: Text(
                  collectTime.isEmpty ? '收藏' : '收藏于 $collectTime',
                  style: style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showDoulist) ...[
                Text(' · ', style: style),
                Flexible(
                  child: GestureDetector(
                    onTap: onDoulistTap,
                    child: Text(
                      doulist.title,
                      style: theme.textTheme.labelSmall
                          ?.copyWith(color: scheme.primary),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (postTime != null) ...[
          const SizedBox(width: Dim.sm),
          Text('发表于 $postTime', style: style),
        ],
        if (onEdit != null)
          CupertinoTappable(
            onTap: onEdit,
            child: Padding(
              padding: const EdgeInsets.only(left: Dim.sm),
              child: Icon(CupertinoIcons.pencil, size: 15, color: scheme.outline),
            ),
          ),
      ],
    );
  }
}

/// 卡片底部插槽：收录者填写的收藏备注，引用块样式。
class _CollectionReason extends StatelessWidget {
  const _CollectionReason({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Dim.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Dim.radiusSm),
      ),
      child: Text(
        reason,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
          height: 1.45,
        ),
      ),
    );
  }
}
