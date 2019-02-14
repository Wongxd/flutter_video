#import <Flutter/Flutter.h>

@interface WebviewPlugin : NSObject<FlutterPlugin>
@property (nonatomic, assign) UIViewController *hostViewController;
@end
