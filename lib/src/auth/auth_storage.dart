import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'auth_models.dart';

/// SharedPreferences 持久化。MVP 阶段直接用 prefs；
/// 引入 flutter_secure_storage 时只需替换本类实现。
class AuthStorage {
  static const _key = 'auth_state_v1';

  Future<AuthState> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return AuthState.empty();
    try {
      return AuthState.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('AuthStorage: 解析失败，丢弃旧状态 – $e\n$st');
      return AuthState.empty();
    }
  }

  Future<void> save(AuthState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(state.toJson()));
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
