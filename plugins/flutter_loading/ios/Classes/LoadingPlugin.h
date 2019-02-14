#import <Flutter/Flutter.h>
#import "MBProgressHUD.h"

@interface LoadingPlugin : NSObject<FlutterPlugin>
@property (nonatomic, assign) UIViewController *hostViewController;
@property MBProgressHUD *hud;
@end
