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
