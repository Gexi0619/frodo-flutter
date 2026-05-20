import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/collection.dart';
import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../widgets/doulist_cover.dart';
import '../providers.dart';

/// 从 DioException 或其他异常中提取用户可读的错误描述。
String _serverMessage(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map) {
      return (data['localized_message'] ?? data['msg'] ?? data.toString())
          as String;
    }
    return data?.toString() ?? e.message ?? e.toString();
  }
  return e.toString();
}

// ---------------------------------------------------------------------------

/// 打开评论编辑底部弹层。传 [replyTo] 即为回复该评论。
void showTopicCommentSheet(
  BuildContext context,
  WidgetRef parentRef, {
  required String topicId,
  Comment? replyTo,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _CommentSheet(
      topicId: topicId,
      parentRef: parentRef,
      replyTo: replyTo,
    ),
  );
}

// ---------------------------------------------------------------------------

class TopicInteraction extends ConsumerWidget {
  const TopicInteraction({super.key, required this.topicId});

  final String topicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reactState = ref.watch(topicReactProvider(topicId));
    final liked = reactState.valueOrNull?.liked ?? false;
    final collectState = ref.watch(topicCollectProvider(topicId));
    final anyCollected = collectState.valueOrNull?.anyCollected ?? false;

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final likeColor = liked ? scheme.primary : scheme.onSurfaceVariant;

    return SafeArea(
      top: false,
      child: SizedBox(
        height: 56,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => showTopicCommentSheet(
                    context,
                    ref,
                    topicId: topicId,
                  ),
                  child: Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '写评论…',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: scheme.outline),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: reactState is AsyncLoading
                    ? null
                    : () =>
                        ref.read(topicReactProvider(topicId).notifier).toggle(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Icon(
                    liked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    size: 20,
                    color: likeColor,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) =>
                      _CollectSheet(topicId: topicId, parentRef: ref),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Icon(
                    anyCollected ? Icons.bookmark : Icons.bookmark_border,
                    size: 20,
                    color: anyCollected
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------

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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('操作失败：${_serverMessage(e)}')),
      );
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
            _serverMessage(collectState.error!),
            style: TextStyle(color: scheme.error),
          ),
        ),
      );
    } else if (!collectState.hasValue) {
      body = const Center(child: CircularProgressIndicator());
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
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    collected ? Icons.bookmark : Icons.bookmark_border,
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

// ---------------------------------------------------------------------------

class _CommentSheet extends ConsumerStatefulWidget {
  const _CommentSheet({
    required this.topicId,
    required this.parentRef,
    this.replyTo,
  });

  final String topicId;
  final WidgetRef parentRef;
  final Comment? replyTo;

  @override
  ConsumerState<_CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<_CommentSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  final _picker = ImagePicker();
  bool _submitting = false;
  late Comment? _replyTo = widget.replyTo;
  XFile? _image;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (!mounted) return;
      if (picked != null) setState(() => _image = picked);
      // picker 期间 Flutter 侧 FocusNode 并未真正失焦，需先 unfocus 再 requestFocus 才能重弹 IME。
      _focusNode.unfocus();
      await Future.delayed(const Duration(milliseconds: 120));
      if (!mounted) return;
      FocusScope.of(context).requestFocus(_focusNode);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('选择图片失败')),
      );
    }
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if ((text.isEmpty && _image == null) || _submitting) return;
    setState(() => _submitting = true);
    try {
      await ref.read(topicRepositoryProvider).createComment(
            widget.topicId,
            text,
            refCid: _replyTo?.id,
            imagePath: _image?.path,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      bumpTopicListsRefresh(widget.parentRef, widget.topicId);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发送失败：${_serverMessage(e)}')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    final canSend = (_controller.text.trim().isNotEmpty || _image != null) &&
        !_submitting;
    final replyTo = _replyTo;

    return Container(
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.fromLTRB(16, 12, 8, 12 + bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (replyTo != null)
            _ReplyBanner(
              replyTo: replyTo,
              onCancel: () => setState(() => _replyTo = null),
            ),
          if (_image != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ImagePreview(
                file: _image!,
                onRemove: () => setState(() => _image = null),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: _submitting ? null : _pickImage,
                icon: Icon(
                  Icons.image_outlined,
                  color: _submitting
                      ? scheme.outline
                      : scheme.onSurfaceVariant,
                ),
                tooltip: '添加图片',
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  maxLines: 6,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: replyTo != null
                        ? '回复 ${replyTo.author?.name ?? "用户"}…'
                        : '写下你的评论…',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    hintStyle: TextStyle(color: scheme.outline),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 4),
              _submitting
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      onPressed: canSend ? _submit : null,
                      icon: Icon(
                        Icons.send_rounded,
                        color: canSend ? scheme.primary : scheme.outline,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.file, required this.onRemove});

  final XFile file;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(file.path),
              width: 88,
              height: 88,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: -6,
            right: -6,
            child: Material(
              color: Colors.black54,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(2),
                  child: Icon(Icons.close, size: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _ReplyBanner extends StatelessWidget {
  const _ReplyBanner({required this.replyTo, required this.onCancel});

  final Comment replyTo;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(10, 6, 4, 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
                children: [
                  TextSpan(
                    text: '回复 ${replyTo.author?.name ?? "用户"}: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: replyTo.text ?? ''),
                ],
              ),
            ),
          ),
          IconButton(
            iconSize: 18,
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onCancel,
            icon: Icon(Icons.close, color: scheme.outline),
            tooltip: '取消回复',
          ),
        ],
      ),
    );
  }
}
