import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

// frodo 服务端实测把 count 限制在 20 以内
const kPageSize = 20;

mixin PagingMixin<ItemType, W extends ConsumerStatefulWidget>
    on ConsumerState<W> {

  late final PagingController<int, ItemType> pagingController;

  Future<void> onLoadPage(int start);

  @override
  void initState() {
    super.initState();
    pagingController = PagingController<int, ItemType>(firstPageKey: 0)
      ..addPageRequestListener(_handleLoadPage);
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

  void appendPageResult(List<ItemType> items, int fetchedStart, int total) {
    final nextStart = fetchedStart + items.length;
    if (items.isEmpty || nextStart >= total) {
      pagingController.appendLastPage(items);
    } else {
      pagingController.appendPage(items, nextStart);
    }
  }
}
