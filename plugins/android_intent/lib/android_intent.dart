import 'dart:async';

import 'package:flutter/services.dart';

class AndroidIntent {
  static const MethodChannel _channel = const MethodChannel('android_intent');

  // itemId for ios
  static Future<void> launchApp(String packageName, {String itemId = ""}) async {
    await _channel.invokeMethod('launchApp', {
      "packageName": packageName,
      "itemId": itemId,
    });
  }
  static Future<bool> isAppInstalled(String packageName) async {
    final bool isAppInstalled = await _channel.invokeMethod('isAppInstalled', {
      "packageName": packageName,
    });
    return isAppInstalled;
  }
}
