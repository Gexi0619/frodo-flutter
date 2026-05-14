// Run with: dart run bin/sig_test.dart
// 一次性脚本：验证 HMAC 签名能否让 frodo /api/v2/search/group_tab 返回 200。
import 'package:dio/dio.dart';

import '../lib/src/api/auth_interceptor.dart';
import '../lib/src/constants.dart';

Future<void> main() async {
  final dio = Dio(BaseOptions(baseUrl: FrodoConstants.frodoBaseUrl))
    ..interceptors.addAll([AuthInterceptor(), SimpleLogInterceptor()]);

  try {
    final res = await dio.get<Map<String, dynamic>>(
      '/api/v2/search/group_tab',
      queryParameters: {'q': 'cat', 'start': 0, 'count': 5},
    );
    final groups =
        (res.data?['groups'] as Map<String, dynamic>?)?['items'] as List?;
    final topics =
        (res.data?['topics'] as Map<String, dynamic>?)?['items'] as List?;
    print('OK: groups=${groups?.length ?? 0}, topics=${topics?.length ?? 0}');
  } on DioException catch (e) {
    print('FAIL: ${e.response?.statusCode} ${e.response?.data}');
  }
}
