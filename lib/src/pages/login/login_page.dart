import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_api.dart';
import '../../auth/auth_models.dart';
import '../../auth/auth_providers.dart';

/// 登录页：三种方式任选，落库路径完全一致（都最终经 `addToken` 校验归并）。
/// - 「账号密码」：手机号 + 密码直登 auth2/token。
/// - 「短信验证码」：手机号收码登录，验证成功后服务端直接下发 access_token。
/// - 「Access Token」：粘贴抓包得到的 frodo token。
///
/// 已登录用户「为现有账号补充 token」时复用本页：导航时传 [Account] 作为 extra。
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('登录'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '账号密码'),
              Tab(text: '短信验证码'),
              Tab(text: 'Access Token'),
            ],
          ),
        ),
        body: const SafeArea(
          child: TabBarView(
            children: [
              _PasswordLoginForm(),
              _SmsLoginForm(),
              _TokenLoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 登录成功后的统一收尾：提示 + 返回上一页（带回账号）或回首页。
void _onLoggedIn(BuildContext context, Account account) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('已登录 ${account.name}')),
  );
  if (context.canPop()) {
    context.pop(account);
  } else {
    context.go('/');
  }
}

// ===================== 账号密码 =====================

class _PasswordLoginForm extends ConsumerStatefulWidget {
  const _PasswordLoginForm();

  @override
  ConsumerState<_PasswordLoginForm> createState() => _PasswordLoginFormState();
}

class _PasswordLoginFormState extends ConsumerState<_PasswordLoginForm> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _submitting = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    _userCtrl.dispose();
    _passCtrl.dispose();
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
      final account = await ref.read(authProvider.notifier).loginWithPassword(
            username: _userCtrl.text.trim(),
            password: _passCtrl.text,
            label: _labelCtrl.text,
          );
      if (!mounted) return;
      _onLoggedIn(context, account);
    } on DeviceProtectionException catch (e) {
      // 设备保护：引导切到短信验证码 Tab（同一手机号收码即可）。
      if (!mounted) return;
      setState(() => _error = '$e\n请切换到「短信验证码」Tab 完成验证。');
    } catch (e) {
      setState(() => _error = _humanizeError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Hint(
              '用豆瓣账号（手机号）和密码登录。\n'
              '登录成功后服务端直接下发 access_token，'
              '随后与手动填 token 一样校验并保存。\n'
              '若账号开启了设备保护，请改用「短信验证码」。',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _userCtrl,
              enabled: !_submitting,
              autocorrect: false,
              enableSuggestions: false,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: '手机号 / 账号',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? '请输入账号' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passCtrl,
              enabled: !_submitting,
              obscureText: _obscure,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: '密码',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ),
              validator: (v) => (v?.isEmpty ?? true) ? '请输入密码' : null,
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
                  ? const _BtnSpinner()
                  : const Text('登录并保存'),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== 手动 Token =====================

class _TokenLoginForm extends ConsumerStatefulWidget {
  const _TokenLoginForm();

  @override
  ConsumerState<_TokenLoginForm> createState() => _TokenLoginFormState();
}

class _TokenLoginFormState extends ConsumerState<_TokenLoginForm> {
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
      _onLoggedIn(context, account);
    } catch (e) {
      setState(() => _error = _humanizeError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Hint(
              '粘贴抓包得到的豆瓣 frodo access token。\n'
              '系统会用它调用 ~me 验证有效性并自动识别归属账号；\n'
              '同一账号的多个 token 会归并展示，可随时切换。',
            ),
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
                  ? const _BtnSpinner()
                  : const Text('登录并保存'),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== 短信验证码 =====================

class _SmsLoginForm extends ConsumerStatefulWidget {
  const _SmsLoginForm();

  @override
  ConsumerState<_SmsLoginForm> createState() => _SmsLoginFormState();
}

class _SmsLoginFormState extends ConsumerState<_SmsLoginForm> {
  final _areaCtrl = TextEditingController(text: '86');
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _userId; // 发码成功后由服务端返回，验证时必须带上
  bool _sending = false; // 正在发码
  bool _submitting = false; // 正在验证登录
  String? _error;

  Timer? _timer;
  int _cooldown = 0; // 重新发送倒计时（秒）

  @override
  void dispose() {
    _timer?.cancel();
    _areaCtrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _labelCtrl.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _cooldown = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() => _cooldown--);
      if (_cooldown <= 0) t.cancel();
    });
  }

  Future<void> _sendCode() async {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      setState(() => _error = '请输入手机号');
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final area = _areaCtrl.text.trim().isEmpty ? '86' : _areaCtrl.text.trim();
      final userId = await ref
          .read(authProvider.notifier)
          .requestSmsCode(phone: phone, areaCode: area);
      if (!mounted) return;
      if (userId == null) {
        setState(() => _error = '验证码已发送，但服务端未返回账号标识，'
            '该号码可能无法用此方式登录。');
        return;
      }
      setState(() => _userId = userId);
      _startCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('验证码已发送')),
      );
    } catch (e) {
      setState(() => _error = _humanizeError(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    final userId = _userId;
    if (userId == null) {
      setState(() => _error = '请先获取验证码');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final account = await ref.read(authProvider.notifier).loginWithSmsCode(
            userId: userId,
            code: _codeCtrl.text.trim(),
            label: _labelCtrl.text,
          );
      if (!mounted) return;
      _onLoggedIn(context, account);
    } catch (e) {
      setState(() => _error = _humanizeError(e));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = _sending || _submitting;
    final codeSent = _userId != null;
    final sendLabel = _cooldown > 0 ? '${_cooldown}s' : '获取验证码';
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _Hint(
              '使用绑定手机号收取短信验证码登录。\n'
              '验证成功后服务端直接下发 access_token，'
              '随后与手动填 token 一样校验并保存。',
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 88,
                  child: TextFormField(
                    controller: _areaCtrl,
                    enabled: !busy,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: '区号',
                      prefixText: '+',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _phoneCtrl,
                    enabled: !busy,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: '手机号',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _codeCtrl,
                    enabled: !busy && codeSent,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      labelText: '验证码',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isEmpty) return '请输入验证码';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed:
                        (busy || _cooldown > 0) ? null : _sendCode,
                    child: _sending
                        ? const _BtnSpinner()
                        : Text(sendLabel),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _labelCtrl,
              enabled: !busy,
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
              onPressed: (busy || !codeSent) ? null : _verify,
              child: _submitting
                  ? const _BtnSpinner()
                  : const Text('登录并保存'),
            ),
          ],
        ),
      ),
    );
  }
}

// ===================== 共用小部件 =====================

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

class _BtnSpinner extends StatelessWidget {
  const _BtnSpinner();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);
  final String text;

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
        text,
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
typedef LoginExtra = Account;
