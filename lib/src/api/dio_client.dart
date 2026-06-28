import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../constants.dart';
import 'auth_interceptor.dart';
import 'json_utils.dart';

/// 默认 Dio 实例（frodo 域名）。Bearer 在每次请求时从 [activeBearerProvider] 读出。
final dioProvider = Provider<Dio>((ref) {
  return _buildDio(FrodoConstants.frodoBaseUrl, ref);
});

/// rexxar / m 站 Dio 实例。
final rexxarDioProvider = Provider<Dio>((ref) {
  return _buildDio(FrodoConstants.rexxarBaseUrl, ref);
});

Dio _buildDio(String baseUrl, Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(() => ref.read(activeBearerProvider)),
    SimpleLogInterceptor(),
  ]);
  return dio;
}

/// frodo 接口几乎都返回顶层 JSON object，仓库层取出后还要 [asMap] 兜一次空响应。
/// 这两个 helper 把「请求 + 取顶层 map」压成一行，省掉满仓库重复的
/// `final res = await dio.get<Map<String, dynamic>>(...); final data = asMap(res.data);`。
extension FrodoRequest on Dio {
  /// GET 并取出顶层 map（空 / 非 map 响应归一为 `{}`）。
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final res = await get<Map<String, dynamic>>(path, queryParameters: query);
    return asMap(res.data);
  }

  /// POST 并取出顶层 map。[data] 可为 `Map` / `FormData`；[options] 透传
  /// （如设置 `contentType`）。
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    final res = await post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: query,
      options: options,
    );
    return asMap(res.data);
  }
}
