import 'dart:async';

import 'package:flutter/services.dart';

class Loading {
  static const MethodChannel _channel =
      const MethodChannel('loading');

  static Future<void> show([String text = ""]) async {
    await _channel.invokeMethod('show', {
      "text": text,
    });
  }
  static Future<void> hide() async {
    await _channel.invokeMethod('hide');
  }
}
