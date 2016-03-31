//
//  HSYContentViewmodel.m
//  QianHuoClientIOS
//
//  Created by Sean on 16/3/31.
//  Copyright © 2016年 deeepthinking. All rights reserved.
//

#import "HSYContentViewmodel.h"

@implementation HSYContentViewmodel

- (NSURLRequest*)webRequestWithUrl:(NSString*)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    return request;
}

@end
