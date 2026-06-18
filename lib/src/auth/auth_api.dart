import 'package:dio/dio.dart';

import '../api/auth_interceptor.dart';
import '../constants.dart';

/// 用候选 token 拿到当前登录用户信息，作为 frodo 没有 `~me` 接口的替代方案：
///
/// 思路：请求电影详情 `/api/v2/movie/<id>`，从响应里反查出 token 的归属用户。
/// 服务端会把当前登录用户写进两处，我们按可靠性依次尝试：
///   1) `interest.user` —— 当前用户对该片的兴趣记录的归属用户；**但用户没标记过
///      这部片时 `interest` 为 null**，此路不通。
///   2) `vendors[].click_trackings/impression_trackings` 里的埋点 URL，形如
///      `…?subject_id=1291546&…&user_id=295663577&…`。这个 `user_id` 由服务端
///      从 bearer 注入，与用户是否标记无关，只要该片有在线观看源就一定存在。
///
/// `interest.user` 能一次拿齐 id+name+avatar；只命中埋点 URL 时只有 user_id，
/// 再调 `/api/v2/user/<id>` 补全昵称与头像。
///
/// 探针固定用 movie_id 1291546（《霸王别姬》）：长期稳定且有多个 vendors。
class AuthApi {
  /// 探针 movie_id：《霸王别姬》，长期稳定且有腾讯/咪咕/B站等在线源。
  static const String _probeMovieId = '1291546';

  /// 从埋点 URL 里抠 `user_id=<digits>`。
  static final RegExp _userIdInUrl = RegExp(r'[?&]user_id=(\d+)');

  Dio _frodoDio(String bearer) {
    final dio = Dio(BaseOptions(
      baseUrl: FrodoConstants.frodoBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ));
    dio.interceptors.add(AuthInterceptor.withBearer(bearer));
    return dio;
  }

  Future<MeInfo> fetchMe(String bearer) async {
    final dio = _frodoDio(bearer);

    final res = await dio.get<Map<String, dynamic>>(
      '/api/v2/movie/$_probeMovieId',
    );
    final data = res.data;
    if (data == null) {
      throw AuthException('服务端返回空响应');
    }

    // 路径 1：interest.user（标记过该片时，一次拿齐 id/name/avatar）。
    final interest = data['interest'];
    final user = interest is Map<String, dynamic> ? interest['user'] : null;
    if (user is Map<String, dynamic>) {
      final id = user['id']?.toString();
      final name = user['name']?.toString();
      if (id != null && id.isNotEmpty && name != null && name.isNotEmpty) {
        return MeInfo(
          userId: id,
          name: name,
          avatar: user['avatar']?.toString(),
        );
      }
    }

    // 路径 2：从 vendors 埋点 URL 反查 user_id，再补全资料。
    final userId = _extractUserIdFromVendors(data['vendors']);
    if (userId == null) {
      throw AuthException('无法从响应识别 token 归属用户，token 可能无效');
    }
    return _fetchUserProfile(dio, userId);
  }

  /// 遍历 vendors[].click_trackings / impression_trackings，抠出第一个 user_id。
  String? _extractUserIdFromVendors(dynamic vendors) {
    if (vendors is! List) return null;
    for (final v in vendors) {
      if (v is! Map) continue;
      for (final key in const ['click_trackings', 'impression_trackings']) {
        final urls = v[key];
        if (urls is! List) continue;
        for (final url in urls) {
          final m = _userIdInUrl.firstMatch(url.toString());
          if (m != null) return m.group(1);
        }
      }
    }
    return null;
  }

  /// 只拿到 user_id 时，用 `/api/v2/user/<id>` 补全昵称与头像。
  /// 拉取失败不致命：退化成仅含 user_id 的 MeInfo（账号仍可正常落库）。
  Future<MeInfo> _fetchUserProfile(Dio dio, String userId) async {
    try {
      final res = await dio.get<Map<String, dynamic>>('/api/v2/user/$userId');
      final u = res.data;
      if (u != null) {
        final name = u['name']?.toString();
        return MeInfo(
          userId: userId,
          name: (name != null && name.isNotEmpty) ? name : userId,
          avatar: u['avatar']?.toString() ?? u['large_avatar']?.toString(),
        );
      }
    } on DioException {
      // 资料接口失败时忽略，下面用 user_id 兜底。
    }
    return MeInfo(userId: userId, name: userId);
  }

