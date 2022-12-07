//
//  WebViewController.h
//  Sample App Objective-C
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : ViewController<WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, strong) WKWebView *webView;

@end

NS_ASSUME_NONNULL_END
