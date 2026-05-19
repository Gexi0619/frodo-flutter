import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/paged.dart';

// frodo 服务端实测把 count 限制在 20 以内
const kPageSize = 20;

mixin PagingMixin<ItemType, W extends ConsumerStatefulWidget>
    on ConsumerState<W> {

  late final PagingController<int, ItemType> pagingController;

  Future<void> onLoadPage(int start);

  @override
  void initState() {
    super.initState();
    pagingController = PagingController<int, ItemType>(
      firstPageKey: 0,
      // 剩余不到一整页时就预取下一页，避免滚到底再等。
      invisibleItemsThreshold: kPageSize,
    )..addPageRequestListener(_handleLoadPage);
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  Future<void> _handleLoadPage(int start) async {
    try {
      await onLoadPage(start);
    } catch (e) {
      pagingController.error = e;
    }
  }

  /// 把一页结果交给 PagingController。`hasMore` 显式给出时优先，否则回退到
  /// `start + items.length >= total` 的判断。
  void appendPaged(int fetchedStart, Paged<ItemType> page) {
    final items = page.items;
    final nextStart = fetchedStart + items.length;
    final isLast = page.hasMore != null
        ? !page.hasMore!
        : items.isEmpty || nextStart >= page.total;
    if (isLast) {
      pagingController.appendLastPage(items);
    } else {
      pagingController.appendPage(items, nextStart);
    }
  }
}