  /// 账号密码登录：POST /service/auth2/token（grant_type=password）。
  ///
  /// 这个接口在 frodo.douban.com，但登录时还没有 token，所以**不能**走全局
  /// AuthInterceptor（它会注入 Bearer 并把 Bearer 算进签名）。这里用独立 Dio，
  /// 用 [frodoSign] 以「无 bearer」形式签名，client_id/secret/_sig/_ts 一并塞进表单。
  ///
  /// 成功时直接返回 access_token；若账号开启了设备保护，服务端返回 400 +
  /// code 9000，转换为 [DeviceProtectionException]（携带可用于短信验证的 user_id）。
  Future<LoginResult> passwordLogin({
    required String username,
    required String password,
  }) async {
    final sig = frodoSign(method: 'POST', path: '/service/auth2/token');
    final dio = Dio(BaseOptions(
      baseUrl: FrodoConstants.frodoBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
      headers: {'User-Agent': FrodoConstants.userAgent},
    ));
    try {
      final res = await dio.post<Map<String, dynamic>>(
        '/service/auth2/token',
        queryParameters: {
          'apikey': FrodoConstants.apiKey,
          '_ts': sig.ts,
          '_sig': sig.sig,
        },
        data: {
          'client_id': FrodoConstants.clientId,
          'client_secret': FrodoConstants.frodoSignSecret,
          'disable_account_create': 'false',
          'grant_type': 'password',
          'username': username,
          'password': password,
          'apikey': FrodoConstants.apiKey,
          '_ts': sig.ts,
          '_sig': sig.sig,
        },
      );
      final data = res.data;
      if (data == null) throw AuthException('服务端返回空响应');
      final token = data['access_token']?.toString();
      if (token == null || token.isEmpty) {
        throw AuthException('登录未返回 access_token');
      }
      return LoginResult(
        accessToken: token,
        userId: data['douban_user_id']?.toString() ?? '',
        name: data['douban_user_name']?.toString() ?? '',
        refreshToken: data['refresh_token']?.toString(),
        expiresIn: (data['expires_in'] as num?)?.toInt(),
      );
    } on DioException catch (e) {
      throw _mapTokenError(e);
    }
  }

