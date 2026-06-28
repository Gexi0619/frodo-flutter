import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../models/author.dart';
import '../../models/chat.dart';
import '../../repositories/chat_repository.dart';
import '../../ui/dimens.dart';
import '../../utils/time.dart';
import '../../widgets/error_view.dart';
import '../../widgets/frodo_image.dart';
import '../../widgets/paging_mixin.dart';
import '../../widgets/user_avatar.dart';

/// 私信会话详情页：展示与某人的聊天内容（`GET /api/v2/im/messages`）并支持
/// 发送文本消息（`POST .../chat/create_message`）。
///
/// 消息按时间倒序渲染（最新在底部），向上滚动加载更早的历史；发送采用乐观更新
/// （先本地插入，按 nonce 与服务端回包对账，失败回滚）。从私信列表进入时携带
/// [seed] 直接渲染头部；只有 `cid` 时回退到「聊天框信息」接口补齐对方信息。
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.cid, this.seed});

  /// 会话 id：私信(private)即对方的 user id。
  final String cid;

  /// 列表点进来时带过来的会话，用于即时渲染头部，可空。
  final Chat? seed;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  /// 倒序存储（index 0 = 最新一条），配合 `reverse: true` 的 ListView。
  final List<ChatMessage> _messages = [];
  final ScrollController _scroll = ScrollController();
  final TextEditingController _input = TextEditingController();

  Chat? _header;
  bool _initialLoading = true;
  bool _loadingMore = false;
  bool _hasMore = true;
  bool _sending = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _header = widget.seed;
    _scroll.addListener(_onScroll);
    _init();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _input.dispose();
    super.dispose();
  }

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  Future<void> _init() async {
    // 头部信息缺失时（仅有 cid 的入口）先补齐对方信息，失败不阻塞消息加载。
    if (_header == null) {
      try {
        final box = await _repo.fetchChatBox(widget.cid);
        if (mounted) setState(() => _header = box);
      } catch (_) {
        /* 头部拿不到就用占位标题，忽略 */
      }
    }
    await _loadInitial();
  }

  Future<void> _loadInitial() async {
    setState(() {
      _initialLoading = true;
      _error = null;
    });
    try {
      final page = await _repo.fetchMessages(
        cid: widget.cid,
        maxId: 0,
        count: kPageSize,
      );
      if (!mounted) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(page.reversed); // 接口升序 → 倒序存储
        _hasMore = page.length >= kPageSize;
        _initialLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e;
        _initialLoading = false;
      });
    }
  }

  void _onScroll() {
    // reverse:true 下，maxScrollExtent 一端是最旧的消息——滚近顶部即加载历史。
    if (!_hasMore || _loadingMore) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 240) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    final oldest = _messages.isEmpty ? null : _messages.last.id;
    if (oldest == null) return;
    setState(() => _loadingMore = true);
    try {
      final page = await _repo.fetchMessages(
        cid: widget.cid,
        maxId: int.tryParse(oldest) ?? 0,
        count: kPageSize,
      );
      if (!mounted) return;
      setState(() {
        _messages.addAll(page.reversed);
        _hasMore = page.length >= kPageSize;
        _loadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingMore = false);
    }
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty || _sending) return;

    // 本地生成 nonce 并乐观插入，等服务端回带同 nonce 的真实消息再替换。
    final nonce = DateTime.now().millisecondsSinceEpoch;
    final optimistic = ChatMessage(
      text: text,
      nonce: nonce,
      createTime: _cstNow(),
      author: Author(id: ref.read(currentUserIdProvider), name: ''),
    );
    setState(() {
      _messages.insert(0, optimistic);
      _sending = true;
      _input.clear();
    });
    _scrollToBottom();

    try {
      final sent = await _repo.sendMessage(
        cid: widget.cid,
        text: text,
        nonce: nonce,
      );
      if (!mounted) return;
      setState(() {
        final i = _messages.indexWhere((m) => m.nonce == nonce);
        if (i >= 0) _messages[i] = sent; // 用服务端消息（含真实 id/时间）替换占位
        _sending = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.removeWhere((m) => m.nonce == nonce); // 失败回滚
        _input.text = text; // 把内容还给输入框，方便重发
        _sending = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('发送失败，请重试')));
    }
  }

  void _scrollToBottom() {
    // reverse:true 下，offset 0 即最新一条所在的底部。
    if (!_scroll.hasClients) return;
    _scroll.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  /// 以豆瓣接口的 CST 字符串格式给出当前时间（乐观消息占位用）。
  String _cstNow() {
    final t = DateTime.now().toUtc().add(const Duration(hours: 8));
    String p(int v) => v.toString().padLeft(2, '0');
    return '${t.year}-${p(t.month)}-${p(t.day)} ${p(t.hour)}:${p(t.minute)}:${p(t.second)}';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(_header?.targetUser?.name ?? '私信'),
        backgroundColor: scheme.surface,
        border: Border(
          bottom: BorderSide(
            color: scheme.onSurface.withValues(alpha: 0.12),
            width: 0.0,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          color: scheme.primary,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody()),
          _Composer(
            controller: _input,
            sending: _sending,
            enabled: _header?.canInteract ?? true,
            disabledHint: _header?.emptyMessage,
            onSend: _send,
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_initialLoading) {
      return const Center(child: CupertinoActivityIndicator());
    }
    if (_error != null && _messages.isEmpty) {
      return ErrorView(error: _error!, onRetry: _loadInitial);
    }
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          _header?.emptyMessage?.isNotEmpty == true
              ? _header!.emptyMessage!
              : '还没有消息',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    final me = ref.watch(currentUserIdProvider);
    return ListView.builder(
      controller: _scroll,
      reverse: true,
      padding: const EdgeInsets.symmetric(vertical: Dim.md),
      itemCount: _messages.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= _messages.length) {
          return const Padding(
            padding: EdgeInsets.all(Dim.md),
            child: Center(child: CupertinoActivityIndicator()),
          );
        }
        final msg = _messages[index];
        // 倒序列表里「时间上更早的一条」是 index+1。
        final older = index + 1 < _messages.length
            ? _messages[index + 1]
            : null;
        final showTime = _shouldShowTime(older?.createTime, msg.createTime);
        return Column(
          children: [
            if (showTime) _TimeDivider(time: msg.createTime),
            _MessageBubble(message: msg, isMine: msg.author?.id == me),
          ],
        );
      },
    );
  }

  /// 与上一条（时间更早）相隔超过 5 分钟时插入时间分隔。
  bool _shouldShowTime(String? prev, String? cur) {
    final c = parseCstTime(cur);
    if (c == null) return false;
    final p = parseCstTime(prev);
    if (p == null) return true;
    return c.difference(p).inMinutes.abs() >= 5;
  }
}

