#import "LoadingPlugin.h"


@implementation LoadingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"loading"
            binaryMessenger:[registrar messenger]];
    LoadingPlugin *instance = [LoadingPlugin new];
    
    instance.hostViewController = (UIViewController *)registrar.messenger;
    
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
   
  if ([@"show" isEqualToString:call.method]) {
      NSString *text = call.arguments[@"text"];
      [self hideHud];
      self.hud = [MBProgressHUD showHUDAddedTo:self.hostViewController.view animated:YES];
      self.hud.label.text = text;
//      self.hud.label.backgroundColor = [UIColor blueColor];
//      self.hud.backgroundColor = [UIColor blueColor];
      self.hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
      self.hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.3f];


    // result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"hide" isEqualToString:call.method]) {
      [self hideHud];
      
  } else {
    result(FlutterMethodNotImplemented);
  }
}
- (void)hideHud {
    if (self.hud != nil) {
        [self.hud hideAnimated:YES];
    }
}
@end
