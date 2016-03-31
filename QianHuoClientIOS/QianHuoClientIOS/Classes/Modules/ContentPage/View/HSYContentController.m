//
//  HSYContentController.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/31.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYContentController.h"
#import "HSYContentViewmodel.h"
#import "Masonry.h"
#import "UIWebView+FY.h"

@interface HSYContentController () <UIWebViewDelegate>

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) HSYContentViewmodel *viewmodel;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation HSYContentController

- (instancetype)initWithUrl:(NSString*)url {
    self = [super init];
    if (self) {
        self.urlStr = url;
        self.viewmodel = [[HSYContentViewmodel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupWebView];
}

- (void)setupWebView {
    
    self.webView = [[UIWebView alloc] init];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.opaque = NO;
    self.webView.scalesPageToFit = YES;
    self.webView.scrollView.bounces = YES;
    self.webView.delegate = self;
    
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.webView loadRequest:[self.viewmodel webRequestWithUrl:self.urlStr]];
}

- (void)dealloc {
    [self.webView cleanForDealloc];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.webView cleanWhenDidFinishLoad];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

@end
