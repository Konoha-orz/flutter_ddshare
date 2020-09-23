import 'dart:async';

import 'package:flutter/services.dart';

import 'response/ddshare_response.dart';

class FlutterDdshare {
  static MethodChannel _channel = MethodChannel('com.nbyjy/flutter_ddshare')
    ..setMethodCallHandler(_methodHandler);

  static StreamController<BaseDDShareResponse>
      _ddResponseEventHandlerController = new StreamController.broadcast();

  /// 钉钉授权等回调信息.
  static Stream<BaseDDShareResponse> get ddResponseEventHandler =>
      _ddResponseEventHandlerController.stream;

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 注册钉钉
  static Future<bool> registerApp(String appId, String iosBundleId) async {
    return await _channel
        .invokeMethod('registerApp', {"appId": appId, "bundleId": iosBundleId});
  }

  /// 是否安装了钉钉
  static Future<bool> isDDAppInstalled() async {
    bool result = false;
    try {
      result = await _channel.invokeMethod('isDDAppInstalled');
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// 钉钉登录授权
  static Future<bool> sendDDAppAuth(String state) async {
    bool result = false;
    try {
      result = await _channel
          .invokeMethod('sendDDAppAuth', {"state": "$state", "test": "test"});
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// 分享文本
  static Future<bool> sendTextMessage(String text,
      {bool isSendDing = false}) async {
    bool result = false;
    try {
      result = await _channel.invokeMethod(
          'sendTextMessage', {"text": "$text", "isSendDing": isSendDing});
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// 分享网页链接
  static Future<bool> sendWebPageMessage(String url,
      {bool isSendDing = false,
      String title,
      String content,
      String thumbUrl}) async {
    bool result = false;
    try {
      result = await _channel.invokeMethod('sendWebPageMessage', {
        "url": url,
        "isSendDing": isSendDing,
        'title': title,
        'content': content,
        'thumbUrl': thumbUrl
      });
    } catch (e) {
      print(e);
    }
    return result;
  }

  /// 分享图片
  static Future<bool> sendImageMessage(
      {bool isSendDing = false, String picUrl, String picPath}) async {
    //必传一个
    if (picUrl == null && picPath == null) {
      return false;
    }
    bool result = false;
    try {
      result = await _channel.invokeMethod('sendImageMessage', {
        "picUrl": picUrl,
        "isSendDing": isSendDing,
        'picPath': picPath,
      });
    } catch (e) {
      print(e);
    }
    return result;
  }

  ///
  static Future _methodHandler(MethodCall methodCall) {
    var response =
        BaseDDShareResponse.create(methodCall.method, methodCall.arguments);
    _ddResponseEventHandlerController.add(response);
    return Future.value();
  }
}
