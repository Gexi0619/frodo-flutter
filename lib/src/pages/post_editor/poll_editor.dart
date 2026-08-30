import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../ui/cupertino_ux.dart';

/// 发帖编辑器里配置好、但**尚未提交**的投票草稿。
///
/// 提交帖子时再经 `TopicRepository.createPoll` 真正建好投票拿到 id，避免用户
/// 放弃发帖时留下孤儿投票。[options] 已去空去重，至少 2 项。
class PollDraft {
  const PollDraft({
    required this.title,
    required this.options,
    this.voteLimit = 1,
    this.expireAt,
    this.correctOptions = const [],
  });

  final String title;
  final List<String> options;

  /// 最多可选项数（传给 createPoll 的 `vote_limit`）：1 = 单选，N = 最多投 N 项。
  final int voteLimit;

  /// 截止时刻；为空表示不限时。
  final DateTime? expireAt;

  /// 正确答案（答题型投票）。每项是 [options] 里的选项文本；为空表示无正确答案。
  final List<String> correctOptions;

  /// 是否设置了正确答案。
  bool get hasCorrectAnswer => correctOptions.isNotEmpty;

  /// 是否多选（最多可选多于一项）。
  bool get isMultiSelect => voteLimit > 1;

  /// 传给 createPoll 的 `expire_time`（`yyyy-MM-dd HH:mm:ss`），不限时返回 null。
  String? get expireTime {
    final t = expireAt;
    if (t == null) return null;
    String two(int n) => n.toString().padLeft(2, '0');
    return '${t.year}-${two(t.month)}-${two(t.day)} '
        '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }
}

/// 弹出投票编辑器（整页 modal）。返回配置好的 [PollDraft]；取消返回 null。
/// [initial] 非空时为「编辑已有投票」。
Future<PollDraft?> showPollEditor(
  BuildContext context, {
  PollDraft? initial,
}) {
  return Navigator.of(context).push<PollDraft>(
    CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (_) => _PollEditorPage(initial: initial),
    ),
  );
}

/// 投票截止时间预设。
const _expiryPresets = <(String, Duration?)>[
  ('不限时', null),
  ('1 天', Duration(days: 1)),
  ('3 天', Duration(days: 3)),
  ('7 天', Duration(days: 7)),
  ('30 天', Duration(days: 30)),
];

const _maxOptions = 20;
const _titleMaxLength = 15;

class _PollEditorPage extends StatefulWidget {
  const _PollEditorPage({this.initial});

  final PollDraft? initial;

  @override
  State<_PollEditorPage> createState() => _PollEditorPageState();
}

class _PollEditorPageState extends State<_PollEditorPage> {
  late final TextEditingController _titleController;
  late final List<TextEditingController> _optionControllers;

  /// 与 [_optionControllers] 等长、一一对应：该选项是否被标为正确答案。
  late final List<bool> _correct;

  /// 最多可选项数：1 = 单选，N = 最多可投 N 项。随选项增删夹在 [1, 选项数] 内。
  int _voteLimit = 1;
  late bool _hasCorrectAnswer;
  Duration? _expiry;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _titleController = TextEditingController(text: initial?.title ?? '')
      ..addListener(_onChanged);
    final initialOptions = initial?.options ?? const [];
    // 至少给两个空选项打底。
    _optionControllers = [
      for (var i = 0; i < (initialOptions.length < 2 ? 2 : initialOptions.length); i++)
        TextEditingController(text: i < initialOptions.length ? initialOptions[i] : '')
          ..addListener(_onChanged),
    ];
    final correct = initial?.correctOptions ?? const [];
    _correct = [
      for (final c in _optionControllers) correct.contains(c.text.trim())
    ];
    _voteLimit = initial?.voteLimit ?? 1;
    _hasCorrectAnswer = initial?.hasCorrectAnswer ?? false;
    // 编辑已有投票时无法还原原始预设，按不限时展示（提交才生效，对编辑场景影响小）。
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _optionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _onChanged() => setState(() {});

  List<String> get _cleanOptions => [
        for (final c in _optionControllers)
          if (c.text.trim().isNotEmpty) c.text.trim(),
      ];

  /// 可选项数上限（= 当前选项行数）。
  int get _maxVoteLimit => _optionControllers.length;

  /// 被标为正确、且文本非空的选项文本。
  List<String> get _correctOptions => [
        for (var i = 0; i < _optionControllers.length; i++)
          if (_correct[i] && _optionControllers[i].text.trim().isNotEmpty)
            _optionControllers[i].text.trim(),
      ];

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty &&
      _cleanOptions.length >= 2 &&
      // 开了「正确答案」就必须至少选一个正确项。
      (!_hasCorrectAnswer || _correctOptions.isNotEmpty);

  void _addOption() {
    if (_optionControllers.length >= _maxOptions) return;
    setState(() {
      _optionControllers
          .add(TextEditingController()..addListener(_onChanged));
      _correct.add(false);
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length <= 2) return;
    setState(() {
      _optionControllers.removeAt(index).dispose();
      _correct.removeAt(index);
      // 选项变少后，可选项数不能超过剩余选项数。
      if (_voteLimit > _maxVoteLimit) _voteLimit = _maxVoteLimit;
    });
  }

  void _toggleCorrect(int index) =>
      setState(() => _correct[index] = !_correct[index]);

  /// 滚轮选「最多可选项数」（1 = 单选，最多到选项数）。
  Future<void> _pickVoteLimit() async {
    final max = _maxVoteLimit;
    var selected = _voteLimit.clamp(1, max);
    final controller = FixedExtentScrollController(initialItem: selected - 1);
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => _WheelSheet(
        title: '最多可选项数',
        controller: controller,
        itemCount: max,
        labelOf: (i) => i == 0 ? '单选' : '${i + 1} 项',
        onSelected: (i) => selected = i + 1,
      ),
    );
    controller.dispose();
    if (mounted) setState(() => _voteLimit = selected);
  }

