import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void OnWebViewJavaScriptToVideoDetailHandler(String id);

class Webview {
  static const MethodChannel _channel = const MethodChannel('webview');
  List<OnWebViewJavaScriptToVideoDetailHandler>
      webViewJavaScriptToVideoDetailHandlers = [];
  // Webview() {
  //   _channel.setMethodCallHandler((MethodCall call) {
  //     switch (call.method) {
  //       case 'videoDetail':
  //         exexWebViewJavaScriptToVideoDetailHandlers(call.arguments);
  //         break;
  //       default:
  //         break;
  //     }
  //   });
  // }

  // // 设置当需要进入视频详情的事件
  // void addWebViewJavaScriptToVideoDetailHandler(
  //     OnWebViewJavaScriptToVideoDetailHandler handler) {
  //   webViewJavaScriptToVideoDetailHandlers.add(handler);
  // }

  // // 派发事件
  // void exexWebViewJavaScriptToVideoDetailHandlers(dynamic args) {
  //   for (var i in webViewJavaScriptToVideoDetailHandlers) {
  //     i(args);
  //   }
  // }

  static Future<void> load(
    String url, {
    Color primaryColor: Colors.blue,
    Color titleColor: Colors.white,
  }) async {
    await _channel.invokeMethod('load', {
      "url": url,
      "primaryColor": {
        "red": primaryColor.red,
        "green": primaryColor.green,
        "blue": primaryColor.blue,
        "alpha": primaryColor.alpha,
      },
      "titleColor": {
        "red": titleColor.red,
        "green": titleColor.green,
        "blue": titleColor.blue,
        "alpha": titleColor.alpha,
      }
    });
  }
}
