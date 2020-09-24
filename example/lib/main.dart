import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_ddshare/flutter_ddshare.dart';
import 'package:flutter_ddshare/response/ddshare_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDDAppInstalled = null;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool isRegisterApp;
    bool isDDAppInstalled;
    try {
      //注册APP
      isRegisterApp = await FlutterDdshare.registerApp(
          'dingoaee4mq7tb6luuyugg', 'yourIOSBundleId');

      //钉钉是否安装
      isDDAppInstalled = await FlutterDdshare.isDDAppInstalled();

      //处理回调
      FlutterDdshare.ddResponseEventHandler.listen((resp) async {
        //授权回调
        if (resp is DDShareAuthResponse) {
          //开发者确保回调state 与调用授权时传入state一致
          print('授权回调信息=====> code: ${resp.code}  state:${resp.state}');
        }
      });
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      _isDDAppInstalled = isDDAppInstalled;
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
                children: [Text('钉钉是否安装: $_isDDAppInstalled\n')],
              ),
              Row(
                children: [
                  FlatButton(
                      onPressed: () async {
                        bool result =
                            await FlutterDdshare.sendDDAppAuth('test');
                        print('授权调用 ==>$result');
                      },
                      child: Text('钉钉授权'))
                ],
              ),
              Row(
                children: [
                  FlatButton(
                      onPressed: () async {
                        bool result =
                            await FlutterDdshare.sendTextMessage('分享文本');
                        print('分享 ==>$result');
                      },
                      child: Text('分享文本'))
                ],
              ),
              Row(
                children: [
                  FlatButton(
                      onPressed: () async {
                        bool result = await FlutterDdshare.sendImageMessage(
                            picUrl:
                                'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png');
                        print('分享 ==>$result');
                      },
                      child: Text('分享图片'))
                ],
              ),
              Row(
                children: [
                  FlatButton(
                      onPressed: () async {
                        bool result = await FlutterDdshare.sendWebPageMessage(
                            'https://www.baidu.com/',
                            title: '标题',
                            content: '描述2333',
                            thumbUrl:
                                'https://www.baidu.com/img/PCtm_d9c8750bed0b3c7d089fa7d55720d6cf.png');
                        print('分享 ==>$result');
                      },
                      child: Text('分享链接'))
                ],
              )
            ],
          )),
    );
  }
}