  Future<void> _pickExpiry() async {
    final picked = await showAppActionSheet<int>(
      context,
      title: '投票截止时间',
      actions: [
        for (var i = 0; i < _expiryPresets.length; i++)
          ActionSheetItem(_expiryPresets[i].$1, i),
      ],
    );
    if (picked == null || !mounted) return;
    setState(() => _expiry = _expiryPresets[picked].$2);
  }

  void _save() {
    if (!_canSave) return;
    Navigator.of(context).pop(
      PollDraft(
        title: _titleController.text.trim(),
        options: _cleanOptions,
        // 夹到实际填了内容的选项数之内。
        voteLimit: _voteLimit.clamp(1, _cleanOptions.length),
        expireAt: _expiry == null ? null : DateTime.now().add(_expiry!),
        correctOptions: _hasCorrectAnswer ? _correctOptions : const [],
      ),
    );
  }

  String get _expiryLabel {
    if (_expiry == null) return '不限时';
    return _expiryPresets
        .firstWhere((e) => e.$2 == _expiry, orElse: () => ('不限时', null))
        .$1;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        middle: const Text('创建投票'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          onPressed: _canSave ? _save : null,
          child: const Text('完成'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _SectionLabel('问题'),
          CupertinoTextField(
            controller: _titleController,
            placeholder: '投票标题',
            maxLength: _titleMaxLength,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          const SizedBox(height: 20),
          _SectionLabel('选项'),
          for (var i = 0; i < _optionControllers.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  if (_hasCorrectAnswer) ...[
                    _SquareCheckbox(
                      value: _correct[i],
                      onTap: () => _toggleCorrect(i),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: CupertinoTextField(
                      controller: _optionControllers[i],
                      placeholder: '选项 ${i + 1}',
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                  ),
                  if (_optionControllers.length > 2)
                    NavBarIconButton(
                      icon: CupertinoIcons.minus_circle,
                      semanticLabel: '删除选项',
                      onPressed: () => _removeOption(i),
                    ),
                ],
              ),
            ),
          if (_optionControllers.length < _maxOptions)
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 8),
              onPressed: _addOption,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.add_circled, size: 20),
                  SizedBox(width: 6),
                  Text('添加选项'),
                ],
              ),
            ),
          const SizedBox(height: 12),
          _SettingRow(
            label: '设置正确答案',
            trailing: CupertinoSwitch(
              value: _hasCorrectAnswer,
              onChanged: (v) => setState(() => _hasCorrectAnswer = v),
            ),
          ),
          _SettingRow(
            label: '可选项数',
            trailing: _ValueButton(
              text: _voteLimit <= 1 ? '单选' : '$_voteLimit 项',
              onPressed: _pickVoteLimit,
            ),
          ),
          _SettingRow(
            label: '截止时间',
            trailing: _ValueButton(text: _expiryLabel, onPressed: _pickExpiry),
          ),
          const SizedBox(height: 24),
          Text(
            '投票创建后将随帖子一起发布，标题不超过 $_titleMaxLength 字。',
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.textTheme.titleSmall
            ?.copyWith(color: theme.colorScheme.outline),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({required this.label, required this.trailing});

  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: Theme.of(context).dividerColor, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          trailing,
        ],
      ),
    );
  }
}

/// 设置行右侧的「值 + 箭头」按钮，点按弹滚轮/操作表。
class _ValueButton extends StatelessWidget {
  const _ValueButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const Icon(CupertinoIcons.chevron_forward, size: 16),
        ],
      ),
    );
  }
}

/// 方形勾选框（标记正确答案用）。选中时填充绿色 + 白勾。
class _SquareCheckbox extends StatelessWidget {
  const _SquareCheckbox({required this.value, required this.onTap});

  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final green = CupertinoColors.activeGreen.resolveFrom(context);
    final border = value
        ? green
        : CupertinoColors.systemGrey2.resolveFrom(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: value ? green : null,
          border: Border.all(color: border, width: 1.5),
          borderRadius: BorderRadius.circular(5),
        ),
        child: value
            ? const Icon(CupertinoIcons.checkmark,
                size: 15, color: CupertinoColors.white)
            : null,
      ),
    );
  }
}

/// 底部滚轮选择面板：顶部一条「完成」工具栏，下面是 [CupertinoPicker]。
class _WheelSheet extends StatelessWidget {
  const _WheelSheet({
    required this.title,
    required this.controller,
    required this.itemCount,
    required this.labelOf,
    required this.onSelected,
  });

  final String title;
  final FixedExtentScrollController controller;
  final int itemCount;
  final String Function(int index) labelOf;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      color: CupertinoColors.systemBackground.resolveFrom(context),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator.resolveFrom(context),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('完成'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: controller,
                itemExtent: 36,
                onSelectedItemChanged: onSelected,
                children: [
                  for (var i = 0; i < itemCount; i++)
                    Center(child: Text(labelOf(i))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
