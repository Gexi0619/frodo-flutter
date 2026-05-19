import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

/// 项目内统一的网络图片组件。
///
/// 自带豆瓣 CDN 防盗链所需的 Referer header（见 [FrodoConstants.imageHeaders]）。
/// **所有外部图片加载点请使用本组件**，否则在生产环境会被返回 403。
class FrodoImage extends StatelessWidget {
  const FrodoImage({
    super.key,
    required this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.cacheWidth,
    this.cacheHeight,
    this.placeholder,
    this.errorWidget,
  });

  /// 列表 / 卡片缩略图常用：默认 [BoxFit.cover]，placeholder 与错误态
  /// 都用 `surfaceContainerHighest` 占位，错误态可以再叠一个 icon。
  factory FrodoImage.tile({
    Key? key,
    required String imageUrl,
    double? width,
    double? height,
    IconData errorIcon = Icons.broken_image,
    double errorIconSize = 20,
  }) {
    return FrodoImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (ctx) => ColoredBox(
        color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (ctx, _) {
        final scheme = Theme.of(ctx).colorScheme;
        return ColoredBox(
          color: scheme.surfaceContainerHighest,
          child: Icon(errorIcon, size: errorIconSize, color: scheme.outline),
        );
      },
    );
  }

  final String imageUrl;
  final BoxFit? fit;
  final double? width;
  final double? height;

  /// 解码后位图的目标像素尺寸。不传时会从 [width]/[height] × devicePixelRatio
  /// 自动推导；显式传入可覆盖。设为 0 表示禁用降采样（用于全屏 / viewer 等场景）。
  final int? cacheWidth;
  final int? cacheHeight;

  final WidgetBuilder? placeholder;
  final Widget Function(BuildContext context, Object error)? errorWidget;

  /// 把逻辑尺寸换算成解码用的像素尺寸；只有当 dim 是有限正数时才有效。
  static int? _decodePx(double? dim, double dpr) {
    if (dim == null || !dim.isFinite || dim <= 0) return null;
    return (dim * dpr).round().clamp(1, 4096);
  }

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final cw = cacheWidth ?? _decodePx(width, dpr);
    final ch = cacheHeight ?? _decodePx(height, dpr);
    return ExtendedImage.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      headers: FrodoConstants.imageHeaders,
      cache: true,
      cacheWidth: (cw != null && cw > 0) ? cw : null,
      cacheHeight: (ch != null && ch > 0) ? ch : null,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholder?.call(context) ?? const SizedBox.expand();
          case LoadState.failed:
            return errorWidget?.call(context, state.lastException ?? '');
          case LoadState.completed:
            return null;
        }
      },
    );
  }
}
