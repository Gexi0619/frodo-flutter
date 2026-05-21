import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// 单个 frodo access token。`value` 在同一账号内唯一，可直接作 key。
@freezed
class AccessToken with _$AccessToken {
  const factory AccessToken({
    required String value,
    String? label,
    required int createdAt, // millisSinceEpoch
  }) = _AccessToken;

  factory AccessToken.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenFromJson(json);
}

/// 一个真实的豆瓣账号，下挂多个可切换的 token。
@freezed
class Account with _$Account {
  const factory Account({
    required String userId,
    required String name,
    String? avatar,
    @Default(<AccessToken>[]) List<AccessToken> tokens,
    required String activeToken, // == AccessToken.value
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(<Account>[]) List<Account> accounts,
    String? activeUserId,
  }) = _AuthState;

  const AuthState._();

  factory AuthState.empty() => const AuthState();

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  Account? get activeAccount {
    if (activeUserId == null) return null;
    for (final a in accounts) {
      if (a.userId == activeUserId) return a;
    }
    return null;
  }
}
