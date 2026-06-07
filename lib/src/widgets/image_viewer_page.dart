import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';

import '../constants.dart';
import '../ui/dimens.dart';
import '../utils/image_saver.dart';

/// 全屏图片浏览页。
///
/// 支持：捏合/双击缩放、下滑收起、横滑翻页、下载到相册。
/// 图片加载使用豆瓣 CDN 所需的 Referer header。
class ImageViewerPage extends StatefulWidget {
  const ImageViewerPage({
    super.key,
    required this.urls,
    this.initialIndex = 0,
    this.heroTag,
    this.captions,
  });

  final List<String> urls;
  final int initialIndex;
  final String? heroTag;
  final List<String?>? captions;

  static Route<void> route({
    required List<String> urls,
    int initialIndex = 0,
    String? heroTag,
    List<String?>? captions,
  }) {
    return PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) => ImageViewerPage(
        urls: urls,
        initialIndex: initialIndex,
        heroTag: heroTag,
        captions: captions,
      ),
    );
  }

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late final ExtendedPageController _pageController;
  late int _current;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageController = ExtendedPageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String? get _currentCaption {
    final captions = widget.captions;
    if (captions == null || _current >= captions.length) return null;
    return captions[_current];
  }

  Future<void> _download() async {
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      await saveImageToGallery(widget.urls[_current]);
      _toast('已保存到相册');
    } on GalException catch (e) {
      _toast(e.type == GalExceptionType.accessDenied ? '无相册写入权限' : '保存失败');
    } catch (_) {
      _toast('保存失败');
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final caption = _currentCaption;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: ExtendedImageSlidePage(
        slideAxis: SlideAxis.vertical,
        slideType: SlideType.wholePage,
        slidePageBackgroundHandler: (offset, pageSize) {
          final progress = (offset.dy.abs() / pageSize.height).clamp(0.0, 1.0);
          return Colors.black.withValues(alpha: 1 - progress);
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: [
              ExtendedImageGesturePageView.builder(
                controller: _pageController,
                itemCount: widget.urls.length,
                onPageChanged: (i) => setState(() => _current = i),
                itemBuilder: (context, i) {
                  final url = widget.urls[i];
                  final isInitial =
                      i == widget.initialIndex && widget.heroTag != null;

                  final image = GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: ExtendedImage.network(
                      url,
                      headers: FrodoConstants.imageHeaders,
                      fit: BoxFit.contain,
                      mode: ExtendedImageMode.gesture,
                      enableSlideOutPage: true,
                      loadStateChanged: (state) =>
                          state.extendedImageLoadState == LoadState.loading
                              ? const SizedBox.expand()
                              : null,
                      initGestureConfigHandler: (state) => GestureConfig(
                        minScale: 0.9,
                        maxScale: 4.0,
                        initialScale: 1.0,
                        inPageView: true,
                        initialAlignment: InitialAlignment.center,
                      ),
                    ),
                  );

                  if (isInitial) {
                    return Hero(tag: widget.heroTag!, child: image);
                  }
                  return image;
                },
              ),
              // 底部：图片说明 + 控制栏
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(Dim.xs, 0, Dim.xs, Dim.sm + bottomPad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (caption != null && caption.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(Dim.md, 0, Dim.md, Dim.sm),
                          child: Text(
                            caption,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      Row(
                        children: [
                          const SizedBox(width: 48),
                          // 第几张
                          Expanded(
                            child: Center(
                              child: widget.urls.length > 1
                                  ? Text(
                                      '${_current + 1} / ${widget.urls.length}',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          // 下载
                          IconButton(
                            icon: _downloading
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.download_outlined),
                            color: Colors.white,
                            onPressed: _downloading ? null : _download,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
