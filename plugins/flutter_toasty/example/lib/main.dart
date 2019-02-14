import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:toasty/toasty.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   String platformVersion;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     platformVersion = await Toasty.platformVersion;
  //   } on PlatformException {
  //     platformVersion = 'Failed to get platform version.';
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   if (!mounted) return;

  //   setState(() {
  //     _platformVersion = platformVersion;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 60.0,
              color: Colors.green,
              child: MaterialButton(
                onPressed: () {
                  Toasty.success("success");
                },
                child: Text("success"),
              ),
            ),
            Container(
              height: 60.0,
              color: Colors.green,
              child: MaterialButton(
                onPressed: () {
                  Toasty.info("info");
                },
                child: Text("info"),
              ),
            ),
            Container(
              height: 60.0,
              color: Colors.green,
              child: MaterialButton(
                onPressed: () {
                  Toasty.warning("warning");
                },
                child: Text("warning"),
              ),
            ),
            Container(
              height: 60.0,
              color: Colors.green,
              child: MaterialButton(
                onPressed: () {
                  Toasty.normal("normal");
                },
                child: Text("normal"),
              ),
            ),
            Container(
              height: 60.0,
              color: Colors.green,
              child: MaterialButton(
                onPressed: () {
                  Toasty.error("error");
                },
                child: Text("error"),
              ),
            )
          ],
        )
      ),
    );
  }
}
