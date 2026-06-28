import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import 'auth_api.dart';
import 'auth_models.dart';
import 'auth_storage.dart';

final _authStorageProvider = Provider<AuthStorage>((_) => AuthStorage());
final _authApiProvider = Provider<AuthApi>((_) => AuthApi());

/// 全局认证状态。启动时从 SharedPreferences 异步装载。
final authProvider =
    AsyncNotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends AsyncNotifier<AuthState> {
  late final AuthStorage _storage = ref.read(_authStorageProvider);
  late final AuthApi _api = ref.read(_authApiProvider);

  @override
  Future<AuthState> build() async {
    return _storage.load();
  }

  /// 新增 token。先调 `~me` 拿到 user_id；若该账号已存在则把 token 合并进去，
  /// 否则建一个新账号。完成后把这个 token 设为账号内的 active，并把账号设为全局 active。
  Future<Account> addToken({required String value, String? label}) async {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      throw AuthException('Token 不能为空');
    }
    final cleanedLabel = label?.trim().isEmpty == true ? null : label?.trim();

    final me = await _api.fetchMe(trimmed);

    final current = state.value ?? AuthState.empty();
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = current.accounts.firstWhere(
      (a) => a.userId == me.userId,
      orElse: () => Account(
        userId: me.userId,
        name: me.name,
        avatar: me.avatar,
        tokens: const [],
        activeToken: trimmed,
      ),
    );

    // 同账号下 token 去重：value 相同视为同一 token，更新 label。
    final tokens = [...existing.tokens];
    final idx = tokens.indexWhere((t) => t.value == trimmed);
    if (idx >= 0) {
      tokens[idx] = tokens[idx].copyWith(label: cleanedLabel ?? tokens[idx].label);
    } else {
      tokens.add(AccessToken(
        value: trimmed,
        label: cleanedLabel,
        createdAt: now,
      ));
    }

    final merged = existing.copyWith(
      name: me.name,
      avatar: me.avatar ?? existing.avatar,
      tokens: tokens,
      activeToken: trimmed,
    );

    final accounts = [...current.accounts];
    final aIdx = accounts.indexWhere((a) => a.userId == me.userId);
    if (aIdx >= 0) {
      accounts[aIdx] = merged;
    } else {
      accounts.add(merged);
    }

    final next = current.copyWith(
      accounts: accounts,
      activeUserId: me.userId,
    );
    await _commit(next);
    return merged;
  }

  /// 账号密码登录：换到 access_token 后复用 [addToken] 完成校验与归并。
  /// 账号开启设备保护时会抛 [DeviceProtectionException]，由调用方引导改用短信。
  Future<Account> loginWithPassword({
    required String username,
    required String password,
    String? label,
  }) async {
    final result = await _api.passwordLogin(username: username, password: password);
    return addToken(value: result.accessToken, label: label);
  }

  /// 短信登录第一步：用手机号请求验证码，返回服务端识别出的 user_id。
  Future<String?> requestSmsCode({
    required String phone,
    String areaCode = '86',
  }) {
    return _api.requestSmsCode(phone: phone, areaCode: areaCode);
  }

  /// 短信登录第二步：验证码换 token，并复用 [addToken] 完成 `~me` 校验、
  /// 账号归并与头像补全 —— 和手动填 token 完全同一条落库路径。
  Future<Account> loginWithSmsCode({
    required String userId,
    required String code,
    String? label,
  }) async {
    final result = await _api.verifySmsCode(userId: userId, code: code);
    return addToken(value: result.accessToken, label: label);
  }

  Future<void> switchAccount(String userId) async {
    final s = state.value ?? AuthState.empty();
    if (!s.accounts.any((a) => a.userId == userId)) return;
    await _commit(s.copyWith(activeUserId: userId));
  }

  Future<void> switchToken(String userId, String tokenValue) async {
    final s = state.value ?? AuthState.empty();
    final accounts = s.accounts.map((a) {
      if (a.userId != userId) return a;
      if (!a.tokens.any((t) => t.value == tokenValue)) return a;
      return a.copyWith(activeToken: tokenValue);
    }).toList();
    await _commit(s.copyWith(accounts: accounts, activeUserId: userId));
  }

  Future<void> removeToken(String userId, String tokenValue) async {
    final s = state.value ?? AuthState.empty();
    final accounts = <Account>[];
    String? activeUserId = s.activeUserId;
    for (final a in s.accounts) {
      if (a.userId != userId) {
        accounts.add(a);
        continue;
      }
      final tokens = a.tokens.where((t) => t.value != tokenValue).toList();
      if (tokens.isEmpty) {
        // 该账号没 token 了：连账号一起移除
        if (activeUserId == a.userId) activeUserId = null;
        continue;
      }
      final activeToken = a.activeToken == tokenValue
          ? tokens.first.value
          : a.activeToken;
      accounts.add(a.copyWith(tokens: tokens, activeToken: activeToken));
    }
    activeUserId ??= accounts.isEmpty ? null : accounts.first.userId;
    await _commit(s.copyWith(accounts: accounts, activeUserId: activeUserId));
  }

  Future<void> removeAccount(String userId) async {
    final s = state.value ?? AuthState.empty();
    final accounts = s.accounts.where((a) => a.userId != userId).toList();
    final activeUserId = s.activeUserId == userId
        ? (accounts.isEmpty ? null : accounts.first.userId)
        : s.activeUserId;
    await _commit(s.copyWith(accounts: accounts, activeUserId: activeUserId));
  }

  Future<void> renameToken(String userId, String tokenValue, String? label) async {
    final s = state.value ?? AuthState.empty();
    final cleaned = label?.trim();
    final accounts = s.accounts.map((a) {
      if (a.userId != userId) return a;
      final tokens = a.tokens.map((t) {
        if (t.value != tokenValue) return t;
        return t.copyWith(label: (cleaned == null || cleaned.isEmpty) ? null : cleaned);
      }).toList();
      return a.copyWith(tokens: tokens);
    }).toList();
    await _commit(s.copyWith(accounts: accounts));
  }

  Future<void> _commit(AuthState next) async {
    await _storage.save(next);
    state = AsyncData(next);
  }
}

/// 同步派生：当前请求要使用的 Bearer Token。
/// 未登录或加载中时降级到 MVP 阶段的硬编码兜底，保证旧代码无感。
final activeBearerProvider = Provider<String>((ref) {
  final s = ref.watch(authProvider).valueOrNull;
  final account = s?.activeAccount;
  if (account == null) return FrodoConstants.bearerToken;
  return account.activeToken;
});

/// 当前激活的账号（可能为 null）。
final activeAccountProvider = Provider<Account?>((ref) {
  return ref.watch(authProvider).valueOrNull?.activeAccount;
});

/// 当前用户 id：优先取激活账号；未登录/加载中时降级到 MVP 硬编码兜底。
///
/// 全 App 统一从这里取「我」的 user id —— 不要再直接引用
/// [FrodoConstants.defaultUserId]，否则切换账号后相关页面仍会按写死的旧账号取数。
final currentUserIdProvider = Provider<String>((ref) {
  return ref.watch(activeAccountProvider)?.userId ?? FrodoConstants.defaultUserId;
});
