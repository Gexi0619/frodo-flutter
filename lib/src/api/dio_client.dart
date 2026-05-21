import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_providers.dart';
import '../constants.dart';
import 'auth_interceptor.dart';

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
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.addAll([
    AuthInterceptor(() => ref.read(activeBearerProvider)),
    SimpleLogInterceptor(),
  ]);
  return dio;
}
