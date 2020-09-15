#import "FlutterDdsharePlugin.h"
#import <DTShareKit/DTOpenKit.h>

typedef void (^Handler)(NSObject <FlutterPluginRegistrar> *,NSDictionary<NSString *,NSObject *> *,FlutterResult);

@implementation FlutterDdsharePlugin{
    NSObject <FlutterPluginRegistrar> *_registrar;
    NSDictionary<NSString *,Handler> *_handlerMap;
    NSString *_bundleId;
    NSString *_appId;
    FlutterMethodChannel *_channel;
}

- (instancetype) initWithFlutterPluginRegistrar:(NSObject <FlutterPluginRegistrar> *) registrar{
    self = [super init];
    if(self){
        _registrar=registrar;
        //方法调用处理
        _handlerMap=@{
            @"getPlatformVersion":^(NSObject <FlutterPluginRegistrar> * registrar,NSDictionary<NSString *,id> * args,FlutterResult methodResult){
                methodResult([@"iOS " stringByAppendingString:
                              [[UIDevice currentDevice] systemVersion]]);
            },
            @"registerApp":^(NSObject <FlutterPluginRegistrar> * registrar,NSDictionary<NSString *,id> * args,FlutterResult methodResult){
                NSString* appId=(NSString*) args[@"appId"];
                _appId=appId;
                NSString* bundleId=(NSString*) args[@"bundleId"];
                _bundleId=bundleId;
                BOOL registerResult= [DTOpenAPI registerApp: appId];
                NSLog(@"[FlutterDDShareLog]:注册API==>%@",registerResult?@"YES":@"NO");
                methodResult(@(registerResult));
            },
            @"isDDAppInstalled":^(NSObject <FlutterPluginRegistrar> * registrar,NSDictionary<NSString *,id> * args,FlutterResult methodResult){
                BOOL installed=[DTOpenAPI isDingTalkInstalled];
                methodResult(@(installed));
            },
            @"sendDDAppAuth":^(NSObject <FlutterPluginRegistrar> * registrar,NSDictionary<NSString *,id> * args,FlutterResult methodResult){
                // send oauth request
                DTAuthorizeReq *authReq = [DTAuthorizeReq new];
                authReq.bundleId = _bundleId;
                BOOL result = [DTOpenAPI sendReq:authReq];
                if (result) {
                    NSLog(@"授权登录 发送成功.");
                    methodResult([NSNumber numberWithBool:result]);
                }
                else {
                    NSLog(@"授权登录 发送失败.");
                    methodResult([FlutterError errorWithCode:@"authError" message:@"授权失败" details:authReq]);
                }
            },
        };
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"com.nbyjy/flutter_ddshare"
                                     binaryMessenger:[registrar messenger]];
    FlutterDdsharePlugin *instance=[[FlutterDdsharePlugin alloc] initWithFlutterPluginRegistrar:registrar];
    [registrar addMethodCallDelegate:instance channel:channel];
    //为插件提供ApplicationDelegate回调方法
    [registrar addApplicationDelegate:instance];
    [instance setChannel:channel];
}

-(void)setChannel:(FlutterMethodChannel *)channel{
    _channel=channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary<NSString *,id> *args=(NSDictionary<NSString *,id> *)[call arguments];
    
    if(_handlerMap[call.method]!=nil){
        _handlerMap[call.method](_registrar,args,result);
    }
    else {
        result(FlutterMethodNotImplemented);
    }
}

//// 在app delegate链接处理回调中调用钉钉回调链接处理方法
-(BOOL)handleOpenURL:(NSURL*)url{
    // URL回调判断是钉钉回调
    if ([url.scheme isEqualToString:_appId]) {
        if([DTOpenAPI handleOpenURL:url delegate:self]){
            NSLog(@"[FlutterDDShareLog]onpenURL===>");
        }
        return YES;
    }
    return NO;
}


// delegate实现回调处理方法 onResp:
- (void)onResp:(DTBaseResp *)resp
{
    //授权登录回调参数为DTAuthorizeResp，accessCode为授权码
    if ([resp isKindOfClass:[DTAuthorizeResp class]]) {
        DTAuthorizeResp *authResp = (DTAuthorizeResp *)resp;
        NSString *accessCode = authResp.accessCode;
        // 将授权码交给Flutter端
        NSLog(@"[FlutterDDShareLog]授权码回调=====>%@",accessCode);
        NSDictionary * result=@{@"code":accessCode};
        [_channel invokeMethod:@"onAuthResponse" arguments:result];
    }
}

#pragma ApplicatioonLifeCycle
/**
 * Called if this has been registered for `UIApplicationDelegate` callbacks.
 *
 * @return `YES` if this handles the request.
 */
- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options{
    return [self handleOpenURL:url];
}
/**
 * Called if this has been registered for `UIApplicationDelegate` callbacks.
 *
 * @return `YES` if this handles the request.
 */
- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url{
    return [self handleOpenURL:url];
}
/**
 * Called if this has been registered for `UIApplicationDelegate` callbacks.
 *
 * @return `YES` if this handles the request.
 */
- (BOOL)application:(UIApplication*)application
            openURL:(NSURL*)url
  sourceApplication:(NSString*)sourceApplication
         annotation:(id)annotation{
    return [self handleOpenURL:url];
}

@end
