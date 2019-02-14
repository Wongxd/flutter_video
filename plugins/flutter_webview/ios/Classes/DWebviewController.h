#import <UIKit/UIKit.h>
#import "dsbridge.h"
@interface DWebviewController : UIViewController<WKNavigationDelegate>
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSDictionary *primaryColor;
@property(nonatomic, copy) NSDictionary *titleColor;
@end
