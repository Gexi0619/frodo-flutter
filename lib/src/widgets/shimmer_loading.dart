import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 文本段落骨架：N 行灰色横条，最后一行可短一些，模拟自然换行。
class ShimmerTextLines extends StatelessWidget {
  const ShimmerTextLines({
    super.key,
    this.lineCount = 8,
    this.lineHeight = 14,
    this.gap = 10,
    this.lastLineFraction = 0.55,
  });

  final int lineCount;
  final double lineHeight;
  final double gap;
  final double lastLineFraction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < lineCount; i++) ...[
            if (i > 0) SizedBox(height: gap),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: i == lineCount - 1 ? lastLineFraction : 1.0,
              child: Container(
                height: lineHeight,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 评论列表骨架：N 行"头像 + 两段灰条"，对齐 [_CommentTile] 的布局
/// （avatar 32 + spacing 10 = 左缩进 42）。
class ShimmerCommentList extends StatelessWidget {
  const ShimmerCommentList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(4),
          ),
        );
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < itemCount; i++)
            Padding(
              // 水平 16 对齐 CommentTile 的 Dim.lg 内边距，避免占位骨架顶到屏幕边缘。
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHigh,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          bar(80, 11),
                          const SizedBox(height: 4),
                          bar(48, 9),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 42),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.6,
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              color: scheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// DoulistCard 占位骨架：N 张仿 Card 的灰色块，对齐封面图 + 标题 + 作者行布局。
class ShimmerDoulistSection extends StatelessWidget {
  const ShimmerDoulistSection({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    Widget box(double w, double h, {double radius = 4}) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(radius),
          ),
        );
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerHighest,
      child: Column(
        spacing: 8,
        children: [
          for (var i = 0; i < itemCount; i++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  height: 64,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      box(64, 64, radius: 6),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            box(double.infinity, 15),
                            const SizedBox(height: 10),
                            Row(children: [
                              box(16, 16, radius: 8),
                              const SizedBox(width: 6),
                              box(80, 11),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 通用的占位骨架（卡片列表风格）。
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: scheme.surfaceContainerHigh,
        highlightColor: scheme.surfaceContainerHighest,
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
