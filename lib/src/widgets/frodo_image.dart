import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

typedef PlaceholderWidgetBuilder =
    Widget Function(BuildContext context, String url);
typedef LoadingErrorWidgetBuilder =
    Widget Function(BuildContext context, String url, Object error);

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
      placeholder: (ctx, _) => ColoredBox(
        color: Theme.of(ctx).colorScheme.surfaceContainerHighest,
      ),
      errorWidget: (ctx, _, __) {
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
  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      headers: FrodoConstants.imageHeaders,
      cache: true,
      loadStateChanged: (state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return placeholder?.call(context, imageUrl) ??
                const SizedBox.expand();
          case LoadState.failed:
            return errorWidget?.call(
              context,
              imageUrl,
              state.lastException ?? '',
            );
          case LoadState.completed:
            return null;
        }
      },
    );
  }
}