  /// 把 auth2/token 的错误响应翻译成可读异常。
  AuthException _mapTokenError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['msg']?.toString();
      final localized = data['localized_message']?.toString();
      final code = data['code'];
      // 设备保护：需要短信验证。从 solution_uri 里取出 user_id 供下一步用。
      if (code == 9000 || msg == 'invalid_device_id') {
        String? userId;
        final extra = data['extra'];
        final uri = extra is Map ? extra['solution_uri']?.toString() : null;
        if (uri != null) {
          userId = Uri.tryParse(uri)?.queryParameters['user_id'];
        }
        return DeviceProtectionException(
          localized ?? '该账号已开启设备保护，请改用短信验证码登录',
          userId: userId,
        );
      }
      if (localized != null && localized.isNotEmpty) return AuthException(localized);
      if (msg != null && msg.isNotEmpty) return AuthException(msg);
    }
    final status = e.response?.statusCode;
    return AuthException('登录失败：${status ?? e.message ?? e.type.name}');
  }

  // ===== 短信验证码登录 =====
  //
  // 流程见 openapi `login` 标签：
  //   1) POST /j/app/login/request_phone_code  —— 用手机号请求验证码（无需鉴权）
  //   2) POST /j/app/verify_phone/verify_phone_code —— 用 user_id + 验证码换取 token
  //
  // 这两个接口在 accounts.douban.com 上，既不要 Bearer 也不要 HMAC 签名，
  // 因此用一个不挂全局 AuthInterceptor 的独立 Dio，只伪装 UA、表单提交。

  Dio _accountsDio() => Dio(BaseOptions(
        baseUrl: FrodoConstants.accountsBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 10),
        contentType: Headers.formUrlEncodedContentType,
        responseType: ResponseType.json,
        headers: {'User-Agent': FrodoConstants.userAgent},
      ));

  /// 第一步：用手机号请求短信验证码。
  ///
  /// 成功后服务端下发短信，并在响应里带回该手机号对应的 `user_id`
  /// （第二步验证需要它）。若响应未提供则返回 null，调用方需提示用户。
  Future<String?> requestSmsCode({
    required String phone,
    String areaCode = '86',
  }) async {
    final res = await _accountsDio().post<Map<String, dynamic>>(
      '/j/app/login/request_phone_code',
      data: {
        'number': phone,
        'area_code': areaCode,
        'apikey': FrodoConstants.apiKey,
      },
    );
    final data = res.data ?? const <String, dynamic>{};
    _ensureSuccess(data);
    return _extractUserId(data);
  }

  /// 第二步：用 user_id + 短信验证码换取登录态。
  ///
  /// 成功响应 payload 内含 access_token / refresh_token / 用户信息，
  /// 一次性拿到鉴权所需的一切。
  Future<LoginResult> verifySmsCode({
    required String userId,
    required String code,
  }) async {
    final res = await _accountsDio().post<Map<String, dynamic>>(
      '/j/app/verify_phone/verify_phone_code',
      data: {
        'client_id': FrodoConstants.clientId,
        'user_id': userId,
        'phone_code': code,
        'apikey': FrodoConstants.apiKey,
      },
    );
    final data = res.data;
    if (data == null) throw AuthException('服务端返回空响应');
    _ensureSuccess(data);
    final payload = data['payload'];
    if (payload is! Map<String, dynamic>) {
      throw AuthException('响应缺少 payload 字段');
    }
    final token = payload['access_token']?.toString();
    if (token == null || token.isEmpty) {
      throw AuthException('验证未返回 access_token，验证码可能有误');
    }
    return LoginResult(
      accessToken: token,
      userId: (payload['douban_user_id'] ?? userId).toString(),
      name: payload['douban_user_name']?.toString() ?? '',
      refreshToken: payload['refresh_token']?.toString(),
      expiresIn: (payload['expires_in'] as num?)?.toInt(),
    );
  }

  /// 校验豆瓣账号接口的通用「成功」约定：
  /// - 形如 {status:'success', ...}：status 非 success 即失败
  /// - 形如 {code:非0, msg/localized_message:...}：错误码非 0 即失败
  void _ensureSuccess(Map<String, dynamic> data) {
    final status = data['status']?.toString();
    if (status != null && status != 'success') {
      throw AuthException(data['description']?.toString() ??
          data['message']?.toString() ??
          '请求失败');
    }
    final code = data['code'];
    if (code is num && code != 0) {
      throw AuthException(data['localized_message']?.toString() ??
          data['msg']?.toString() ??
          '请求失败（code $code）');
    }
  }

  /// 从发码响应里尽量挖出 user_id（字段位置各接口略有出入）。
  String? _extractUserId(Map<String, dynamic> data) {
    final payload = data['payload'];
    if (payload is Map<String, dynamic>) {
      final id = payload['user_id'] ?? payload['douban_user_id'];
      if (id != null && id.toString().isNotEmpty) return id.toString();
    }
    final top = data['user_id'] ?? data['douban_user_id'];
    final s = top?.toString();
    return (s != null && s.isNotEmpty) ? s : null;
  }
}

/// 短信验证码登录成功后的结果。
class LoginResult {
  const LoginResult({
    required this.accessToken,
    required this.userId,
    required this.name,
    this.refreshToken,
    this.expiresIn,
  });
  final String accessToken;
  final String userId;
  final String name;
  final String? refreshToken;
  final int? expiresIn;
}

class MeInfo {
  const MeInfo({required this.userId, required this.name, this.avatar});
  final String userId;
  final String name;
  final String? avatar;
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// 账号开启设备保护时，密码登录会失败并要求短信验证。
/// [userId] 取自服务端返回的 solution_uri，可直接用于账号版短信验证。
class DeviceProtectionException extends AuthException {
  DeviceProtectionException(super.message, {this.userId});
  final String? userId;
}
