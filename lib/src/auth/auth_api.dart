import 'package:dio/dio.dart';

import '../api/auth_interceptor.dart';
import '../constants.dart';

/// 用候选 token 拿到当前登录用户信息，作为 frodo 没有 `~me` 接口的替代方案：
///
/// 思路：电影详情接口 `/api/v2/movie/<id>` 的响应里有 `interest.user`，
/// 这是「当前登录用户对该电影的兴趣记录」的归属用户 —— 服务端是从 bearer
/// token 反查出来的，因此可以稳定地用它识别 token 的真正主人。
///
/// 我们用 OpenAPI example 里验证过的 movie_id 1291546 作为探针，
/// 用户无需对它有任何标记，interest.user 字段总是会包含当前用户的引用。
class AuthApi {
  /// 探针 movie_id：OpenAPI example 中实际抓包用的，长期稳定存在。
  static const String _probeMovieId = '1291546';

  Future<MeInfo> fetchMe(String bearer) async {
    final dio = Dio(BaseOptions(
      baseUrl: FrodoConstants.frodoBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ));
    dio.interceptors.add(AuthInterceptor.withBearer(bearer));

    final res = await dio.get<Map<String, dynamic>>(
      '/api/v2/movie/$_probeMovieId',
    );
    final data = res.data;
    if (data == null) {
      throw AuthException('服务端返回空响应');
    }
    final interest = data['interest'];
    final user = interest is Map<String, dynamic> ? interest['user'] : null;
    if (user is! Map<String, dynamic>) {
      throw AuthException('响应缺少 interest.user 字段，token 可能无效');
    }
    final id = user['id']?.toString();
    final name = user['name']?.toString();
    if (id == null || id.isEmpty || name == null || name.isEmpty) {
      throw AuthException('响应里 user.id/name 缺失');
    }
    return MeInfo(
      userId: id,
      name: name,
      avatar: user['avatar']?.toString(),
    );
  }
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
