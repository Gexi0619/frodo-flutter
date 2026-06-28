import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../ui/cupertino_ux.dart';
import 'login_shared.dart';

class SmsLoginForm extends ConsumerStatefulWidget {
  const SmsLoginForm({super.key});

  @override
  ConsumerState<SmsLoginForm> createState() => _SmsLoginFormState();
}

class _SmsLoginFormState extends ConsumerState<SmsLoginForm> {
  final _areaCtrl = TextEditingController(text: '86');
  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _labelCtrl = TextEditingController();

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
      if (mounted) showToast(context, '验证码已发送');
    } catch (e) {
      setState(() => _error = humanizeError(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _verify() async {
    if (_codeCtrl.text.trim().isEmpty) {
      setState(() => _error = '请输入验证码');
      return;
    }
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
      onLoggedIn(context, account);
    } catch (e) {
      setState(() => _error = humanizeError(e));
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Hint(
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
                child: CupertinoTextField(
                  controller: _areaCtrl,
                  enabled: !busy,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  padding: const EdgeInsets.all(12),
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('+'),
                  ),
                  placeholder: '区号',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CupertinoTextField(
                  controller: _phoneCtrl,
                  enabled: !busy,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  padding: const EdgeInsets.all(12),
                  placeholder: '手机号',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CupertinoTextField(
                  controller: _codeCtrl,
                  enabled: !busy && codeSent,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  padding: const EdgeInsets.all(12),
                  placeholder: '验证码',
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 56,
                child: CupertinoButton.filled(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  onPressed: (busy || _cooldown > 0) ? null : _sendCode,
                  child: _sending ? const BtnSpinner() : Text(sendLabel),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          CupertinoTextField(
            controller: _labelCtrl,
            enabled: !busy,
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
              onPressed: (busy || !codeSent) ? null : _verify,
              child: _submitting ? const BtnSpinner() : const Text('登录并保存'),
            ),
          ),
        ],
      ),
    );
  }
}
