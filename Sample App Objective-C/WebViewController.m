//
//  WebViewController.m
//  Sample App Objective-C
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)loadView {
    // Configure the web view
    WKWebViewConfiguration * webConfiguration = [[WKWebViewConfiguration alloc] init];
    self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfiguration];
    [self.webView setUIDelegate:self];
    [self.webView setNavigationDelegate:self];
    self.view = self.webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // The notice should automatically get hidden in the web view as consent is passed from the mobile app to the website.
    // However, it might happen that the notice gets displayed for a very short time before being hidden.
    // You can disable the notice in your web view to make sure that it never shows by appending didomiConfig.notice.enable=false
    // to the query string of the URL that you are loading
    NSURL *url = [NSURL URLWithString:@"https://didomi.github.io/webpage-for-sample-app-webview/?didomiConfig.notice.enable=false"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    // Inject consent information into the web view
    Didomi *didomi = [Didomi shared];
    [didomi onReadyWithCallback:^{
        NSString *string = [didomi getJavaScriptForWebViewWithExtra:@""];
        WKUserScript *script = [[WKUserScript alloc] initWithSource:string injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:FALSE];
        [[[[self webView] configuration] userContentController] addUserScript:script];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
