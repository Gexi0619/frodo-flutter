import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/group_repository.dart';
import '../../repositories/topic_repository.dart';
import '../../ui/cupertino_ux.dart';
import '../../utils/draft_content.dart';
import 'poll_editor.dart';

/// 发表小组讨论编辑器。
///
/// 入口在小组页右下角的 FAB。正文是一列**可拖动排序**的块（[_Block]）：文字块
/// （[_TextBlock]）与投票块（[_PollBlock]）可任意上下调换顺序、混排。发表时按
/// 屏幕上的顺序编码成 DraftJS（见 [encodeDraftBlocks]）——`blocks` 数组顺序即
/// 显示顺序。图片按钮待 [GroupRepository.uploadGroupImage] 接入 UI 后开放。
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

  /// 正文块，按显示顺序排列。初始给一个空文字块打底。
  final List<_Block> _blocks = [];
  var _nextId = 0;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_onChanged);
    _blocks.add(_newTextBlock());
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final b in _blocks) {
      if (b is _TextBlock) b.controller.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  _TextBlock _newTextBlock({String text = ''}) {
    final block = _TextBlock(_nextId++, text: text);
    block.controller.addListener(_onChanged);
    return block;
  }

  bool get _hasText =>
      _blocks.any((b) => b is _TextBlock && b.controller.text.trim().isNotEmpty);

  bool get _canSubmit =>
      _titleController.text.trim().isNotEmpty && _hasText;

  bool get _isEmpty =>
      _titleController.text.isEmpty &&
      _blocks.every((b) => b is _TextBlock && b.controller.text.isEmpty);

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex--;
      _blocks.insert(newIndex, _blocks.removeAt(oldIndex));
    });
  }

  void _addTextBlock() => setState(() => _blocks.add(_newTextBlock()));

  Future<void> _addPoll() async {
    final result = await showPollEditor(context);
    if (result != null && mounted) {
      setState(() => _blocks.add(_PollBlock(_nextId++, result)));
    }
  }

  Future<void> _editPoll(_PollBlock block) async {
    final result = await showPollEditor(context, initial: block.poll);
    if (result != null && mounted) setState(() => block.poll = result);
  }

  void _removeBlock(_Block block) {
    setState(() {
      _blocks.remove(block);
      if (block is _TextBlock) block.controller.dispose();
      // 至少留一个空文字块，避免正文彻底空掉没法继续输入。
      if (_blocks.isEmpty) _blocks.add(_newTextBlock());
    });
  }

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      // 按屏幕顺序把每个块落成 DraftBlock；投票块此时才 createPoll 拿到 id，
      // 避免用户放弃发帖时留下孤儿投票。
      final topic = ref.read(topicRepositoryProvider);
      final draft = <DraftBlock>[];
      for (final block in _blocks) {
        switch (block) {
          case _TextBlock():
            final text = block.controller.text.trimRight();
            if (text.trim().isEmpty) continue;
            draft.add(DraftText(text));
          case _PollBlock():
            final p = block.poll;
            final poll = await topic.createPoll(
              title: p.title,
              options: p.options,
              voteLimit: p.voteLimit,
              expireTime: p.expireTime,
              correctOptions: p.correctOptions,
            );
            draft.add(DraftPollBlock(poll));
        }
      }
      await ref.read(groupRepositoryProvider).createPost(
            widget.groupId,
            title: _titleController.text.trim(),
            blocks: draft,
          );
      if (!mounted) return;
      context.pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      showToast(context, '发表失败：${_errorMessage(e)}');
    }
  }

  Future<bool> _confirmDiscard() async {
    if (_isEmpty) return true;
    return showConfirmDialog(
      context,
      title: '放弃这篇讨论？',
      message: '已输入的内容不会被保存。',
      confirmText: '放弃',
      cancelText: '继续编辑',
      isDestructive: true,
    );
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
        appBar: CupertinoNavigationBar(
          middle: Text(widget.groupName ?? '发表讨论'),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            onPressed: _canSubmit && !_submitting ? _submit : null,
            child: _submitting
                ? const CupertinoActivityIndicator()
                : const Text('发表'),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CupertinoTextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.next,
                    maxLength: 40,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                    placeholder: '标题',
                    decoration: null,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  const Divider(height: 1),
                ],
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                buildDefaultDragHandles: false,
                itemCount: _blocks.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final block = _blocks[index];
                  return _BlockTile(
                    key: ValueKey(block.id),
                    index: index,
                    onRemove: () => _removeBlock(block),
                    child: switch (block) {
                      _TextBlock() => _TextBlockView(controller: block.controller),
                      _PollBlock() => _PollBlockView(
                          poll: block.poll,
                          onEdit: () => _editPoll(block),
                        ),
                    },
                  );
                },
              ),
            ),
            _EditorToolbar(
              onPickImage: () => showToast(context, '发图功能即将上线'),
              onAddText: _addTextBlock,
              onAddPoll: _addPoll,
            ),
          ],
        ),
      ),
    );
  }
}

