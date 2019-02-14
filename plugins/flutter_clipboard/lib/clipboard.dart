import 'dart:async';

import 'package:flutter/services.dart';

class ClipboardManager {
  static const MethodChannel _channel =
      const MethodChannel('clipboard');

  static copy(String content) async {
    await _channel.invokeMethod('copy', {
      "content": content
    });
  }
  static Future<String> read() async {
    String s = await _channel.invokeMethod('read');
    return Future.value(s);
  }
}
