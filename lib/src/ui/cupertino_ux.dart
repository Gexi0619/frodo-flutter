import 'package:flutter/cupertino.dart';

/// 全 App 统一的 iOS 风格交互件：导航栏图标按钮、确认/输入弹窗、ActionSheet、
/// 轻量 toast。迁移 Cupertino 时所有页面都走这里，避免各处重复实现、风格漂移。

/// 导航栏里的紧凑图标按钮（无内边距、无最小尺寸约束）。
/// 替代到处重复的 `CupertinoButton(padding: zero, minimumSize: zero, child: Icon)`。
class NavBarIconButton extends StatelessWidget {
  const NavBarIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 24,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.zero,
      onPressed: onPressed,
      child: Icon(icon, size: size, color: color, semanticLabel: semanticLabel),
    );
  }
}

/// 带背景色的导航栏（如小组/用户主题色）：标题与返回箭头都用 [foreground] 上色。
/// 可直接用作 [Scaffold.appBar]。无 [foreground] 时退化为普通 [CupertinoNavigationBar]。
PreferredSizeWidget themedNavigationBar({
  required String title,
  Color? backgroundColor,
  Color? foreground,
  Widget? trailing,
}) {
  final bar = CupertinoNavigationBar(
    backgroundColor: backgroundColor,
    trailing: trailing,
    // 仅覆盖颜色；字号/字重仍继承 navTitleTextStyle。
    middle: Text(title,
        style: foreground == null ? null : TextStyle(color: foreground)),
  );
  if (foreground == null) return bar;
  return PreferredSize(
    preferredSize: bar.preferredSize,
    // primaryColor 决定自动返回箭头的颜色。
    child: CupertinoTheme(
      data: CupertinoThemeData(primaryColor: foreground),
      child: bar,
    ),
  );
}

/// iOS 确认弹窗。返回 true=确认、false/null=取消。[isDestructive] 时确认键红色。
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmText = '确定',
  String cancelText = '取消',
  bool isDestructive = false,
}) async {
  final res = await showCupertinoDialog<bool>(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title),
      content: message == null
          ? null
          : Padding(padding: const EdgeInsets.only(top: 8), child: Text(message)),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          isDestructiveAction: isDestructive,
          isDefaultAction: !isDestructive,
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  return res ?? false;
}

/// iOS 文本输入弹窗。返回输入值（已 trim）；取消返回 null。
/// [maxLines] > 1 时为多行输入。
Future<String?> showPromptDialog(
  BuildContext context, {
  required String title,
  String? message,
  String initial = '',
  String? placeholder,
  int minLines = 1,
  int maxLines = 1,
  int? maxLength,
  String confirmText = '确定',
  String cancelText = '取消',
}) async {
  final ctrl = TextEditingController(text: initial);
  final res = await showCupertinoDialog<String>(
    context: context,
    builder: (ctx) => CupertinoAlertDialog(
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message != null) ...[
              Text(message),
              const SizedBox(height: 12),
            ],
            CupertinoTextField(
              controller: ctrl,
              autofocus: true,
              placeholder: placeholder,
              minLines: minLines,
              maxLines: maxLines,
              maxLength: maxLength,
            ),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.pop(ctx),
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
          child: Text(confirmText),
        ),
      ],
    ),
  );
  ctrl.dispose();
  return res;
}

/// ActionSheet 的一项。
class ActionSheetItem<T> {
  const ActionSheetItem(
    this.label,
    this.value, {
    this.isDestructive = false,
    this.isDefault = false,
  });

  final String label;
  final T value;
  final bool isDestructive;
  final bool isDefault;
}

/// iOS ActionSheet 通用入口。选中返回对应 value；取消返回 null。
Future<T?> showAppActionSheet<T>(
  BuildContext context, {
  String? title,
  String? message,
  required List<ActionSheetItem<T>> actions,
  String cancelText = '取消',
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    builder: (ctx) => CupertinoActionSheet(
      title: title == null ? null : Text(title),
      message: message == null ? null : Text(message),
      actions: [
        for (final a in actions)
          CupertinoActionSheetAction(
            isDestructiveAction: a.isDestructive,
            isDefaultAction: a.isDefault,
            onPressed: () => Navigator.pop(ctx, a.value),
            child: Text(a.label),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: true,
        onPressed: () => Navigator.pop(ctx),
        child: Text(cancelText),
      ),
    ),
  );
}

/// 轻量 iOS 风格 toast，替代 Material 的 SnackBar（iOS 无原生 toast）。
/// 居中靠下浮一个半透明胶囊，自动淡入淡出。
void showToast(BuildContext context, String message) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _Toast(message: message, onDismissed: entry.remove),
  );
  overlay.insert(entry);
}

class _Toast extends StatefulWidget {
  const _Toast({required this.message, required this.onDismissed});

  final String message;
  final VoidCallback onDismissed;

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _visible = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Positioned(
      left: 24,
      right: 24,
      bottom: media.padding.bottom + 80,
      child: IgnorePointer(
        child: AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          onEnd: () {
            if (!_visible) widget.onDismissed();
          },
          child: Center(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: CupertinoColors.black.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
