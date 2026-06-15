import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/poll.dart';
import '../pages/topic/providers.dart';
import '../ui/dimens.dart';
import '../utils/time.dart';

/// 帖子内嵌投票卡片。
///
/// 自带数据加载（[pollProvider]）：未投票时展示可勾选的选项与「投票」按钮，
/// 已投票或已截止时展示各选项票数与百分比；含正确答案的投票会标出正确项。
class PollCard extends ConsumerStatefulWidget {
  const PollCard({super.key, required this.pollId, this.fallbackTitle});

  final String pollId;

  /// 正文里内联的投票标题，详情未到时占位用。
  final String? fallbackTitle;

  @override
  ConsumerState<PollCard> createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<PollCard> {
  /// 本地已选选项 id（提交前的草稿）。
  final _selected = <String>{};
  bool _submitting = false;

  void _onTapOption(Poll poll, PollOption option) {
    if (poll.showResults || _submitting) return;
    setState(() {
      if (poll.isMultiSelect) {
        if (_selected.contains(option.id)) {
          _selected.remove(option.id);
        } else if (_selected.length < poll.voteLimit) {
          _selected.add(option.id);
        }
      } else {
        _selected
          ..clear()
          ..add(option.id);
      }
    });
  }

  Future<void> _submit() async {
    if (_selected.isEmpty || _submitting) return;
    setState(() => _submitting = true);
    try {
      await ref.read(pollProvider(widget.pollId).notifier).vote(
            _selected.toList(),
          );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('投票失败，请稍后再试')),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncPoll = ref.watch(pollProvider(widget.pollId));
    return _Frame(
      child: asyncPoll.when(
        loading: () => _loading(context),
        error: (_, __) => _error(context),
        data: (poll) => _content(context, poll),
      ),
    );
  }

  Widget _loading(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(title: widget.fallbackTitle ?? '投票'),
        const SizedBox(height: Dim.md),
        Center(
          child: SizedBox(
            width: Dim.iconMd,
            height: Dim.iconMd,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: scheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _error(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.fallbackTitle ?? '投票加载失败',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        TextButton(
          onPressed: () => ref.invalidate(pollProvider(widget.pollId)),
          child: Text('重试', style: TextStyle(color: scheme.primary)),
        ),
      ],
    );
  }

  Widget _content(BuildContext context, Poll poll) {
    final showResults = poll.showResults;

    // 百分比分母：参与人数；多选时单项占比相对参与人数。
    final denom = poll.votedUserCount > 0 ? poll.votedUserCount : 1;

    final children = <Widget>[
      _Header(title: poll.title ?? widget.fallbackTitle ?? '投票'),
      const SizedBox(height: Dim.xs),
      _meta(context, poll),
      const SizedBox(height: Dim.md),
    ];

    for (final option in poll.options) {
      final selected = _selected.contains(option.id);
      final percent = showResults ? option.votedUserCount / denom : 0.0;
      children.add(Padding(
        padding: const EdgeInsets.only(bottom: Dim.sm),
        child: _OptionTile(
          option: option,
          showResults: showResults,
          selected: selected,
          isMultiSelect: poll.isMultiSelect,
          highlightCorrect: poll.hasCorrectAnswer,
          percent: percent,
          onTap: () => _onTapOption(poll, option),
        ),
      ));
    }

    children.add(const SizedBox(height: Dim.xs));
    children.add(_voteButton(context, poll));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _meta(BuildContext context, Poll poll) {
    final scheme = Theme.of(context).colorScheme;
    final style = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: scheme.outline);
    final String timeText;
    if (poll.isExpired) {
      timeText = '已结束';
    } else {
      timeText = formatTimeRemaining(poll.expireAt) ?? '';
    }
    final parts = <String>[
      '${poll.votedUserCount} 人参与',
      poll.isMultiSelect ? '多选 · 最多 ${poll.voteLimit} 项' : '单选',
      if (timeText.isNotEmpty) timeText,
    ];
    return Text(parts.join(' · '), style: style);
  }

  Widget _voteButton(BuildContext context, Poll poll) {
    // 已投票 / 已结束：按钮仍在，但禁用并改文案。
    final String label;
    if (poll.hasVoted) {
      label = '已投票';
    } else if (poll.isExpired) {
      label = '已结束';
    } else {
      label = '投票';
    }
    final canSubmit =
        !poll.showResults && _selected.isNotEmpty && !_submitting;
    return Align(
      alignment: Alignment.centerLeft,
      child: FilledButton(
        onPressed: canSubmit ? _submit : null,
        child: _submitting
            ? const SizedBox(
                width: Dim.iconSm,
                height: Dim.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// 投票卡片外框：圆角 + 描边 + 内边距。
class _Frame extends StatelessWidget {
  const _Frame({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(Dim.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Dim.radiusLg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.bar_chart_rounded, size: Dim.iconMd, color: scheme.primary),
        const SizedBox(width: Dim.sm),
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// 单个选项：结果态显示进度条 + 票数；投票态显示勾选框。
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.showResults,
    required this.selected,
    required this.isMultiSelect,
    required this.highlightCorrect,
    required this.percent,
    required this.onTap,
  });

  final PollOption option;
  final bool showResults;
  final bool selected;
  final bool isMultiSelect;
  final bool highlightCorrect;
  final double percent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isCorrect = highlightCorrect && option.isCorrect;

    final Color borderColor;
    if (showResults && isCorrect) {
      borderColor = Colors.green;
    } else if (!showResults && selected) {
      borderColor = scheme.primary;
    } else {
      borderColor = scheme.outlineVariant;
    }

    final radius = BorderRadius.circular(Dim.radiusMd);

    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(color: borderColor),
          color: scheme.surface,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // 结果态：占比进度条作背景。
            if (showResults)
              Positioned.fill(
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: percent.clamp(0.0, 1.0),
                  child: ColoredBox(
                    color: (isCorrect ? Colors.green : scheme.primary)
                        .withValues(alpha: 0.14),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dim.md,
                vertical: Dim.sm + 2,
              ),
              child: Row(
                children: [
                  if (!showResults) ...[
                    _SelectIndicator(
                      selected: selected,
                      isMultiSelect: isMultiSelect,
                    ),
                    const SizedBox(width: Dim.sm),
                  ],
                  Expanded(
                    child: Text(
                      option.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: (showResults && option.isVoted) || selected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (showResults) ...[
                    if (option.isVoted) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        size: Dim.iconSm,
                        color: scheme.primary,
                      ),
                      const SizedBox(width: Dim.xs),
                    ],
                    Text(
                      '${(percent * 100).round()}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: Dim.sm),
                    Text(
                      '${option.votedUserCount}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectIndicator extends StatelessWidget {
  const _SelectIndicator({required this.selected, required this.isMultiSelect});
  final bool selected;
  final bool isMultiSelect;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.primary : scheme.outline;
    final IconData icon;
    if (isMultiSelect) {
      icon = selected
          ? Icons.check_box_rounded
          : Icons.check_box_outline_blank_rounded;
    } else {
      icon = selected
          ? Icons.radio_button_checked_rounded
          : Icons.radio_button_unchecked_rounded;
    }
    return Icon(icon, size: Dim.iconMd - 4, color: color);
  }
}
