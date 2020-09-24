import 'dart:async';

import 'package:flutter/services.dart';

import 'response/ddshare_response.dart';

///DingTalk Flutter Plugin
class FlutterDdshare {
  ///channel
  static MethodChannel _channel = MethodChannel('com.nbyjy/flutter_ddshare')
    ..setMethodCallHandler(_methodHandler);

  ///回调响应SteamController
  static StreamController<BaseDDShareResponse>
      _ddResponseEventHandlerController = new StreamController.broadcast();

  /// DingTalk api response callback Steam
  /// 钉钉授权等回调信息.
  static Stream<BaseDDShareResponse> get ddResponseEventHandler =>
      _ddResponseEventHandlerController.stream;

  ///获取平台信息
  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// [iosBundleId] is necessary on IOS
  /// 注册钉钉,IOS端必传buindleId
  static Future<bool> registerApp(String appId, String iosBundleId) async {
    return await _channel
        .invokeMethod('registerApp', {"appId": appId, "bundleId": iosBundleId});
  }

  /// true if DingTalk installed,otherwise false.
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

  /// The DingTalk-Login is under Auth-2.0
  /// This method login with native DingTalk app.
  /// This method only supports getting AuthCode,this is first step to login with DingTalk
  /// Once AuthCode got, you need to request Access_Token
  /// For more information please visit：
  /// * https://ding-doc.dingtalk.com/doc#/native/ddvlch
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

  /// [picUrl] is necessary on IOS
  /// 分享图片（IOS端必传picUrl）
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

  ///DingTalk response method handler
  ///响应处理
  static Future _methodHandler(MethodCall methodCall) {
    var response =
        BaseDDShareResponse.create(methodCall.method, methodCall.arguments);
    _ddResponseEventHandlerController.add(response);
    return Future.value();
  }
}
