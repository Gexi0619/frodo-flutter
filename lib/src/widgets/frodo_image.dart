import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

/// 项目内统一的网络图片组件。
///
/// 自带豆瓣 CDN 防盗链所需的 Referer header（见 [FrodoConstants.imageHeaders]）。
/// **所有外部图片加载点请使用本组件，不要直连 [CachedNetworkImage]**，
/// 否则在生产环境会被返回 403。
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
    Widget placeholderBox(BuildContext context) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        );
    return FrodoImage(
      key: key,
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (ctx, _) => placeholderBox(ctx),
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
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      httpHeaders: FrodoConstants.imageHeaders,
      fadeInDuration: const Duration(milliseconds: 150),
      fadeOutDuration: const Duration(milliseconds: 75),
      placeholder: placeholder,
      errorWidget: errorWidget,
    );
  }
}
