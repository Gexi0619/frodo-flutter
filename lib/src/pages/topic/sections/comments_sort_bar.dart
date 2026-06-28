import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../theme.dart';
import '../../../widgets/paging_mixin.dart';
import '../providers.dart';

/// 评论翻页滑块。仅在正序且评论多于一页时显示，否则不占空间。
/// 放置在底部互动栏上方，随评论列表滚动同步当前页，拖动可跳页。
class CommentPageSlider extends ConsumerStatefulWidget {
  const CommentPageSlider({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<CommentPageSlider> createState() => _CommentPageSliderState();
}

class _CommentPageSliderState extends ConsumerState<CommentPageSlider> {
  int _sliderPage = 0; // 0-based 页码
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final orderBy = ref.watch(topicCommentOrderProvider(widget.topicId));
    final isAsc = orderBy != 'time_desc';
    final total = ref.watch(topicCommentTotalProvider(widget.topicId));
    final totalPages = total > 0 ? (total / kPageSize).ceil() : 0;
    final open = ref.watch(topicCommentPagerOpenProvider(widget.topicId));
    final showSlider = isAsc && totalPages > 1 && open;

    // 外部重置 jumpStart（如切换排序）时同步本地滑块位置
    ref.listen<int>(topicCommentJumpStartProvider(widget.topicId), (_, start) {
      final page = start ~/ kPageSize;
      if (_sliderPage != page) setState(() => _sliderPage = page);
    });
    // 评论列表滚动时，按当前可见首项推算所在页，同步到滑块
    ref.listen<int>(topicCommentVisibleStartProvider(widget.topicId), (
      _,
      visible,
    ) {
      if (_dragging) return;
      final page = visible ~/ kPageSize;
      final clamped = totalPages > 0 ? page.clamp(0, totalPages - 1) : 0;
      if (_sliderPage != clamped) setState(() => _sliderPage = clamped);
    });

    if (!showSlider) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final outlineColor = theme.colorScheme.outline;
    final labelStyle = theme.extension<AppTextStyles>()?.micro.copyWith(
      color: outlineColor,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 0.5),
        ),
      ),
      child: SizedBox(
        height: 40,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 4),
          child: Row(
            children: [
              Expanded(
                child: CupertinoSlider(
                  min: 0,
                  max: (totalPages - 1).toDouble(),
                  divisions: totalPages - 1,
                  value: _sliderPage.toDouble().clamp(
                    0.0,
                    (totalPages - 1).toDouble(),
                  ),
                  onChangeStart: (_) => _dragging = true,
                  onChanged: (v) => setState(() => _sliderPage = v.round()),
                  onChangeEnd: (v) {
                    _dragging = false;
                    final page = v.round();
                    ref
                            .read(
                              topicCommentJumpStartProvider(
                                widget.topicId,
                              ).notifier,
                            )
                            .state =
                        page * kPageSize;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Text(
                  '${_sliderPage + 1}/$totalPages 页',
                  style: labelStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 评论排序的下拉入口已迁移到 topic.dart 的 _CommentSortButton
// （iOS pull-down 菜单，挂在分段切换 bar 的「评论」段右侧）。
