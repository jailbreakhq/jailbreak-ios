//
//  STKWebKitViewController.m
//  STKWebKitViewController
//
//  Created by Marc on 03.09.14.
//  Copyright (c) 2014 sticksen. All rights reserved.
//

#import <RTSpinKitView.h>
#import "UIColor+JBAdditions.h"
#import "STKWebKitViewController.h"

@interface STKWebKitViewController ()

@property(nonatomic) NSMutableArray *viewConstraints;
@property(nonatomic) UIColor *savedNavigationbarTintColor;
@property (nonatomic, strong) RTSpinKitView *loadingIndicatorView;

@property(nonatomic) NSURLRequest *request;

@end

@implementation STKWebKitViewController

- (instancetype)init
{
    return [self initWithURL:nil];
}

- (instancetype)initWithAddress:(NSString *)urlString
{
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (instancetype)initWithURL:(NSURL *)url
{
    return [self initWithURL:url userScript:nil];
}

- (instancetype)initWithURL:(NSURL *)url userScript:(WKUserScript *)script
{
    return [self initWithRequest:[NSURLRequest requestWithURL:url] userScript:script];
}

- (instancetype)initWithAddress:(NSString *)string userScript:(WKUserScript *)script
{
    return [self initWithURL:[NSURL URLWithString:string] userScript:script];
}

- (instancetype)initWithRequest:(NSURLRequest *)request
{
    return [self initWithRequest:request userScript:nil];
}

- (instancetype)initWithRequest:(NSURLRequest *)request userScript:(WKUserScript *)script
{
    if (self = [super init])
    {
        NSAssert([[UIDevice currentDevice].systemVersion floatValue] >= 8.0, @"WKWebView is available since iOS8. Use UIWebView, if you´re running an older version");
        NSAssert([NSThread isMainThread], @"WebKit is not threadsafe and this function is not executed on the main thread");
        
        self.newTabOpenMode = OpenNewTabExternal;
        self.request = request;
        if (script)
        {
            WKUserContentController *userContentController = [[WKUserContentController alloc] init];
            [userContentController addUserScript:script];
            WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
            configuration.userContentController = userContentController;
            _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        }
        else
        {
            _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        }
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
        
        self.loadingIndicatorView = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave];
        self.loadingIndicatorView.hidesWhenStopped = YES;
        self.loadingIndicatorView.color = [UIColor colorWithHexString:@"#B41C21"];
        [self.loadingIndicatorView stopAnimating];
        [self.view addSubview:self.loadingIndicatorView];
    }
    return self;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSAssert(self.navigationController, @"STKWebKitViewController needs to be contained in a UINavigationController. If you are presenting STKWebKitViewController modally, use STKModalWebKitViewController instead.");
    
    [self.view setNeedsUpdateConstraints];
    
    self.savedNavigationbarTintColor = self.navigationController.navigationBar.barTintColor;

    if (self.navigationBarTintColor) {
        self.navigationController.navigationBar.barTintColor = self.navigationBarTintColor;
    }

    [self addObserver:self forKeyPath:@"webView.title" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"webView.loading" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"webView.estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];

    if (self.request) {
        [self.webView loadRequest:self.request];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = self.savedNavigationbarTintColor;

    [self removeObserver:self forKeyPath:@"webView.title"];
    [self removeObserver:self forKeyPath:@"webView.loading"];
    [self removeObserver:self forKeyPath:@"webView.estimatedProgress"];
}

- (BOOL)prefersStatusBarHidden
{
    return self.navigationController.navigationBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationSlide;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"webView.title"])
    {
        self.title = change[@"new"];
    }
    else if ([keyPath isEqualToString:@"webView.loading"])
    {
        if (self.webView.isLoading)
        {
            [self.loadingIndicatorView startAnimating];
        }
        else
        {
            [self.loadingIndicatorView stopAnimating];
        }
    }
    else if ([keyPath isEqualToString:@"webView.estimatedProgress"])
    {
        
    }
}

- (void)viewDidLayoutSubviews
{
    self.webView.frame = self.view.bounds;
    self.loadingIndicatorView.center = self.view.center;
}

#pragma mark -

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if (!navigationAction.targetFrame) { //this is a 'new window action' (aka target="_blank") > open this URL as configured in 'self.newTabOpenMode'. If we´re doing nothing here, WKWebView will also just do nothing. Maybe this will change in a later stage of iOS 8
        if (self.newTabOpenMode == OpenNewTabExternal) {
            NSURL *url = navigationAction.request.URL;
            UIApplication *app = [UIApplication sharedApplication];
            if ([app canOpenURL:url]) {
                [app openURL:url];
            }
        } else if (self.newTabOpenMode == OpenNewTabInternal) {
            [webView loadRequest:navigationAction.request];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self.webView.scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO]; //otherwise top of website is sometimes hidden under Navigation Bar
}

@end
