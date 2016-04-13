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
#import "UIView+FY.h"
#import "HSYLoadingManage.h"

static NSString * const HSYContentControllerLoadingID = @"HSYContentControllerLoadingID";

@interface HSYContentController () <UIWebViewDelegate>

@property (nonatomic, strong) NSString *urlStr;
@property (nonatomic, strong) HSYContentViewmodel *viewmodel;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *forwardBtn;

@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *forwardItem;

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
    [self setupToolbar];
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

- (void)setupToolbar {
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbar.tintColor = FYColorSub;
    
    CGFloat imgViewH = self.navigationController.toolbar.frameHeight * 0.6;
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgViewH, imgViewH)];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"WebBack.png"] forState:UIControlStateDisabled];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"WebBackNormal.png"] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(webGoBack:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
    self.backItem.enabled = NO;
    
    self.forwardBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, imgViewH, imgViewH)];
    [self.forwardBtn setBackgroundImage:[UIImage imageNamed:@"WebForward.png"] forState:UIControlStateDisabled];
    [self.forwardBtn setBackgroundImage:[UIImage imageNamed:@"WebForwardNormal.png"] forState:UIControlStateNormal];
    [self.forwardBtn addTarget:self action:@selector(webGoFrowark:) forControlEvents:UIControlEventTouchUpInside];
    
    self.forwardItem = [[UIBarButtonItem alloc] initWithCustomView:self.forwardBtn];
    self.forwardItem.enabled = NO;
    
    UIBarButtonItem *refreshItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(webRefresh:)];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = @[self.backItem, self.forwardItem, spaceItem, spaceItem, refreshItem];
    self.toolbarItems = items;
}

- (void)webGoBack:(id)sender {
    [self.webView goBack];
}

- (void)webGoFrowark:(id)sender {
    [self.webView goForward];
}

- (void)webRefresh:(id)sender {
    [self.webView reload];
}

- (void)setToolbarItemsEnable {
    if ([self.webView canGoBack]) {
        self.backItem.enabled = YES;
    } else {
        self.backItem.enabled = NO;
    }
    if ([self.webView canGoForward]) {
        self.forwardItem.enabled = YES;
    } else {
        self.forwardItem.enabled = NO;
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [[HSYLoadingManage sharedInstance] showLoadingForParentView:self.view withKey:HSYContentControllerLoadingID backgroundColor:[UIColor whiteColor]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.webView cleanWhenDidFinishLoad];
    
    [self setToolbarItemsEnable];
    
    [[HSYLoadingManage sharedInstance] hideLoadingWithKey:HSYContentControllerLoadingID];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[HSYLoadingManage sharedInstance] hideLoadingWithKey:HSYContentControllerLoadingID];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.webView cleanForDealloc];
}


@end
