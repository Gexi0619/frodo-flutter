import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/dimens.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry});

  final Object error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dim.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.wifi_slash,
                size: 56, color: theme.colorScheme.error),
            const SizedBox(height: Dim.md),
            Text(
              '加载失败',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dim.sm),
            Text(
              '$error',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.outline),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: Dim.lg),
              CupertinoButton.filled(
                onPressed: onRetry,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: const Text('重试'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
