import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../constants.dart';
import '../models/topic.dart';
import '../ui/dimens.dart';
import 'frodo_image.dart';

/// 讨论自带上传视频（顶层 `video_info`）的内联播放器。
///
/// 初始显示封面 + 播放按钮；点击后懒加载并交给 chewie 渲染控制栏
/// （播放/暂停、拖动进度、全屏等开箱即用）。只要有 `video_url` 就可播放——
/// 审核中（`play_status == 0`，仅自己可见）的视频本人也能正常播放。
class TopicVideoPlayer extends StatefulWidget {
  const TopicVideoPlayer({super.key, required this.info});

  final TopicVideoInfo info;

  @override
  State<TopicVideoPlayer> createState() => _TopicVideoPlayerState();
}

class _TopicVideoPlayerState extends State<TopicVideoPlayer> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _initializing = false;
  bool _failed = false;

  double get _aspectRatio {
    final w = widget.info.width, h = widget.info.height;
    return (w != null && h != null && h > 0) ? w / h : 16 / 9;
  }

  bool get _playable => widget.info.videoUrl?.isNotEmpty ?? false;

  /// 审核中（仅自己可见）时的非阻塞提示文案；无需提示时为 null。
  String? get _alertText {
    if (widget.info.playStatus != 0) return null;
    final text = widget.info.alertText;
    return (text != null && text.isNotEmpty) ? text : null;
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _start() async {
    if (_initializing || _chewieController != null) return;
    final url = widget.info.videoUrl;
    if (url == null || url.isEmpty) return;

    setState(() => _initializing = true);
    final video = VideoPlayerController.networkUrl(
      Uri.parse(url),
      httpHeaders: FrodoConstants.imageHeaders,
    );
    try {
      await video.initialize();
      // 默认静音播放，用户可通过控制栏的音量按钮自行开启。
      await video.setVolume(0);
    } catch (_) {
      await video.dispose();
      if (mounted) {
        setState(() {
          _initializing = false;
          _failed = true;
        });
      }
      return;
    }
    if (!mounted) {
      await video.dispose();
      return;
    }
    _videoController = video;
    _chewieController = ChewieController(
      videoPlayerController: video,
      autoPlay: true,
      looping: false,
      aspectRatio: video.value.aspectRatio,
      allowMuting: true,
    );
    setState(() => _initializing = false);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final Widget child;
    if (_chewieController != null) {
      // 播放中也保留审核提示，让作者始终知道该视频仅自己可见。
      child = Stack(
        fit: StackFit.expand,
        children: [
          Chewie(controller: _chewieController!),
          if (_alertText case final text?) _AlertBanner(text: text),
        ],
      );
    } else if (!_playable) {
      child = _Overlay(
        cover: _cover(),
        child: _AlertBadge(
          text: widget.info.alertText ?? '视频暂不可播放',
        ),
      );
    } else {
      child = Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: _initializing ? null : _start,
            child: _Overlay(
              cover: _cover(),
              child: _initializing
                  ? const SizedBox.square(
                      dimension: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      _failed
                          ? Icons.error_outline_rounded
                          : Icons.play_circle_outline_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
            ),
          ),
          if (_alertText case final text?) _AlertBanner(text: text),
        ],
      );
    }

    return AspectRatio(
      aspectRatio: _aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dim.radiusMd),
        child: ColoredBox(color: scheme.surfaceContainerHighest, child: child),
      ),
    );
  }

  Widget _cover() {
    final url = widget.info.coverUrl;
    if (url == null || url.isEmpty) return const ColoredBox(color: Colors.black);
    return FrodoImage(
      imageUrl: url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}

/// 封面之上叠一层半透明遮罩 + 居中内容（播放按钮 / 提示）。
class _Overlay extends StatelessWidget {
  const _Overlay({required this.cover, required this.child});

  final Widget cover;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        cover,
        const ColoredBox(color: Colors.black26),
        Center(child: child),
      ],
    );
  }
}

/// 顶部非阻塞提示横幅（审核中/仅自己可见），不影响下方播放交互。
class _AlertBanner extends StatelessWidget {
  const _AlertBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Dim.sm,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Align(
          child: _AlertBadge(text: text),
        ),
      ),
    );
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dim.lg),
      padding: const EdgeInsets.symmetric(
        horizontal: Dim.md,
        vertical: Dim.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(Dim.radiusMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.lock_outline_rounded,
              color: Colors.white, size: 18),
          const SizedBox(width: Dim.xs),
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
