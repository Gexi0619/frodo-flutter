import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_models.dart';
import 'password_login_form.dart';
import 'sms_login_form.dart';
import 'token_login_form.dart';

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
        appBar: const CupertinoNavigationBar(middle: Text('登录')),
        body: SafeArea(
          child: Column(
            children: [
              // iOS 段控替代 Material TabBar，与全站 search 页风格一致。
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Builder(
                  builder: (context) {
                    final controller = DefaultTabController.of(context);
                    return AnimatedBuilder(
                      animation: controller,
                      builder: (_, __) =>
                          CupertinoSlidingSegmentedControl<int>(
                        groupValue: controller.index,
                        onValueChanged: (i) {
                          if (i != null) controller.animateTo(i);
                        },
                        children: const {
                          0: Text('账号密码'),
                          1: Text('短信验证码'),
                          2: Text('Access Token'),
                        },
                      ),
                    );
                  },
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    PasswordLoginForm(),
                    SmsLoginForm(),
                    TokenLoginForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 已登录用户在「为现有账号补充 token」时复用此页：导航时传 [Account] 作为 extra。
typedef LoginExtra = Account;
