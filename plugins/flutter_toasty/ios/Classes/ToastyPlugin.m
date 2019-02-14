#import "ToastyPlugin.h"
#import "Toast.h"

@implementation ToastyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"toasty"
            binaryMessenger:[registrar messenger]];
  ToastyPlugin* instance = [[ToastyPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  // create a new style
  CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
  UIView *view = [UIApplication sharedApplication].delegate.window.rootViewController.view;
  NSString *message = call.arguments[@"message"];
  if ([@"success" isEqualToString:call.method]) {
    // this is just one of many style options
    // style.messageColor = [UIColor orangeColor];
    style.backgroundColor = [UIColor colorWithRed:56.0 / 255.0 green:142.0 / 255.0 blue: 60.0 / 255.0 alpha:1.0];
    [view makeToast:message
                    duration:3.0
                    position:CSToastPositionBottom
                    style:style];
  } else if ([@"info" isEqualToString:call.method]) {
    style.backgroundColor = [UIColor colorWithRed:63.0 / 255.0 green:83.0 / 255.0 blue: 181.0 / 255.0 alpha:1.0];
    [view makeToast:message
                    duration:3.0
                    position:CSToastPositionBottom
                    style:style];

  } else if ([@"warning" isEqualToString:call.method]) {
    style.backgroundColor = [UIColor colorWithRed:255.0 / 255.0 green:169.0 / 255.0 blue: 0.0 / 255.0 alpha:1.0];
    [view makeToast:message
                    duration:3.0
                    position:CSToastPositionBottom
                    style:style];

  } else if ([@"normal" isEqualToString:call.method]) {
    style.backgroundColor = [UIColor colorWithRed:53.0 / 255.0 green:58.0 / 255.0 blue: 62.0 / 255.0 alpha:1.0];
    [view makeToast:message
                    duration:3.0
                    position:CSToastPositionBottom
                    style:style];

  } else if ([@"error" isEqualToString:call.method]) {
    style.backgroundColor = [UIColor colorWithRed:213.0 / 255.0 green:0.0 / 255.0 blue: 0.0 / 255.0 alpha:1.0];
    [view makeToast:message
                    duration:3.0
                    position:CSToastPositionBottom
                    style:style];

  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
