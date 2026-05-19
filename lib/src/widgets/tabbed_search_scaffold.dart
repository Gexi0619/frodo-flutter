import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'scroll_to_top_fab.dart';

/// Abstract base state for pages that combine a search field, a TabBar,
/// per-tab ScrollControllers, and a "scroll to top" FAB.
///
/// Subclass provides [tabCount], [buildAppBar], and [buildTabViews].
/// All controller lifecycle (init / dispose / listeners) is handled here.
abstract class TabbedSearchPageState<W extends ConsumerStatefulWidget>
    extends ConsumerState<W>
    with SingleTickerProviderStateMixin, FabVisibilityMixin {
  int get tabCount;
  PreferredSizeWidget buildAppBar(BuildContext context);
  List<Widget> buildTabViews();

  final textController = TextEditingController();
  bool hasText = false;
  late final TabController tabController;
  late final List<ScrollController> scrollControllers;

  /// Called after super.initState() but before the text listener is attached.
  /// Override to set an initial value for [textController] / [hasText].
  void initController() {}

  @override
  void initState() {
    super.initState();
    initController();
    textController.addListener(_onTextChanged);
    scrollControllers = List.generate(tabCount, (_) => ScrollController());
    tabController = TabController(length: tabCount, vsync: this)
      ..addListener(_onTabChanged);
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    tabController.dispose();
    for (final c in scrollControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final has = textController.text.isNotEmpty;
    if (has != hasText) setState(() => hasText = has);
  }

  void _onTabChanged() {
    if (tabController.indexIsChanging) return;
    final c = scrollControllers[tabController.index];
    updateFabVisibility(c.hasClients ? c.position.pixels : 0.0);
  }

  bool _onScroll(ScrollNotification n) {
    updateFabVisibility(n.metrics.pixels);
    return false;
  }

  void scrollToTop() =>
      animateScrollToTop(scrollControllers[tabController.index]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ScrollToTopFab(
        visible: showScrollToTopFab,
        onPressed: scrollToTop,
      ),
      appBar: buildAppBar(context),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: TabBarView(
          controller: tabController,
          children: buildTabViews(),
        ),
      ),
    );
  }
}
