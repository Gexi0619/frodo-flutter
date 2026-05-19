import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'error_view.dart';

/// 项目内统一的 [PagedChildBuilderDelegate]：把首屏 loading / 翻页 loading /
/// 空态 / 错误态打包，调用方只需要给 [itemBuilder] 和 [emptyText]。
///
/// 两种 padding 预设：
///  - 默认（list 场景）：48 / 20 / 24
///  - [dense]（topic 详情底部 tab 这类紧凑列表）：20 / 16 / 20
PagedChildBuilderDelegate<T> frodoPagedDelegate<T>({
  required ItemWidgetBuilder<T> itemBuilder,
  required PagingController<int, T> controller,
  required String emptyText,
  bool dense = false,
  WidgetBuilder? firstPageProgressBuilder,
}) {
  final firstPad = dense ? 20.0 : 48.0;
  final newPad = dense ? 16.0 : 20.0;
  final errorPad = dense ? 20.0 : 24.0;
  return PagedChildBuilderDelegate<T>(
    itemBuilder: itemBuilder,
    firstPageProgressIndicatorBuilder: firstPageProgressBuilder ??
        (_) => Padding(
              padding: EdgeInsets.all(firstPad),
              child: const Center(child: CircularProgressIndicator()),
            ),
    newPageProgressIndicatorBuilder: (_) => Padding(
      padding: EdgeInsets.all(newPad),
      child: const Center(child: CircularProgressIndicator()),
    ),
    noItemsFoundIndicatorBuilder: (_) => Padding(
      padding: EdgeInsets.all(firstPad),
      child: Center(child: Text(emptyText)),
    ),
    firstPageErrorIndicatorBuilder: (_) => Padding(
      padding: EdgeInsets.all(errorPad),
      child: ErrorView(
        error: controller.error ?? '未知错误',
        onRetry: controller.refresh,
      ),
    ),
  );
}
