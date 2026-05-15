import 'package:flutter/material.dart';

/// Animated "scroll to top" FAB. Place as [Scaffold.floatingActionButton].
///
/// Caller is responsible for:
/// - toggling [visible] via scroll notifications
/// - providing [onPressed] that actually scrolls to top
class ScrollToTopFab extends StatelessWidget {
  const ScrollToTopFab({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: IgnorePointer(
        ignoring: !visible,
        child: FloatingActionButton.small(
          onPressed: onPressed,
          tooltip: '回到顶部',
          elevation: 1,
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          child: const Icon(Icons.keyboard_arrow_up),
        ),
      ),
    );
  }
}
