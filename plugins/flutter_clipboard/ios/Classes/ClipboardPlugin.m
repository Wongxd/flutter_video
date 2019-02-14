#import "ClipboardPlugin.h"

@implementation ClipboardPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"clipboard"
            binaryMessenger:[registrar messenger]];
  ClipboardPlugin* instance = [[ClipboardPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}
 
- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  NSString *content = call.arguments[@"content"];
  if ([@"copy" isEqualToString:call.method]) {
    // 拷贝到剪贴板
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = content;
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
