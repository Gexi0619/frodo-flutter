import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_api.dart';
import '../../auth/auth_providers.dart';
import 'login_shared.dart';

class PasswordLoginForm extends ConsumerStatefulWidget {
  const PasswordLoginForm({super.key});

  @override
  ConsumerState<PasswordLoginForm> createState() => _PasswordLoginFormState();
}

class _PasswordLoginFormState extends ConsumerState<PasswordLoginForm> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();
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
    if (_userCtrl.text.trim().isEmpty) {
      setState(() => _error = '请输入账号');
      return;
    }
    if (_passCtrl.text.isEmpty) {
      setState(() => _error = '请输入密码');
      return;
    }
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
      onLoggedIn(context, account);
    } on DeviceProtectionException catch (e) {
      // 设备保护：引导切到短信验证码 Tab（同一手机号收码即可）。
      if (!mounted) return;
      setState(() => _error = '$e\n请切换到「短信验证码」Tab 完成验证。');
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
            '用豆瓣账号（手机号）和密码登录。\n'
            '登录成功后服务端直接下发 access_token，'
            '随后与手动填 token 一样校验并保存。\n'
            '若账号开启了设备保护，请改用「短信验证码」。',
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: _userCtrl,
            enabled: !_submitting,
            autocorrect: false,
            enableSuggestions: false,
            keyboardType: TextInputType.phone,
            padding: const EdgeInsets.all(12),
            placeholder: '手机号 / 账号',
          ),
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: _passCtrl,
            enabled: !_submitting,
            obscureText: _obscure,
            autocorrect: false,
            enableSuggestions: false,
            padding: const EdgeInsets.all(12),
            placeholder: '密码',
            suffix: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              onPressed: () => setState(() => _obscure = !_obscure),
              child: Icon(
                _obscure ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                size: 20,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
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