class _TimeDivider extends StatelessWidget {
  const _TimeDivider({required this.time});

  final String? time;

  @override
  Widget build(BuildContext context) {
    final label = formatDateTime(time);
    if (label == null || label.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Dim.sm),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}

/// 单条消息气泡：自己发的靠右（主色），对方靠左（带头像）。
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, required this.isMine});

  final ChatMessage message;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final author = message.author;

    final bubble = Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * 0.7,
      ),
      decoration: BoxDecoration(
        color: isMine
            ? scheme.primaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Dim.radiusMd),
      ),
      clipBehavior: Clip.antiAlias,
      child: _content(context),
    );

    final row = Row(
      mainAxisAlignment: isMine
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMine) ...[
          UserAvatar(
            url: author?.avatar,
            radius: Dim.avatarMd / 2,
            userId: author?.id,
          ),
          const SizedBox(width: Dim.sm),
        ],
        Flexible(child: bubble),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dim.lg, vertical: Dim.xs),
      child: row,
    );
  }

  Widget _content(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final fg = isMine ? scheme.onPrimaryContainer : scheme.onSurface;

    final url = message.imageUrl;
    if (url != null && url.isNotEmpty) {
      final ratio = message.imageAspectRatio ?? 1;
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 220),
        child: AspectRatio(
          aspectRatio: ratio.clamp(0.5, 2.0),
          child: FrodoImage.tile(imageUrl: url),
        ),
      );
    }

    final text = message.text?.isNotEmpty == true
        ? message.text!
        : (message.card?.title ?? message.sysLink?.text ?? '');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dim.md, vertical: Dim.sm),
      child: Text(text, style: theme.textTheme.bodyMedium?.copyWith(color: fg)),
    );
  }
}

/// 底部输入栏：文本输入 + 发送按钮。[enabled] 为 false（对方关闭私信等）时
/// 整栏禁用并显示 [disabledHint]。
class _Composer extends StatelessWidget {
  const _Composer({
    required this.controller,
    required this.sending,
    required this.enabled,
    required this.onSend,
    this.disabledHint,
  });

  final TextEditingController controller;
  final bool sending;
  final bool enabled;
  final String? disabledHint;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (!enabled) {
      return SafeArea(
        top: false,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(Dim.lg),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: scheme.outlineVariant, width: 0.6),
            ),
          ),
          child: Text(
            disabledHint?.isNotEmpty == true ? disabledHint! : '无法向该用户发送消息',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
        ),
      );
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Dim.md,
          vertical: Dim.sm,
        ),
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(
            top: BorderSide(color: scheme.outlineVariant, width: 0.6),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CupertinoTextField(
                controller: controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => onSend(),
                placeholder: '发消息…',
                padding: const EdgeInsets.symmetric(
                  horizontal: Dim.md,
                  vertical: Dim.sm,
                ),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(Dim.radiusLg),
                ),
              ),
            ),
            const SizedBox(width: Dim.sm),
            sending
                ? const Padding(
                    padding: EdgeInsets.all(Dim.sm),
                    child: SizedBox(
                      width: Dim.iconMd,
                      height: Dim.iconMd,
                      child: CupertinoActivityIndicator(),
                    ),
                  )
                : CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: onSend,
                    child: Icon(
                      CupertinoIcons.arrow_up_circle_fill,
                      color: scheme.primary,
                      size: 30,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
