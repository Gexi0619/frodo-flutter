import 'package:dio/dio.dart';

/// 从 [DioException] 或其他异常里提取用户可读的错误描述。
/// frodo 接口错误体里优先取 `localized_message` / `msg`。
String serverMessage(Object e) {
  if (e is DioException) {
    final data = e.response?.data;
    if (data is Map) {
      return (data['localized_message'] ?? data['msg'] ?? data.toString())
          as String;
    }
    return data?.toString() ?? e.message ?? e.toString();
  }
  return e.toString();
}