/// 正文里一个有序块。[id] 稳定不变，用作 [ReorderableListView] 的 key。
sealed class _Block {
  _Block(this.id);
  final int id;
}

class _TextBlock extends _Block {
  _TextBlock(super.id, {String text = ''})
      : controller = TextEditingController(text: text);
  final TextEditingController controller;
}

class _PollBlock extends _Block {
  _PollBlock(super.id, this.poll);
  PollDraft poll;
}

/// 每个块的外壳：左侧拖动手柄 + 内容 + 右侧删除。手柄用
/// [ReorderableDragStartListener] 独立触发，避免和文字块的输入手势打架。
class _BlockTile extends StatelessWidget {
  const _BlockTile({
    super.key,
    required this.index,
    required this.child,
    required this.onRemove,
  });

  final int index;
  final Widget child;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Padding(
              padding: const EdgeInsets.only(top: 12, right: 4),
              child: Icon(
                CupertinoIcons.line_horizontal_3,
                size: 20,
                color: theme.colorScheme.outline,
              ),
            ),
          ),
          Expanded(child: child),
          NavBarIconButton(
            icon: CupertinoIcons.xmark_circle,
            semanticLabel: '删除此块',
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

/// 文字块视图：一个自增高的 [CupertinoTextField]。
class _TextBlockView extends StatelessWidget {
  const _TextBlockView({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CupertinoTextField(
      controller: controller,
      maxLines: null,
      minLines: 3,
      keyboardType: TextInputType.multiline,
      style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
      placeholder: '添加正文……',
      decoration: null,
      padding: const EdgeInsets.symmetric(vertical: 8),
    );
  }
}

/// 底部工具栏：图片（占位）+ 文字块 + 投票。
class _EditorToolbar extends StatelessWidget {
  const _EditorToolbar({
    required this.onPickImage,
    required this.onAddText,
    required this.onAddPoll,
  });

  final VoidCallback onPickImage;
  final VoidCallback onAddText;
  final VoidCallback onAddPoll;

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
              const SizedBox(width: 8),
              NavBarIconButton(
                icon: CupertinoIcons.photo,
                semanticLabel: '插入图片',
                onPressed: onPickImage,
              ),
              NavBarIconButton(
                icon: CupertinoIcons.text_alignleft,
                semanticLabel: '添加文字块',
                onPressed: onAddText,
              ),
              NavBarIconButton(
                icon: CupertinoIcons.chart_bar_square,
                semanticLabel: '添加投票',
                onPressed: onAddPoll,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 投票块视图：展示标题 + 摘要的卡片，点按编辑。
class _PollBlockView extends StatelessWidget {
  const _PollBlockView({required this.poll, required this.onEdit});

  final PollDraft poll;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final meta = <String>[
      '${poll.options.length} 个选项',
      if (poll.isMultiSelect) '最多选 ${poll.voteLimit} 项',
      if (poll.hasCorrectAnswer) '有正确答案',
      if (poll.expireAt != null) '限时',
    ].join(' · ');
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.chart_bar_square,
                size: 22, color: theme.colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    poll.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.outline),
                  ),
                ],
              ),
            ),
          ],
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
