import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/collection.dart';
import '../../../ui/cupertino_ux.dart';
import '../../../utils/error_message.dart';
import '../../../widgets/doulist_cover.dart';
import '../providers.dart';

/// 打开「收藏到豆列」底部弹层。
void showTopicCollectSheet(
  BuildContext context,
  WidgetRef parentRef, {
  required String topicId,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CollectSheet(topicId: topicId, parentRef: parentRef),
  );
}

class _CollectSheet extends ConsumerStatefulWidget {
  const _CollectSheet({required this.topicId, required this.parentRef});

  final String topicId;
  final WidgetRef parentRef;

  @override
  ConsumerState<_CollectSheet> createState() => _CollectSheetState();
}

class _CollectSheetState extends ConsumerState<_CollectSheet> {
  final Set<String> _toggling = {};

  Future<void> _toggle(Doulist doulist) async {
    if (_toggling.contains(doulist.id)) return;
    setState(() => _toggling.add(doulist.id));
    try {
      await ref
          .read(topicCollectProvider(widget.topicId).notifier)
          .toggle(doulist);
    } catch (e) {
      if (!mounted) return;
      showToast(context, '操作失败：${serverMessage(e)}');
    } finally {
      if (mounted) setState(() => _toggling.remove(doulist.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final collectState = ref.watch(topicCollectProvider(widget.topicId));

    Widget body;
    if (collectState.hasError) {
      body = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            serverMessage(collectState.error!),
            style: TextStyle(color: scheme.error),
          ),
        ),
      );
    } else if (!collectState.hasValue) {
      body = const Center(child: CupertinoActivityIndicator());
    } else if (collectState.value!.doulists.isEmpty) {
      body = const Center(child: Text('暂无可用豆列'));
    } else {
      final doulists = collectState.value!.doulists;
      body = ListView.builder(
        shrinkWrap: true,
        itemCount: doulists.length,
        itemBuilder: (context, index) {
          final doulist = doulists[index];
          final collected = doulist.isCollected ?? false;
          final loading = _toggling.contains(doulist.id);
          return DoulistListTile(
            title: doulist.title,
            coverUrl: doulist.coverUrl,
            isPrivate: doulist.isPrivate,
            itemsCount: doulist.itemsCount,
            onTap: loading ? null : () => _toggle(doulist),
            trailing: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CupertinoActivityIndicator(),
                  )
                : Icon(
                    collected ? CupertinoIcons.bookmark_fill : CupertinoIcons.bookmark,
                    color: collected ? scheme.primary : scheme.onSurfaceVariant,
                  ),
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('收藏到豆列', style: theme.textTheme.titleMedium),
          ),
          const Divider(height: 1),
          Flexible(child: body),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 8),
        ],
      ),
    );
  }
}
