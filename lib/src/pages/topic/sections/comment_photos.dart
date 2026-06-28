import 'package:flutter/material.dart';

import '../../../models/comment.dart';
import '../../../ui/dimens.dart';
import '../../../widgets/frodo_image.dart';
import '../../../widgets/image_viewer_page.dart';

/// Photo grid for a comment or reply. Opens a full-screen viewer on tap.
class CommentPhotos extends StatelessWidget {
  const CommentPhotos({super.key, required this.photos});

  final List<CommentPhoto> photos;

  @override
  Widget build(BuildContext context) {
    if (photos.length == 1) {
      final photo = photos.first;
      final url = photo.url;
      if (url == null) return const SizedBox.shrink();
      final ratio = photo.aspectRatio;
      Widget inner = _PhotoThumbnail(url: url, isAnimated: photo.isAnimated);
      if (ratio != null) inner = AspectRatio(aspectRatio: ratio, child: inner);
      return GestureDetector(
        onTap: () => _openViewer(context, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dim.radiusSm),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 160, maxHeight: 160),
            child: inner,
          ),
        ),
      );
    }

    const size = 72.0;
    const spacing = Dim.xs;
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        for (int i = 0; i < photos.length; i++)
          Builder(
            builder: (context) {
              final url = photos[i].url;
              if (url == null) return const SizedBox.shrink();
              return GestureDetector(
                onTap: () => _openViewer(context, i),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dim.radiusXs),
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: _PhotoThumbnail(
                      url: url,
                      isAnimated: photos[i].isAnimated,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  void _openViewer(BuildContext context, int initialIndex) {
    final urls = photos.map((p) => p.url).whereType<String>().toList();
    if (urls.isEmpty) return;
    Navigator.push(
      context,
      ImageViewerPage.route(
        urls: urls,
        initialIndex: initialIndex.clamp(0, urls.length - 1),
      ),
    );
  }
}

class _PhotoThumbnail extends StatelessWidget {
  const _PhotoThumbnail({required this.url, required this.isAnimated});

  final String url;
  final bool isAnimated;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        FrodoImage.tile(imageUrl: url),
        if (isAnimated) const GifBadge(),
      ],
    );
  }
}
