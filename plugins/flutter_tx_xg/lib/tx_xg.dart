import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

typedef void OnNotifyMessageActivatedCallback(dynamic);
typedef void OnNotifyErrorCallback(dynamic);

class TxXg {
  static const EventChannel _channel = const EventChannel('tx_xg');
  static StreamSubscription _subscription;
  static List<OnNotifyMessageActivatedCallback> _onNotifyMessageActivatedCallbacks = [];
  static List<OnNotifyErrorCallback> _onNotifyErrorCallbacks = [];
  
  static init(OnNotifyMessageActivatedCallback onNotifyMessageCallback,
      OnNotifyErrorCallback onNotifyErrorCallback) {
    // 加入数组
    _onNotifyMessageActivatedCallbacks.add(onNotifyMessageCallback);
    _onNotifyErrorCallbacks.add(onNotifyErrorCallback);

    _subscription = _channel.receiveBroadcastStream().listen((dynamic event) {
      // 收到消息
      if (event["customContent"] != null) {
        event["customContent"] = json.decode(event["customContent"]);
      } else {
        event["customContent"] = {};
      }
      _onNotifyMessageActivatedCallbacks.forEach((Function fn) {
        // 发送事件
        fn(event);
      });
    }, onError: (dynamic err) {
      _onNotifyErrorCallbacks.forEach((Function fn) {
        // 发送错误
        fn(err);
      });
    });
  }

  static cancel() {
    if (_subscription != null) {
      _subscription.cancel();
    }
  }
}
