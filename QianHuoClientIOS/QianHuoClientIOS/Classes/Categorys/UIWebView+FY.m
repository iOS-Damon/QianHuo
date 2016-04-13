//
//  UIWebView+FY.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/31.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "UIWebView+FY.h"

@implementation UIWebView (FY)

- (void)cleanWhenDidFinishLoad {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cleanForDealloc {
    [self stopLoading];
    [self loadHTMLString:@"" baseURL:nil];
    self.delegate = nil;
    [self removeFromSuperview];
//    [[NSURLCache sharedURLCache] removeAllCachedResponses];
//    [[NSURLCache sharedURLCache] setDiskCapacity:0];
//    [[NSURLCache sharedURLCache] setMemoryCapacity:0];
}

@end
