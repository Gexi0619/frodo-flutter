import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_api.dart';
import '../../auth/auth_models.dart';
import '../../ui/cupertino_ux.dart';

/// 登录成功后的统一收尾：提示 + 返回上一页（带回账号）或回首页。
void onLoggedIn(BuildContext context, Account account) {
  showToast(context, '已登录 ${account.name}');
  if (context.canPop()) {
    context.pop(account);
  } else {
    context.go('/');
  }
}

/// 把登录链路上的异常转成简短的中文提示。
String humanizeError(Object e) {
  if (e is AuthException) return e.message;
  if (e is DioException) {
    final code = e.response?.statusCode;
    if (code == 401 || code == 403) return 'Token 无效或已失效（$code）';
    if (code != null) return '请求失败：HTTP $code';
    return '网络错误：${e.message ?? e.type.name}';
  }
  return e.toString();
}

/// 按钮内的小转圈，登录提交中用。
class BtnSpinner extends StatelessWidget {
  const BtnSpinner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CupertinoActivityIndicator(),
    );
  }
}

/// 表单顶部的灰底说明块。
class Hint extends StatelessWidget {
  const Hint(this.text, {super.key});
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

/// 表单内的红底错误条。
class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {super.key});
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
          Icon(CupertinoIcons.exclamationmark_circle, size: 18, color: scheme.onErrorContainer),
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
