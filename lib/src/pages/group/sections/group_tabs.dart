import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 固定在 [GroupHeader] 之下的分栏条。
/// 依赖外层 [DefaultTabController]，自身仅负责绘制并保持 pinned。
class GroupTabsSliver extends StatelessWidget {
  const GroupTabsSliver({super.key, required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _GroupTabsDelegate(labels: labels),
    );
  }
}

class _GroupTabsDelegate extends SliverPersistentHeaderDelegate {
  _GroupTabsDelegate({required this.labels});

  final List<String> labels;

  static const _height = 48.0;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: overlapsContent ? 1 : 0,
      child: TabBar(
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        tabs: [for (final label in labels) Tab(text: label)],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _GroupTabsDelegate old) =>
      !listEquals(old.labels, labels);
}
