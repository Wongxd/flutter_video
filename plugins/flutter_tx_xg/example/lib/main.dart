import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:tx_xg/tx_xg.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initXG();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initXG() async {
    await TxXg.init((o) {
      print("------------");
      print("推送被点击了");
      print(o);
      print("------------");
    }, (e) {});
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new Text('XG'),
        ),
      ),
    );
  }
}
