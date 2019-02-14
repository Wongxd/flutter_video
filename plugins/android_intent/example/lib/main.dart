import 'dart:io';

import 'package:flutter/material.dart';

import 'package:android_intent/android_intent.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String schemeOrPackageName = "com.eg.android.AlipayGphone";
  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      schemeOrPackageName = "alipay://";
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            MaterialButton(
              onPressed: () async {
                await AndroidIntent.launchApp(schemeOrPackageName, itemId: "333206289");
              },
              child: Text("launchApp"),
            ),
            MaterialButton(
              onPressed: () async {
                print(await AndroidIntent.isAppInstalled(schemeOrPackageName));
              },
              child: Text("isAppInstalled"),
            ),
          ],
        )
      ),
    );
  }
}
