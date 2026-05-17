import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants.dart';

/// 全局拦截器：根据 host 注入 UA / Bearer / Cookie / HMAC 签名。
///
/// - frodo.douban.com：Bearer + apikey + HMAC-SHA1 签名（_sig & _ts）
/// - m.douban.com / www.douban.com：Cookie 鉴权
/// - 三类 host 均需 User-Agent 伪装
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['User-Agent'] = FrodoConstants.userAgent;

    final host = options.uri.host;
    if (host.contains('frodo.douban.com')) {
      options.headers['Authorization'] =
          'Bearer ${FrodoConstants.bearerToken}';
      options.queryParameters
          .putIfAbsent('apikey', () => FrodoConstants.apiKey);

      final sig = _signFrodo(
        method: options.method,
        path: options.uri.path,
        bearer: FrodoConstants.bearerToken,
      );
      // Dio 会对 queryParameters 自动 URL 编码，与 Postman pre-request 等价
      options.queryParameters['_ts'] = sig.ts;
      options.queryParameters['_sig'] = sig.sig;

      // multipart 请求 apikey/_sig/_ts 必须同时出现在 body 字段里，仅塞 query 会被判签名缺失。
      final data = options.data;
      if (data is FormData) {
        data.fields.addAll([
          MapEntry('apikey', FrodoConstants.apiKey),
          MapEntry('_ts', sig.ts),
          MapEntry('_sig', sig.sig),
        ]);
      }
    } else {
      options.headers['Cookie'] = FrodoConstants.cookie;
    }

    handler.next(options);
  }
}

class _Signature {
  const _Signature(this.sig, this.ts);
  final String sig;
  final String ts;
}

/// 复现 Postman pre-request 算法：
/// 1. path = url-decode(path)；若长度 > 1 且以 / 结尾则去掉末尾 /
/// 2. encodedPath = url-encode(path)
/// 3. message = METHOD & encodedPath [& bearer] & ts
/// 4. _sig = base64(HMAC-SHA1(secret, message))
_Signature _signFrodo({
  required String method,
  required String path,
  String? bearer,
}) {
  String decoded = Uri.decodeComponent(path);
  if (decoded.length > 1 && decoded.endsWith('/')) {
    decoded = decoded.substring(0, decoded.length - 1);
  }
  final encodedPath = Uri.encodeComponent(decoded);
  final ts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

  final parts = <String>[method.toUpperCase(), encodedPath];
  if (bearer != null && bearer.isNotEmpty) parts.add(bearer);
  parts.add(ts);
  final message = parts.join('&');

  final hmac = Hmac(sha1, utf8.encode(FrodoConstants.frodoSignSecret));
  final digest = hmac.convert(utf8.encode(message));
  return _Signature(base64.encode(digest.bytes), ts);
}

/// 简单日志拦截器（debug 模式下打印简短摘要）
class SimpleLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) debugPrint('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) debugPrint('← ${response.statusCode} ${response.requestOptions.uri.path}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) debugPrint('✗ ${err.response?.statusCode} ${err.requestOptions.uri} → ${err.message}');
    handler.next(err);
  }
}
