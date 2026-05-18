import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'topic_card.dart';

/// 紧凑列表 / 卡片模式切换器。绑定一个 [StateProvider<TopicFeedViewMode>]，
/// 内部 watch + read.notifier.state = ，调用方只需选定要绑哪个 provider。
class TopicViewModeToggle extends ConsumerWidget {
  const TopicViewModeToggle({super.key, required this.provider});

  final StateProvider<TopicFeedViewMode> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(provider);
    return SegmentedButton<TopicFeedViewMode>(
      segments: const [
        ButtonSegment(
          value: TopicFeedViewMode.compact,
          icon: Icon(Icons.view_list_rounded, size: 18),
          tooltip: '紧凑列表',
        ),
        ButtonSegment(
          value: TopicFeedViewMode.card,
          icon: Icon(Icons.view_module_rounded, size: 18),
          tooltip: '卡片模式',
        ),
      ],
      selected: {mode},
      onSelectionChanged: (s) =>
          ref.read(provider.notifier).state = s.first,
      showSelectedIcon: false,
      style: const ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
