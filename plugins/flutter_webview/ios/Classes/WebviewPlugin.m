#import "WebviewPlugin.h"
#import "DWebviewController.h"

@implementation WebviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"webview"
            binaryMessenger:[registrar messenger]];
  // WebviewPlugin* instance = [[WebviewPlugin alloc] init];
  WebviewPlugin *instance = [WebviewPlugin new];
//  instance.hostViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    
  instance.hostViewController = (UIViewController *)registrar.messenger;
    
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"load" isEqualToString:call.method]) {
    NSString *url = call.arguments[@"url"];
    NSDictionary *primaryColor = call.arguments[@"primaryColor"];
    NSDictionary *titleColor = call.arguments[@"titleColor"];
    DWebviewController *dWebviewController = [[DWebviewController alloc] init];
    
    dWebviewController.url = url;
    dWebviewController.primaryColor = primaryColor;
    dWebviewController.titleColor = titleColor;
//      dWebviewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical; // 可以设置几种动画
    [self.hostViewController presentViewController:dWebviewController animated:YES completion:nil];
    // result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
