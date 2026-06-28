import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import 'login_shared.dart';

class TokenLoginForm extends ConsumerStatefulWidget {
  const TokenLoginForm({super.key});

  @override
  ConsumerState<TokenLoginForm> createState() => _TokenLoginFormState();
}

class _TokenLoginFormState extends ConsumerState<TokenLoginForm> {
  final _tokenCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final token = _tokenCtrl.text.trim();
    if (token.isEmpty) {
      setState(() => _error = '请输入 token');
      return;
    }
    if (token.length < 16) {
      setState(() => _error = 'token 看上去太短');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final account = await ref.read(authProvider.notifier).addToken(
            value: _tokenCtrl.text,
            label: _labelCtrl.text,
          );
      if (!mounted) return;
      onLoggedIn(context, account);
    } catch (e) {
      setState(() => _error = humanizeError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Hint(
            '粘贴抓包得到的豆瓣 frodo access token。\n'
            '系统会用它调用 ~me 验证有效性并自动识别归属账号；\n'
            '同一账号的多个 token 会归并展示，可随时切换。',
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: _tokenCtrl,
            enabled: !_submitting,
            autocorrect: false,
            enableSuggestions: false,
            padding: const EdgeInsets.all(12),
            placeholder: 'Access Token（32 位 hex）',
          ),
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: _labelCtrl,
            enabled: !_submitting,
            padding: const EdgeInsets.all(12),
            placeholder: '备注（可选，如 iPhone / 小号）',
          ),
          if (_error != null) ...[
            const SizedBox(height: 12),
            ErrorBanner(_error!),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: _submitting ? null : _submit,
              child: _submitting ? const BtnSpinner() : const Text('登录并保存'),
            ),
          ),
        ],
      ),
    );
  }
}
