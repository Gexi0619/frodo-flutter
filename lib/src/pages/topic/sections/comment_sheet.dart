import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/comment.dart';
import '../../../repositories/topic_repository.dart';
import '../../../ui/cupertino_ux.dart';
import '../../../utils/error_message.dart';
import '../../../widgets/cupertino_tappable.dart';
import '../providers.dart';

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
    builder: (_) =>
        _CommentSheet(topicId: topicId, parentRef: parentRef, replyTo: replyTo),
  );
}

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
      showToast(context, '选择图片失败');
    }
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if ((text.isEmpty && _image == null) || _submitting) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(topicRepositoryProvider)
          .createComment(
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
      showToast(context, '发送失败：${serverMessage(e)}');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;
    final canSend =
        (_controller.text.trim().isNotEmpty || _image != null) && !_submitting;
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
              CupertinoButton(
                padding: const EdgeInsets.all(8),
                minimumSize: Size.zero,
                onPressed: _submitting ? null : _pickImage,
                child: Icon(
                  CupertinoIcons.photo,
                  color: _submitting ? scheme.outline : scheme.onSurfaceVariant,
                ),
              ),
              Expanded(
                child: CupertinoTextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  autofocus: true,
                  maxLines: 6,
                  minLines: 1,
                  textInputAction: TextInputAction.newline,
                  decoration: null,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  placeholder: replyTo != null
                      ? '回复 ${replyTo.author?.name ?? "用户"}…'
                      : '写下你的评论…',
                  placeholderStyle: TextStyle(color: scheme.outline),
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
                        child: CupertinoActivityIndicator(),
                      ),
                    )
                  : CupertinoButton(
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                      onPressed: canSend ? _submit : null,
                      child: Icon(
                        CupertinoIcons.paperplane_fill,
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
            child: CupertinoTappable(
              onTap: onRemove,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(CupertinoIcons.xmark, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
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
          CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: onCancel,
            child: Icon(CupertinoIcons.xmark, size: 18, color: scheme.outline),
          ),
        ],
      ),
    );
  }
}
