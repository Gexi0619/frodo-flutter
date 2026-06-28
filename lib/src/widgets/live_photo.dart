import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';
import '../ui/dimens.dart';

/// Live 图组件：默认显示静态图，左上角叠一个圆形 LIVE 按钮。
///
/// 点击按钮切换为内联循环播放 mp4；再次点击按钮（或点视频区域）暂停回到静态图。
/// 视频懒加载，初始化失败时静默回退到静图。
class LivePhoto extends StatefulWidget {
  const LivePhoto({
    super.key,
    required this.image,
    required this.videoUrl,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  /// 静态图 widget（已自行处理裁剪 / 尺寸 / AspectRatio）。
  final Widget image;

  /// live 图的 mp4 源。
  final String videoUrl;

  /// 视频叠层的圆角，应与 [image] 的裁剪保持一致。
  final BorderRadius borderRadius;

  @override
  State<LivePhoto> createState() => _LivePhotoState();
}

class _LivePhotoState extends State<LivePhoto> {
  VideoPlayerController? _controller;
  bool _initializing = false;
  bool _playing = false;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggle() => _playing ? _stop() : _start();

  Future<void> _start() async {
    if (_initializing) return;

    var controller = _controller;
    if (controller == null) {
      setState(() => _initializing = true);
      controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
        httpHeaders: FrodoConstants.imageHeaders,
      );
      _controller = controller;
      try {
        await controller.initialize();
        await controller.setLooping(true);
      } catch (_) {
        // 初始化失败：丢弃控制器，回退到静图。
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

  Future<void> _stop() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.pause();
    if (mounted) setState(() => _playing = false);
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    final showVideo = _playing && controller != null;

    return Stack(
      children: [
        widget.image,
        if (showVideo)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: GestureDetector(
                onTap: _stop,
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
            ),
          ),
        Positioned(
          left: Dim.sm,
          top: Dim.sm,
          child: LiveToggleButton(
            playing: _playing,
            loading: _initializing,
            onTap: _toggle,
          ),
        ),
      ],
    );
  }
}

/// 圆形 LIVE 开关：静止态显示 live 图标，播放态显示暂停，加载中转圈。
///
/// 内联缩略图与全屏 viewer 共用，叠在图片左上角。
class LiveToggleButton extends StatelessWidget {
  const LiveToggleButton({
    super.key,
    required this.playing,
    required this.loading,
    required this.onTap,
  });

  final bool playing;
  final bool loading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Widget icon = loading
        ? const SizedBox.square(
            dimension: 16,
            child: CupertinoActivityIndicator(color: Colors.white),
          )
        : Icon(
            playing ? Icons.motion_photos_pause : Icons.motion_photos_on,
            color: Colors.white,
            size: 20,
          );

    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.black54,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}
