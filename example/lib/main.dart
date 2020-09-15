import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ddshare/flutter_ddshare.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  bool _isDDAppInstalled= null;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool isRegisterApp;
    bool isDDAppInstalled;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterDdshare.platformVersion;
      isRegisterApp=await FlutterDdshare.registerApp('dingoaee4mq7tb6luuyugg','com.yjy.yijiayi');
      isDDAppInstalled=await FlutterDdshare.isDDAppInstalled();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _isDDAppInstalled=isDDAppInstalled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Running on: $_platformVersion\n')],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('Ding Ding installed: $_isDDAppInstalled\n')],
              ),
              Row(
                children: [
                  FlatButton(
                      onPressed: () async {
                        bool result = await FlutterDdshare.isDDAppInstalled();
                        print('====================$result');
                      },
                      child: Text('钉钉'))
                ],
              ),
              Row(
                children: [
                  FlatButton(
                      onPressed: () async {
                        bool result = await FlutterDdshare.sendDDAppAuth('test');
                        print('====================$result');
                      },
                      child: Text('授权'))
                ],
              )
            ],
          )),
    );
  }
}
