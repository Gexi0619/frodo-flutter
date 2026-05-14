import 'package:flutter/material.dart';

import 'frodo_image.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.url, this.radius = 16});

  final String? url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final size = radius * 2;
    if (url != null && url!.isNotEmpty) {
      return ClipOval(
        child: FrodoImage(
          imageUrl: url!,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: scheme.surfaceContainerHighest,
      child: Icon(Icons.person, size: radius, color: scheme.outline),
    );
  }
}
