import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_api.dart';
import '../../auth/auth_models.dart';
import '../../auth/auth_providers.dart';

/// 手动输入 access token 完成登录。
/// 既用于新增账号，也用于为已有账号添加备用 token —— 通过 `/api/v2/user/~me`
/// 返回的 userId 自动判定属于哪个账号。
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _tokenCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _tokenCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('已登录 ${account.name}')),
      );
      if (context.canPop()) {
        context.pop(account);
      } else {
        context.go('/');
      }
    } catch (e) {
      setState(() => _error = _humanizeError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('添加 Access Token')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const _Hint(),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _tokenCtrl,
                  enabled: !_submitting,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                    labelText: 'Access Token',
                    hintText: '32 位 hex 字符串',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return '请输入 token';
                    if (t.length < 16) return 'token 看上去太短';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _labelCtrl,
                  enabled: !_submitting,
                  decoration: const InputDecoration(
                    labelText: '备注（可选）',
                    hintText: '如 iPhone / 小号 / 备用',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  _ErrorBanner(_error!),
                ],
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('登录并保存'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _humanizeError(Object e) {
  if (e is AuthException) return e.message;
  if (e is DioException) {
    final code = e.response?.statusCode;
    if (code == 401 || code == 403) return 'Token 无效或已失效（$code）';
    if (code != null) return '请求失败：HTTP $code';
    return '网络错误：${e.message ?? e.type.name}';
  }
  return e.toString();
}

class _Hint extends StatelessWidget {
  const _Hint();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '粘贴抓包得到的豆瓣 frodo access token。\n'
        '系统会用它调用 ~me 验证有效性并自动识别归属账号；\n'
        '同一账号的多个 token 会归并展示，可随时切换。',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner(this.message);
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 18, color: scheme.onErrorContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

/// 已登录用户在「为现有账号补充 token」时复用此页：导航时传 [Account] 作为 extra。
/// 这里只用 LoginPage 即可（API 流程相同：调 ~me 自动判断账号归属）。
typedef LoginExtra = Account;
