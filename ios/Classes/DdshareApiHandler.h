//
//  Created by Konoha on 2020/9/23.
//
#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <DTShareKit/DTOpenAPIObject.h>
#import <DTShareKit/DTOpenKit.h>
#import <DTShareKit/DTOpenAPI.h>

@interface DdshareApiHandler : NSObject

- (instancetype)initWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar methodChannel:(FlutterMethodChannel *)flutterMethodChannel;

- (void)getPlatformVersion:(FlutterMethodCall *)call result:(FlutterResult)result;

///注册App
- (void)registerApp:(FlutterMethodCall *)call result:(FlutterResult)result;

///钉钉是否安装
- (void)isDDAppInstalled:(FlutterMethodCall *)call result:(FlutterResult)result;

///钉钉授权
- (void)sendDDAppAuth:(FlutterMethodCall *)call result:(FlutterResult)result bundleId:(NSString *)bundleId;

///分享文本
- (void)sendTextMessage:(FlutterMethodCall *)call result:(FlutterResult)result;

///分享链接
- (void)sendWebPageMessage:(FlutterMethodCall *)call result:(FlutterResult)result;

///分享图片
- (void)sendImageMessage:(FlutterMethodCall *)call result:(FlutterResult)result;
@end
