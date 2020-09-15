#import <Flutter/Flutter.h>
#import <DTShareKit/DTOpenAPIObject.h>
#import <DTShareKit/DTOpenKit.h>
#import <DTShareKit/DTOpenAPI.h>

@interface FlutterDdsharePlugin : NSObject<DTOpenAPIDelegate,FlutterPlugin>

- (instancetype) initWithFlutterPluginRegistrar: (NSObject <FlutterPluginRegistrar> *) registrar;

@end
