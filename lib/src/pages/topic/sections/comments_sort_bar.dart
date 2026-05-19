import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../widgets/paging_mixin.dart';
import '../providers.dart';

class TopicCommentsSortBar extends ConsumerStatefulWidget {
  const TopicCommentsSortBar({super.key, required this.topicId});

  final String topicId;

  @override
  ConsumerState<TopicCommentsSortBar> createState() =>
      _TopicCommentsSortBarState();
}

class _TopicCommentsSortBarState extends ConsumerState<TopicCommentsSortBar> {
  int _sliderPage = 0; // 0-based 页码
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    final orderBy = ref.watch(topicCommentOrderProvider(widget.topicId));
    final isAsc = orderBy != 'time_desc';
    final total = ref.watch(topicCommentTotalProvider(widget.topicId));
    final totalPages = total > 0 ? (total / kPageSize).ceil() : 0;
    final showSlider = isAsc && totalPages > 1;

    // 外部重置 jumpStart（如切换排序）时同步本地滑块位置
    ref.listen<int>(topicCommentJumpStartProvider(widget.topicId), (_, start) {
      final page = start ~/ kPageSize;
      if (_sliderPage != page) setState(() => _sliderPage = page);
    });
    // 评论列表滚动时，按当前可见首项推算所在页，同步到滑块
    ref.listen<int>(topicCommentVisibleStartProvider(widget.topicId),
        (_, visible) {
      if (_dragging) return;
      final page = visible ~/ kPageSize;
      final clamped = totalPages > 0 ? page.clamp(0, totalPages - 1) : 0;
      if (_sliderPage != clamped) setState(() => _sliderPage = clamped);
    });

    final outlineColor = Theme.of(context).colorScheme.outline;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 4, right: 4),
        child: Row(
          children: [
            if (showSlider) ...[
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 6),
                child: Text(
                  '页码',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: outlineColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  '${_sliderPage + 1}/$totalPages',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: outlineColor),
                ),
              ),
            ],
            Expanded(
              child: showSlider
                  ? SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6),
                        overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14),
                      ),
                      child: Slider(
                        min: 0,
                        max: (totalPages - 1).toDouble(),
                        divisions: totalPages - 1,
                        value: _sliderPage
                            .toDouble()
                            .clamp(0.0, (totalPages - 1).toDouble()),
                        label: '第${_sliderPage + 1}页',
                        onChangeStart: (_) => _dragging = true,
                        onChanged: (v) =>
                            setState(() => _sliderPage = v.round()),
                        onChangeEnd: (v) {
                          _dragging = false;
                          final page = v.round();
                          ref
                              .read(topicCommentJumpStartProvider(widget.topicId)
                                  .notifier)
                              .state = page * kPageSize;
                        },
                      ),
                    )
                  : const SizedBox(),
            ),
            _OpOnlyButton(topicId: widget.topicId),
            _SortButton(topicId: widget.topicId),
          ],
        ),
      ),
    );
  }
}

class _OpOnlyButton extends ConsumerWidget {
  const _OpOnlyButton({required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final opOnly = ref.watch(topicCommentOpOnlyProvider(topicId));
    final scheme = Theme.of(context).colorScheme;
    final color = opOnly ? scheme.onPrimary : scheme.outline;
    final bg = opOnly ? scheme.primary : Colors.transparent;
    return InkWell(
      onTap: () => ref
          .read(topicCommentOpOnlyProvider(topicId).notifier)
          .update((s) => !s),
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        child: Text(
          'OP',
          style:
              Theme.of(context).textTheme.bodySmall?.copyWith(color: color),
        ),
      ),
    );
  }
}

class _SortButton extends ConsumerWidget {
  const _SortButton({required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderBy = ref.watch(topicCommentOrderProvider(topicId));
    final isAsc = orderBy != 'time_desc';
    final color = Theme.of(context).colorScheme.outline;
    return InkWell(
      onTap: () => ref
          .read(topicCommentOrderProvider(topicId).notifier)
          .update((s) => s == 'time_asc' ? 'time_desc' : 'time_asc'),
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scaleY: isAsc ? 1.0 : -1.0,
              child: Icon(Icons.sort, size: 20, color: color),
            ),
            const SizedBox(width: 2),
            Text(
              isAsc ? '正序' : '倒序',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
