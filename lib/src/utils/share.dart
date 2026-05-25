import 'package:flutter/services.dart';

const _channel = MethodChannel('frodo/share');

Future<void> shareText(String text) async {
  await _channel.invokeMethod('share', {'text': text});
}
