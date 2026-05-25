import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/group.dart';
import '../../../routing/app_routes.dart';
import '../../../widgets/frodo_image.dart';
import '../providers.dart';

const double _kAvatarSize = 44;
const double _kAvatarRadius = 10;
const double _kItemWidth = 56;
const double _kPaddingTop = 8;
const double _kPaddingBottom = 4;
const double _kAvatarLabelGap = 4;
// 不从字体行高反推——直接给一个宽松的固定高度，避免不同设备字体 metrics 溢出。
const double _kDockHeight = 80;
const double _kItemSpacing = 8;
const double _kHorizontalPadding = 12;

/// 粘底的"我的小组" Dock：一行圆角方形头像 + 小组名，横向滚动。
///
/// 放在 [Scaffold.bottomNavigationBar] 槽位，自然停在 [RootScaffold] 的
/// NavigationBar 上方。横向滚动通知被内部拦截，不会触发根布局的显隐逻辑。
/// [selectedGroupId] 传入时对应小组头像会显示选中高亮。
class GroupsDock extends ConsumerWidget {
  const GroupsDock({super.key, this.selectedGroupId});

  final String? selectedGroupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final joined = ref.watch(joinedGroupsProvider);
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.surfaceContainer,
      elevation: 0,
      child: Container(
        height: _kDockHeight,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: scheme.outlineVariant.withValues(alpha: 0.5)),
          ),
        ),
        // 拦截向上冒泡的 ScrollNotification，避免触发 RootScaffold 的底部栏显隐。
        child: NotificationListener<ScrollNotification>(
          onNotification: (_) => true,
          child: joined.when(
            loading: () => const _DockShimmer(),
            error: (_, __) => _DockMessage(
              icon: Icons.cloud_off_outlined,
              text: '加载失败，下拉刷新重试',
              onTap: () => ref.invalidate(joinedGroupsProvider),
            ),
            data: (groups) => groups.isEmpty
                ? const _DockMessage(
                    icon: Icons.group_outlined,
                    text: '还没有加入任何小组',
                  )
                : _DockList(
                    groups: groups,
                    selectedGroupId: selectedGroupId,
                  ),
          ),
        ),
      ),
    );
  }
}

class _DockList extends ConsumerStatefulWidget {
  const _DockList({
    required this.groups,
    this.selectedGroupId,
  });

  final List<Group> groups;
  final String? selectedGroupId;

  @override
  ConsumerState<_DockList> createState() => _DockListState();
}

class _DockListState extends ConsumerState<_DockList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    // 挂载时从共享 provider 还原上次的横向偏移。
    final initialOffset = ref.read(groupsDockScrollOffsetProvider);
    _controller = ScrollController(initialScrollOffset: initialOffset);
    _controller.addListener(_persistOffset);
  }

  void _persistOffset() {
    if (!_controller.hasClients) return;
    ref.read(groupsDockScrollOffsetProvider.notifier).state = _controller.offset;
  }

  @override
  void dispose() {
    _controller.removeListener(_persistOffset);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        _kHorizontalPadding,
        _kPaddingTop,
        _kHorizontalPadding,
        _kPaddingBottom,
      ),
      itemCount: widget.groups.length,
      separatorBuilder: (_, __) => const SizedBox(width: _kItemSpacing),
      itemBuilder: (context, i) {
        final g = widget.groups[i];
        return _DockItem(
          group: g,
          isSelected: g.id == widget.selectedGroupId,
          onTap: () => context.go(AppRoutes.group(g.id)),
        ).animate().fadeIn(duration: 220.ms, delay: (i * 20).ms);
      },
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.group,
    required this.onTap,
    this.isSelected = false,
  });

  final Group group;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = group.avatar ?? group.largeAvatar;

    return SizedBox(
      width: _kItemWidth,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(_kAvatarRadius + 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _kAvatarSize,
              height: _kAvatarSize,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(_kAvatarRadius),
                    child: url != null && url.isNotEmpty
                        ? FrodoImage.tile(
                            imageUrl: url,
                            width: _kAvatarSize,
                            height: _kAvatarSize,
                            errorIcon: Icons.group,
                            errorIconSize: 22,
                          )
                        : ColoredBox(
                            color: scheme.surfaceContainerHighest,
                            child: Icon(Icons.group,
                                color: scheme.outline, size: 22),
                          ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_kAvatarRadius),
                      border: Border.all(
                        color: isSelected
                            ? scheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: _kAvatarLabelGap),
            Text(
              group.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected ? scheme.primary : scheme.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DockMessage extends StatelessWidget {
  const _DockMessage({required this.icon, required this.text, this.onTap});

  final IconData icon;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: scheme.outline),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(color: scheme.outline)),
      ],
    );
    return Center(
      child: onTap == null
          ? content
          : InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: content,
              ),
            ),
    );
  }
}

class _DockShimmer extends StatelessWidget {
  const _DockShimmer();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceContainerHigh,
      highlightColor: scheme.surfaceContainerHighest,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          _kHorizontalPadding,
          _kPaddingTop,
          _kHorizontalPadding,
          _kPaddingBottom,
        ),
        itemCount: 8,
        separatorBuilder: (_, __) => const SizedBox(width: _kItemSpacing),
        itemBuilder: (_, __) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _kAvatarSize,
              height: _kAvatarSize,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(_kAvatarRadius),
              ),
            ),
            const SizedBox(height: _kAvatarLabelGap),
            Container(
              width: 36,
              height: 12,
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
