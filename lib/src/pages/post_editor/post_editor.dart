import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/group_repository.dart';

/// 发表小组讨论编辑器。
///
/// 入口在小组页右下角的 FAB。当前只发纯文本（标题 + 正文），底部工具栏的图片
/// 按钮已占位，待 [GroupRepository.uploadGroupImage] 接入后开放。
///
/// 发表成功后 `pop(true)`，由小组页据此刷新讨论列表。
class PostEditorPage extends ConsumerStatefulWidget {
  const PostEditorPage({super.key, required this.groupId, this.groupName});

  final String groupId;
  final String? groupName;

  @override
  ConsumerState<PostEditorPage> createState() => _PostEditorPageState();
}

class _PostEditorPageState extends ConsumerState<PostEditorPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onChanged);
    _contentController.addListener(_onChanged);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty &&
      _contentController.text.trim().isNotEmpty;

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      await ref.read(groupRepositoryProvider).createPost(
            widget.groupId,
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
          );
      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('发表失败：${_errorMessage(e)}')),
      );
    }
  }

  Future<bool> _confirmDiscard() async {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      return true;
    }
    final discard = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('放弃这篇讨论？'),
        content: const Text('已输入的内容不会被保存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('继续编辑'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('放弃'),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (await _confirmDiscard() && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.groupName ?? '发表讨论'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: FilledButton(
                onPressed: _canSubmit && !_submitting ? _submit : null,
                style: FilledButton.styleFrom(
                  minimumSize: const Size(64, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('发表'),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      textInputAction: TextInputAction.next,
                      maxLength: 40,
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
                      decoration: const InputDecoration(
                        hintText: '标题',
                        border: InputBorder.none,
                        counterText: '',
                      ),
                    ),
                    const Divider(height: 1),
                    TextField(
                      controller: _contentController,
                      maxLines: null,
                      minLines: 8,
                      keyboardType: TextInputType.multiline,
                      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                      decoration: const InputDecoration(
                        hintText: '添加正文……',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _EditorToolbar(
              onPickImage: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('发图功能即将上线')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部工具栏。目前只有图片占位按钮，后续接入发图。
class _EditorToolbar extends StatelessWidget {
  const _EditorToolbar({required this.onPickImage});

  final VoidCallback onPickImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      child: SafeArea(
        top: false,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: theme.dividerColor, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.image_outlined),
                tooltip: '插入图片',
                onPressed: onPickImage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _errorMessage(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map) {
      return (data['localized_message'] ?? data['msg'] ?? data.toString())
          .toString();
    }
    return data?.toString() ?? e.message ?? e.toString();
  }
  return e.toString();
}
