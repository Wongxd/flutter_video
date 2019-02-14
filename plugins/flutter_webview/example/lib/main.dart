import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:webview/webview.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Webview webView;
  @override
  void initState() {
    super.initState();
    // webView = new Webview();
    // webView.addWebViewJavaScriptToVideoDetailHandler((String id) {
    //   print(id);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: new MaterialButton(
            onPressed: () async {
              // print(Theme.of(context).primaryColor);
              await Webview.load("https://jd.com", primaryColor: Theme.of(context).primaryColor);
            },
            child: Text("load"),
          )
        ),
      ),
    );
  }
}
