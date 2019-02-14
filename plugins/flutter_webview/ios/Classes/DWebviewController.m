#import "DWebviewController.h"
#import <WebKit/WebKit.h>
// #import "JsApi.h"

@interface DWebviewController ()
@property (nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) DWKWebView *dwebview;
@property UIColor *parsedPrimaryColor;
@property UIColor *parsedTitleColor;
@property UINavigationItem *navItem;
@property CGRect bounds;
@property NSUInteger heightOfStatusbar;
@property NSUInteger heightOfNavigationBar;
@property NSUInteger heightOfAll;

@end
// TODO JS桥接
@implementation DWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取主要颜色值
//    NSInteger primaryColorRed = [self.primaryColor[@"red"] intValue];
//    NSInteger primaryColorGreen = [self.primaryColor[@"green"] intValue];
//    NSInteger primaryColorBlue = [self.primaryColor[@"blue"] intValue];
//    NSInteger primaryColorAlpha = [self.primaryColor[@"alpha"] intValue];
    self.parsedPrimaryColor = [UIColor colorWithRed:[self.primaryColor[@"red"] intValue]/255.0 green:[self.primaryColor[@"green"] intValue]/255.0 blue:[self.primaryColor[@"blue"] intValue]/255.0 alpha:[self.primaryColor[@"alpha"] intValue]]; // 设置颜色
    // 获取文字颜色
    self.parsedTitleColor = [UIColor colorWithRed:[self.titleColor[@"red"] intValue]/255.0 green:[self.titleColor[@"green"] intValue]/255.0 blue:[self.titleColor[@"blue"] intValue]/255.0 alpha:[self.titleColor[@"alpha"] intValue]]; // 设置颜色
    
    self.view.backgroundColor = self.parsedPrimaryColor; // 设置颜色
    self.heightOfStatusbar = [[UIApplication sharedApplication] statusBarFrame].size.height;
    self.heightOfNavigationBar = 44;
    self.heightOfAll = self.heightOfStatusbar + self.heightOfNavigationBar;
    
    self.bounds = self.view.bounds;
    
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.dwebview];
    
    // 监听事件进度条事件
    [self.dwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    // 监听页面title变化事件
    [self.dwebview addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];

    
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    request.timeoutInterval = 15.0f;
    [self.dwebview loadRequest:request];

}

// 构建webview
- (WKWebView *)dwebview {
    if (!_dwebview) {
        _dwebview =[[DWKWebView alloc] initWithFrame:CGRectMake(0, self.heightOfAll, self.bounds.size.width, self.bounds.size.height - self.heightOfAll)];
        [self.view addSubview:_dwebview];
        [_dwebview setDebugMode:false];
        [_dwebview customJavascriptDialogLabelTitles:@{@"alertTitle":@"Notification",@"alertBtn":@"OK"}];
//        [_dwebview addJavascriptObject:[[JsEApi alloc] init] namespace:@"dd"];
        _dwebview.navigationDelegate = self;
    }
    return _dwebview;
}
// 构建进度条
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, self.heightOfAll, self.bounds.size.width, 2)];
        _progressView.backgroundColor = [UIColor blueColor];
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
    return _progressView;
}
// 构建导航栏
-(UINavigationBar *) navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, self.heightOfStatusbar, self.bounds.size.width, self.heightOfNavigationBar)];

        _navigationBar.barStyle = UIBarStyleDefault;
        _navigationBar.translucent = false;
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _navigationBar.barTintColor = self.parsedPrimaryColor; // 设置颜色
        _navigationBar.tintColor = self.parsedTitleColor;
        _navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName: self.parsedTitleColor };
        
        // navigationBar button items 用系统图标
        UIBarButtonItem *quitItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(quitAction:)];
        UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction:)];

        
        // UINavigationItem
        self.navItem = [[UINavigationItem alloc] initWithTitle:@"正在加载..."];
        self.navItem.leftBarButtonItem = quitItem;
        self.navItem.rightBarButtonItem = refreshItem;
        [_navigationBar pushNavigationItem:self.navItem animated:NO];
        
    }
    return _navigationBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
// 退出
- (void)quitAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:true completion:nil];

}
// 刷新
- (void)refreshAction:(UIButton *)sender {
    [self.dwebview reload];
}

/*
 *4.在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
 */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) { // 监听进度
        self.progressView.progress = self.dwebview.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) { // 监听title
        NSLog(@"%@", self.dwebview.title);
        self.navItem.title = self.dwebview.title;
    } else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"开始加载网页");
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
//    self.textField.text = [NSString stringWithFormat:@"%@",webView.URL];
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败");
    //加载失败同样需要隐藏progressView
    self.progressView.hidden = YES;
}

//页面跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //允许页面跳转
    
    NSURL *URL = navigationAction.request.URL;
    NSLog(@"%@", URL);
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) { // 支持tel://协议
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
       
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}

@end
