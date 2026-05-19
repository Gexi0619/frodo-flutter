import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/paged.dart';
import '../../../widgets/paging_mixin.dart';

/// Eliminates boilerplate shared by all keyword-driven search tabs.
/// Subclass provides [keywordProvider], [emptyHint], [fetchPage], [buildBody].
///
/// In the state class `with` clause, list mixins in this order:
///   `PagingMixin<T, W>, AutomaticKeepAliveClientMixin, KeywordPagingMixin<T, W>`
mixin KeywordPagingMixin<T, W extends ConsumerStatefulWidget>
    on ConsumerState<W>, PagingMixin<T, W>, AutomaticKeepAliveClientMixin<W> {
  ProviderListenable<String> get keywordProvider;
  String get emptyHint;

  Future<Paged<T>> fetchPage(String keyword, int start);
  Widget buildBody(BuildContext context);

  /// Called when the keyword provider changes. Default: refresh paged list.
  /// Override to also reset auxiliary state (e.g. clearing a groups list).
  void onKeywordChanged() => pagingController.refresh();

  @override
  bool get wantKeepAlive => true;

  @override
  Future<void> onLoadPage(int start) async {
    final keyword = ref.read(keywordProvider);
    if (keyword.trim().isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }
    appendPaged(start, await fetchPage(keyword, start));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ref.listen<String>(keywordProvider, (_, __) => onKeywordChanged());
    if (ref.watch(keywordProvider).trim().isEmpty) {
      return Center(child: Text(emptyHint));
    }
    return buildBody(context);
  }
}
