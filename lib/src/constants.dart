/// 全局常量。MVP 阶段直接使用 openapi.json 内置的样例凭证。
/// TODO(login): 接入真实登录后，从安全存储读取替换。
class FrodoConstants {
  const FrodoConstants._();

  /// frodo Bearer token（Authorization 头使用）
  static const String bearerToken = '4ec348a0f4e651b8ec49d9e2deb2f528';

  /// 当前用户 id（取自 cookie dbcl2 前半段，MVP 阶段写死）
  static const String defaultUserId = '147652575';

  /// www / m 站 Cookie（dbcl2 必填，bid/apiKey 锦上添花）
  static const String cookie =
      'dbcl2="147652575:9Bcz/c3lEy8"; bid=CvPYq587tVU; apiKey=0dad551ec0f84ed02907ff5c42e8ec70';

  /// apiKey（部分 frodo 接口需要在 query 中携带）
  static const String apiKey = '0dad551ec0f84ed02907ff5c42e8ec70';

  /// frodo HMAC-SHA1 签名密钥（来自社区逆向，与 client_secret 同值）
  static const String frodoSignSecret = 'bf7dddc7c9cfe6f7';

  /// 必须伪装成豆瓣 App，版本不能过低
  static const String userAgent =
      'api-client/1 com.douban.frodo/7.124.0(352) Android/30 '
      'udid/c397dcb9b23e3c07f63fbd5a195cee0cce6d39c2 '
      'douban_udid/3c1c9aab63a92380275149aac80cd3d3504031ae '
      'model/Pixel 5 brand/Google rom/android network/wifi '
      'platform/mobile foldable/0 nd/1 product/motion_phone_arm64 vendor/Genymobile';

  /// frodo 接口域名（Bearer 鉴权）
  static const String frodoBaseUrl = 'https://frodo.douban.com';

  /// rexxar / m 站接口域名（Cookie 鉴权）
  static const String rexxarBaseUrl = 'https://m.douban.com';

  /// www 站接口域名（Cookie 鉴权）
  static const String wwwBaseUrl = 'https://www.douban.com';

  /// 豆瓣图片 CDN 防盗链：缺 Referer 返回 403，缺/错 UA 返回 418（"I'm a teapot"）。
  /// 两个 header 都必须带。用法见 `widgets/frodo_image.dart` 的 [FrodoImage]。
  static const Map<String, String> imageHeaders = {
    'Referer': 'https://www.douban.com/',
    'User-Agent': userAgent,
  };
}
