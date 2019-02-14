#import "AndroidIntentPlugin.h"

@implementation AndroidIntentPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"android_intent"
            binaryMessenger:[registrar messenger]];
  AndroidIntentPlugin* instance = [[AndroidIntentPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *packageName = call.arguments[@"packageName"];
  NSString *itemId = call.arguments[@"itemId"];
  NSURL *url = [NSURL URLWithString:packageName];
  if ([@"launchApp" isEqualToString:call.method]) {
      
      if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
         
     } else {
//         NSLog(@"跳转到商店");
         // 跳转到对应的应用商店详情
         NSString *storeUrl = [@"itms-apps://itunes.apple.com/app/" stringByAppendingString:itemId];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:storeUrl]];
     }
    // result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"isAppInstalled" isEqualToString:call.method]) {
      result(@([[UIApplication sharedApplication] canOpenURL:url]));
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
