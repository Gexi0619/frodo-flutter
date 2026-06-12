import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';
import '../ui/dimens.dart';
import '../utils/image_saver.dart';
import 'live_photo.dart';

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
    this.videoUrls,
  });

  final List<String> urls;
  final int initialIndex;
  final String? heroTag;
  final List<String?>? captions;

  /// 与 [urls] 平行的 live 图 mp4 源；元素为 null 表示该项是普通静图。
  final List<String?>? videoUrls;

  static Route<void> route({
    required List<String> urls,
    int initialIndex = 0,
    String? heroTag,
    List<String?>? captions,
    List<String?>? videoUrls,
  }) {
    return PageRouteBuilder<void>(
      opaque: false,
      barrierColor: Colors.transparent,
      pageBuilder: (_, __, ___) => ImageViewerPage(
        urls: urls,
        initialIndex: initialIndex,
        heroTag: heroTag,
        captions: captions,
        videoUrls: videoUrls,
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
                  final isInitial =
                      i == widget.initialIndex && widget.heroTag != null;
                  final videoUrl = (widget.videoUrls != null &&
                          i < widget.videoUrls!.length)
                      ? widget.videoUrls![i]
                      : null;

                  final item = _ViewerItem(
                    url: widget.urls[i],
                    videoUrl: videoUrl,
                    onTap: () => Navigator.pop(context),
                  );

                  if (isInitial) {
                    return Hero(tag: widget.heroTag!, child: item);
                  }
                  return item;
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

/// 浏览器中的单页：普通静图，或 live 图（长按叠加播放 mp4）。
///
/// 静图始终用 [ExtendedImage] 渲染（保留缩放/翻页手势）。当 [videoUrl] 非空时，
/// 长按懒加载 [VideoPlayerController] 循环播放，松手暂停并回到静图。
class _ViewerItem extends StatefulWidget {
  const _ViewerItem({
    required this.url,
    required this.onTap,
    this.videoUrl,
  });

  final String url;
  final String? videoUrl;
  final VoidCallback onTap;

  @override
  State<_ViewerItem> createState() => _ViewerItemState();
}

class _ViewerItemState extends State<_ViewerItem> {
  VideoPlayerController? _controller;
  bool _initializing = false;
  bool _playing = false;

  bool get _isLive => widget.videoUrl != null;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggle() => _playing ? _stopPlayback() : _startPlayback();

  Future<void> _startPlayback() async {
    if (!_isLive || _initializing) return;

    var controller = _controller;
    if (controller == null) {
      setState(() => _initializing = true);
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl!),
        httpHeaders: FrodoConstants.imageHeaders,
      );
      _controller = controller;
      try {
        await controller.initialize();
        await controller.setLooping(true);
      } catch (_) {
        // 初始化失败：丢弃控制器，回退到静图，不打断浏览。
        controller.dispose();
        _controller = null;
        if (mounted) setState(() => _initializing = false);
        return;
      }
      if (!mounted) {
        controller.dispose();
        _controller = null;
        return;
      }
      setState(() => _initializing = false);
    }

    await controller.seekTo(Duration.zero);
    await controller.play();
    if (mounted) setState(() => _playing = true);
  }

  Future<void> _stopPlayback() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.pause();
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final showVideo = _isLive && _playing && controller != null;

    final topPad = MediaQuery.paddingOf(context).top;

    return GestureDetector(
      onTap: widget.onTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ExtendedImage.network(
            widget.url,
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
          if (showVideo)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: VideoPlayer(controller),
                  ),
                ),
              ),
            ),
          if (_isLive)
            Positioned(
              left: Dim.sm,
              top: topPad + Dim.sm,
              child: LiveToggleButton(
                playing: _playing,
                loading: _initializing,
                onTap: _toggle,
              ),
            ),
        ],
      ),
    );
  }
}
