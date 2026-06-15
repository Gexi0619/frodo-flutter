import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';

import '../constants.dart';

/// 把网络图片保存到系统相册。命中 extended_image 磁盘缓存就直用，否则带防盗链
/// header 重下一份。失败时抛 [GalException]（权限/空间等）或 [Exception]（下载/写入）。
Future<void> saveImageToGallery(String url) async {
  final bytes = await _fetchBytes(url);
  final ext = _extensionForBytes(bytes);

  // gal 只支持移动端，桌面没有"相册"概念：直接落到系统下载目录。
  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    await _saveToDownloads(bytes, ext);
    return;
  }

  // gal 在 Android 用老版 Apache Commons Imaging 识别格式，认不出 WebP（豆瓣
  // CDN 默认就吐 WebP），会抛 ArrayIndexOutOfBoundsException。绕开它：写到带
  // 正确扩展名的临时文件，走 Gal.putImage(path) 这条只看扩展名的分支。
  final file = await _writeTempImage(bytes, ext);
  try {
    await Gal.putImage(file.path);
  } finally {
    try {
      await file.delete();
    } catch (_) {}
  }
}

/// 桌面端：把图片写入系统下载目录，文件名带时间戳避免冲突。
Future<void> _saveToDownloads(Uint8List bytes, String ext) async {
  final dir = await getDownloadsDirectory();
  if (dir == null) throw Exception('无法定位下载目录');
  final name = 'frodo_${DateTime.now().microsecondsSinceEpoch}.$ext';
  await File('${dir.path}/$name').writeAsBytes(bytes, flush: true);
}

Future<Uint8List> _fetchBytes(String url) async {
  final cached = await getCachedImageFile(url);
  if (cached != null) {
    final bytes = await cached.readAsBytes();
    if (bytes.isNotEmpty) return bytes;
    // 早期 403 / 流截断的 0 字节坏缓存会一直命中，扔掉再重下。
    try {
      await cached.delete();
    } catch (_) {}
  }
  final resp = await _imageDio.get<List<int>>(
    url,
    options: Options(
      responseType: ResponseType.bytes,
      headers: FrodoConstants.imageHeaders,
    ),
  );
  final data = resp.data;
  if (data == null || data.isEmpty) {
    throw Exception('empty response (${resp.statusCode})');
  }
  return Uint8List.fromList(data);
}

final Dio _imageDio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 30),
    responseType: ResponseType.bytes,
  ),
);

String _extensionForBytes(Uint8List b) {
  if (b.length >= 3 && b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) {
    return 'jpg';
  }
  if (b.length >= 8 &&
      b[0] == 0x89 &&
      b[1] == 0x50 &&
      b[2] == 0x4E &&
      b[3] == 0x47) {
    return 'png';
  }
  if (b.length >= 6 &&
      b[0] == 0x47 &&
      b[1] == 0x49 &&
      b[2] == 0x46 &&
      b[3] == 0x38) {
    return 'gif';
  }
  if (b.length >= 12 &&
      b[0] == 0x52 &&
      b[1] == 0x49 &&
      b[2] == 0x46 &&
      b[3] == 0x46 &&
      b[8] == 0x57 &&
      b[9] == 0x45 &&
      b[10] == 0x42 &&
      b[11] == 0x50) {
    return 'webp';
  }
  return 'jpg';
}

Future<File> _writeTempImage(Uint8List bytes, String ext) async {
  final dir = await getTemporaryDirectory();
  final name = 'frodo_${DateTime.now().microsecondsSinceEpoch}.$ext';
  final file = File('${dir.path}/$name');
  await file.writeAsBytes(bytes, flush: true);
  return file;
}
